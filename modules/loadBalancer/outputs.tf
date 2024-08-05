output "lb_arn" {
  value = aws_lb.main.arn
}

output "lb_dns_name" {
  value = aws_lb.main.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.main.arn
}

output "load_balancer_arn" {
  value = aws_lb.main.arn
}

output "load_balancer_dns_name" {
  value = aws_lb.main.dns_name
}

output "load_balancer_https_listener_arn" {
  value = aws_lb_listener.https.arn
}

output "load_balancer_http_listener_arn" {
  value = aws_lb_listener.http.arn
}