resource "aws_autoscaling_group" "wordpress_asg" {
  desired_capacity     = 1
  max_size             = 4
  min_size             = 1
  launch_template {
    id      = aws_launch_template.wordpress.id
    version = "$Latest"
  }
  vpc_zone_identifier = [aws_subnet.public1.id, aws_subnet.public2.id]
  
  tag {
    key                 = "Name"
    value               = "wordpress-instance"
    propagate_at_launch = true
  }
}

# ALB Configuration
resource "aws_lb" "alb" {
  name               = "wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]
  tags = { Name = "wordpress-alb" }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}

resource "aws_lb_target_group" "wordpress_tg" {
  name     = "wordpress-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    path     = "/"
    protocol = "HTTP"
  }
  tags = { Name = "wordpress-tg" }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
  lb_target_group_arn    = aws_lb_target_group.wordpress_tg.arn
}
