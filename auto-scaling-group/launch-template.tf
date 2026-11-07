data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_launch_template" "app_server" {
  name        = "${var.name}-app-server-lt"
  description = "The launch template for the application servers."

  image_id      = data.aws_ssm_parameter.al2023_ami.insecure_value
  instance_type = var.instance_type


  iam_instance_profile {
    name = aws_iam_instance_profile.app_instance_profile.name
  }

  vpc_security_group_ids = [aws_security_group.app.id]

  user_data = base64encode(var.user_data)

  update_default_version = true


  metadata_options {

    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = var.metadata_hop_limit
    instance_metadata_tags      = "disabled"

  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.ebs_volume_size
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }
  tag_specifications {
    resource_type = "instance"
    tags          = merge(var.tags, { Name = "${var.name}-app-server" })
  }

  tag_specifications {
    resource_type = "volume"
    tags          = merge(var.tags, { Name = "${var.name}-app-server-volume" })
  }

  tags = merge(var.tags, { Name = "${var.name}-app-server-lt" })
}

