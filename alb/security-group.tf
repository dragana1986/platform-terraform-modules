locals {
  http_port = 80
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group" "alb" {
  name        = "${var.name}-alb-sg"
  description = "Controls inbound HTTP traffic to the application load balancer and outbound traffic to its targets"

  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-alb-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "Allows HTTP from the internet to the load balancer listener"
  ip_protocol       = "tcp"
  from_port         = local.http_port
  to_port           = local.http_port
  cidr_ipv4         = "0.0.0.0/0"

  tags = merge(var.tags, {
    Name = "${var.name}-alb-http-in"
  })
}

resource "aws_vpc_security_group_egress_rule" "alb_to_targets" {
  security_group_id = aws_security_group.alb.id
  description       = "Allows the load balancer to forward requests and send health checks to targets in the VPC"
  ip_protocol       = "tcp"
  from_port         = var.target_port
  to_port           = var.target_port
  cidr_ipv4         = data.aws_vpc.selected.cidr_block

  tags = merge(var.tags, {
    Name = "${var.name}-alb-to-targets-out"
  })
}
