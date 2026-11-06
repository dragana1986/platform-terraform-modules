# Internet-facing by design: the load balancer is the public entry point for the application.
#trivy:ignore:AVD-AWS-0053
resource "aws_lb" "this" {
  name                       = "${var.name}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb.id]
  subnets                    = var.public_subnet_ids
  drop_invalid_header_fields = true

  tags = merge(var.tags, {
    Name = "${var.name}-alb"
  })
}

resource "aws_lb_target_group" "this" {
  name                 = "${var.name}-alb-tg"
  port                 = var.target_port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "instance"
  deregistration_delay = 30

  health_check {
    path                = var.health_check_path
    protocol            = "HTTP"
    port                = "traffic-port"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }

  tags = merge(var.tags, {
    Name = "${var.name}-alb-tg"
  })
}

# Temporary: HTTPS requires an ACM certificate for the application's domain, which is added in the DNS and TLS stage.
#trivy:ignore:AVD-AWS-0054:exp:2027-02-06
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = local.http_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  tags = merge(var.tags, {
    Name = "${var.name}-alb-listener-http"
  })
}
