output "dns_name" {
  description = "DNS name of the load balancer, used to reach the application and as the target of a Route 53 alias record"
  value       = aws_lb.this.dns_name
}

output "zone_id" {
  description = "Hosted zone ID of the load balancer, required for a Route 53 alias record"
  value       = aws_lb.this.zone_id
}

output "security_group_id" {
  description = "ID of the load balancer's security group, used as the only allowed source in the application servers security group"
  value       = aws_security_group.alb.id
}

output "target_group_arn" {
  description = "ARN of the target group in which the application servers register"
  value       = aws_lb_target_group.this.arn
}

output "target_port" {
  description = "Port on which the target group sends traffic to the application servers"
  value       = aws_lb_target_group.this.port
}
