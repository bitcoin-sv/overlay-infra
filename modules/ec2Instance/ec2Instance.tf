resource "aws_instance" "bastion" {
  ami                         = var.ecs_image
  instance_type               = var.ecs_instance_type
  key_name                    = var.key_name
  iam_instance_profile        = var.ec2_instance_profile_name
  associate_public_ip_address = true

  vpc_security_group_ids = [
    var.bastion_sg_id,
    var.internal_access_sg
  ]

  subnet_id = var.public_subnet_ids[0]

  tags = {
    Name = "${var.cluster_name} bastion"
  }
}

resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion.id
}

resource "aws_launch_configuration" "ecs" {
  name                        = "ecs-launch-configuration-${substr(md5(timestamp()), 0, 8)}"
  image_id                    = var.ecs_image
  instance_type               = var.ecs_instance_type
  iam_instance_profile        = var.ec2_instance_profile_name
  key_name                    = var.key_name
  associate_public_ip_address = false
  security_groups             = [var.internal_access_sg]

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tpl", {
    cluster_name = var.cluster_name
    s3_bucket    = var.s3_bucket
  }))

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_size = var.root_volume_size
  }

  ebs_block_device {
    device_name = "/dev/xvdcz"
    volume_size = var.ebs_volume_size
  }
}

resource "aws_autoscaling_group" "ecs" {
  desired_capacity     = var.asg_desired_capacity
  max_size             = var.asg_max_size
  min_size             = var.asg_min_size
  launch_configuration = aws_launch_configuration.ecs.name
  vpc_zone_identifier  = var.private_subnet_ids

  tag {
    key                 = "Name"
    value               = "${var.cluster_name} cluster"
    propagate_at_launch = true
  }
}
