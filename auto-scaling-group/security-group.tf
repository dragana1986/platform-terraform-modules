resource "aws_security_group" "app" {
  name        = "${var.name}-app-sg"
  description = "Controls inbound traffic from the Application Load Balancer and outbound traffic from the application servers."
  vpc_id      = var.vpc_id


  tags = merge(var.tags, {
    Name = "${var.name}-app-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id = aws_security_group.app.id
  description       = "Allows HTTP from the Application Load Balancer to the application servers"

  from_port                    = var.app_port
  to_port                      = var.app_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.alb_security_group_id

  tags = merge(var.tags, {
    Name = "${var.name}-app-http-in"
  })
}
# The servers reach AWS public endpoints and package repositories over HTTPS, which have no fixed IP ranges; production narrows this with VPC endpoints.
#trivy:ignore:AVD-AWS-0104
resource "aws_vpc_security_group_egress_rule" "app_https_out" {
  security_group_id = aws_security_group.app.id
  description       = "Allows HTTPS outbound traffic from the application servers to package repositories and AWS service endpoints."

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"

  tags = merge(var.tags, {
    Name = "${var.name}-app-https-out"
  })
}
