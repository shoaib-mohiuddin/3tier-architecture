output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.application_lb.dns_name
}