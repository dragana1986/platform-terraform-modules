resource "aws_autoscaling_group" "app_server_asg" {
  name             = "${var.name}-app-server-asg"
  max_size         = var.max_size
  min_size         = var.min_size
  desired_capacity = var.desired_capacity

  launch_template {
    id      = aws_launch_template.app_server.id
    version = aws_launch_template.app_server.latest_version
  }
  vpc_zone_identifier = var.private_app_subnet_ids

  target_group_arns         = [var.target_group_arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300
  default_instance_warmup   = 300

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 100
      max_healthy_percentage = 200
      auto_rollback          = true

    }
  }

  lifecycle {
    ignore_changes = [desired_capacity]
  }
}

resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name                   = "${var.name}-app-server-cpu-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.app_server_asg.name

  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.cpu_target_value
  }
}

