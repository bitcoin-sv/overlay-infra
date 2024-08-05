provider "aws" {
  region = var.region
}

module "vpc" {
  source                    = "./modules/vpc"
  vpc_cidr                  = var.vpc_cidr
  vpc_name                  = "${var.projectName}-vpc"
  igw_name                  = "${var.projectName}-igw"
  public_subnets            = var.public_subnets
  private_subnets           = var.private_subnets
  public_subnet_name        = "${var.projectName}-public-subnet"
  private_subnet_name       = "${var.projectName}-private-subnet"
  public_route_table_name   = "${var.projectName}-public-route-table"
  private_route_table_name  = "${var.projectName}-private-route-table"
  nat_gw_name               = "${var.projectName}-nat-gateway"
}

module "iam_roles" {
  source       = "./modules/iamRoles"
  region       = var.region
  cluster_name = "${var.projectName}-ecs-cluster"
}

module "log_group" {
  source       = "./modules/logGroup"
  cluster_name = "${var.projectName}-ecs-cluster"
}

module "security_groups" {
  source  = "./modules/securityGroups"
  vpc_id  = module.vpc.vpc_id
  sg_name = "${var.projectName}-sg"
  cluster_name = "${var.projectName}-ecs-cluster"
  vpc_cidr_block = var.vpc_cidr
}

module "ec2_instances" {
  source              = "./modules/ec2Instance"
  cluster_name        = "${var.projectName}-ecs-cluster"
  ecs_image           = var.ecs_image
  key_name            = var.key_name
  ecs_instance_type   = var.instance_type
  public_subnet_ids   = module.vpc.public_subnet_ids
  private_subnet_ids  = module.vpc.private_subnet_ids
  internal_access_sg  = module.security_groups.internal_access_sg_id
  bastion_sg_id       = module.security_groups.bastion_sg_id
  s3_bucket           = var.s3_bucket
  asg_min_size        = var.asg_min_size
  asg_desired_capacity = var.asg_desired_capacity
  asg_max_size        = var.asg_max_size
  ec2_instance_profile_name = module.iam_roles.ec2_instance_profile_name
  network_interface_private_ip = ["10.0.1.100"]
}

module "ecs_cluster" {
  source        = "./modules/ecsCluster"
  cluster_name  = "${var.projectName}-ecs-cluster"
}

module "ecs_task_definition" {
  source          = "./modules/ecsTaskDefinition"
  family          = "ecs-task"
  cpu             = "256"
  memory          = "256"
  container_name  = "${var.projectName}-${var.appName}-task-definition"
  container_image = "nginx"
  container_port  = 80
}

module "ecs_service" {
  source              = "./modules/ecsService"
  service_name        = "${var.projectName}-${var.appName}-ecs-service"
  cluster_id          = module.ecs_cluster.cluster_id
  task_definition_arn = module.ecs_task_definition.task_definition_arn
  desired_count       = 1
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_id   = module.security_groups.sg_id
  target_group_arn    = module.load_balancer.target_group_arn
  container_name      = "${var.projectName}-${var.appName}-task-definition"
  container_port      = 80
}

module "load_balancer" {
  source             = "./modules/loadBalancer"
  vpc_id             = module.vpc.vpc_id
  load_balancer_sg_id   = module.security_groups.load_balancer_sg_id
  internal_access_sg_id = module.security_groups.internal_access_sg_id
  security_group_id  = module.security_groups.sg_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  tg_name            = "${var.projectName}-${var.appName}-tg"
  cluster_name          = "${var.projectName}-ecs-cluster"
  certificate_arn       = var.certificate_arn
  lb_name               = "${var.projectName}-alb"
}

module "cloudwatch" {
  source                 = "./modules/cloudWatch"
  cluster_name           = "${var.projectName}-ecs-cluster"
  autoscaling_group_name = module.ec2_instances.autoscaling_group_name
}

module "rds_aurora" {
  source                = "./modules/rdsAurora"
  cluster_identifier    = "${var.cluster_name}-aurora-cluster"
  instance_class        = "db.t3.medium"
  instance_count        = 1
  master_username       = var.rds_master_username
  master_password       = var.rds_master_password
  database_name         = var.rds_database_name
  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"
  subnet_ids            = module.vpc.private_subnet_ids
  subnet_group_name     = "${var.cluster_name}-aurora-subnet-group"
  security_group_id     = module.security_groups.internal_access_sg_id
  final_snapshot_identifier = "${var.projectName}-${substr(md5(timestamp()), 0, 8)}"
}

module "application" {
  source                = "./modules/application"
  cluster_name          = var.cluster_name
  region                = var.region
  ecr_repo_name         = var.ecr_repo_name
  github_connection_arn = var.github_connection_arn
  project_name          = var.projectName

  DB_ENDPOINT           = module.rds_aurora.cluster_endpoint
  DB_PORT               = module.rds_aurora.cluster_port
  DB_USER               = var.rds_master_username
  DB_PASSWORD           = var.rds_master_password
  DB_NAME               = var.rds_database_name

  S3_BUCKET             = var.s3_bucket
}

module "overlay_app" {
  source                                = "./overlay-app"
  cluster_name                          = var.cluster_name
  project_name                          = var.projectName
  cluster_id                            = module.ecs_cluster.cluster_id
  docker_image_version                  = "${module.application.ecr_repository_url}:${var.image_tag}"
  db_host                               = module.rds_aurora.cluster_endpoint
  db_port                               = module.rds_aurora.cluster_port
  db_user                               = var.rds_master_username
  db_password                           = var.rds_master_password
  db_name                               = var.rds_database_name
  subnet_ids                            = module.vpc.private_subnet_ids
  security_group_id                     = module.security_groups.sg_id
  target_group_arn                      = module.load_balancer.target_group_arn
  aws_region                            = var.region
  has_https                             = "false"
  listener_arn                          = module.load_balancer.load_balancer_https_listener_arn
  environment_cname                     = "overlay-example.com"
  app_site_tg_priority                  = 10
  alb_health_check_interval             = 30
  alb_health_check_path                 = "/getDocumentationForLookupServiceProvider?lookupServices=ls_helloworld"
  alb_health_check_timeout              = 20
  alb_health_check_healthy_threshold    = 3
  alb_health_check_unhealthy_threshold  = 5
  alb_health_check_start_period         = 60
  container_network_mode                = "bridge"
  ecs_tasks_number                      = 1
  certificate_arn                       = var.certificate_arn
  task_memory_max                       = 512 
  task_virtual_cpus                     = 1024 
  vpc_id                                = module.vpc.vpc_id
}