resource "aws_lb" "payments_alb" {
  name               = "payments-api-alb"
  load_balancer_type = "application"
  internal           = false

  tags = {
    Service = local.service
    Demo    = "mergeproof-production-flow"
  }
}

