output "auto_scaling_group_name" {
  description = "The name of the Auto Scaling group that runs the application servers."
  value       = aws_autoscaling_group.app_server_asg.name
}

output "security_group_id" {
  description = "The ID of the security group attached to the application servers. Used as the permitted source in the security groups of resources that servers connect to."
  value       = aws_security_group.app.id
}

output "instance_role_name" {
  description = "The name of the IAM role assumed by the application servers. Used to attach additional permissions that the application needs."
  value       = aws_iam_role.app_role.name
}
