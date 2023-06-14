# Seoul-TG 타겟 그룹 생성
resource "aws_lb_target_group" "seoul_alb_tg" {
  name        = "Seoul-TG"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.seoul_vpc.id
}

# Seoul-ALB 로드밸런싱
resource "aws_lb" "seoul_alb" {
  name               = "Seoul-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.seoul_alb_sg.id]
  subnets            = [aws_subnet.seoul_pub_sn1.id, aws_subnet.seoul_pub_sn2.id]
}

# Seoul-ALB 로드밸런싱 리스너
resource "aws_lb_listener" "seoul_front_end" {
  load_balancer_arn = aws_lb.seoul_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
    target_group_arn = aws_lb_target_group.seoul_alb_tg.arn
  }
}

resource "aws_lb_listener" "seoul_front_end2" {
  load_balancer_arn = aws_lb.seoul_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = ""

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.seoul_alb_tg.arn
  }
}

# Seoul-Launch-Template 시작 템플릿
resource "aws_launch_template" "seoul_web" {
  name = "Seoul-WEB"

  image_id = ""

  instance_type = "t2.micro"

  network_interfaces {
    security_groups = [aws_security_group.seoul_pri_sg.id]
  }

  tags = {
    Name = "Seoul-WEB"
  }

  user_data = base64encode(<<EOF
  #!/bin/bash
  echo "p@ssw0rd" | passwd --stdin root
  sed -i "s/^PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
  sed -i "s/^#PermitRootLogin yes/PermitRootLogin yes/g" /etc/ssh/sshd_config
  service sshd restart
  EOF
  )
}

# Singapore-TG 타겟 그룹 생성
resource "aws_lb_target_group" "singapore_alb_tg" {
  provider   = aws.singapore
  name        = "Singapore-TG"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.singapore_vpc.id
}

# Singapore-ALB 로드밸런싱
resource "aws_lb" "singapore_alb" {
  provider   = aws.singapore
  name               = "Singapore-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.singapore_alb_sg.id]
  subnets            = [aws_subnet.singapore_pub_sn1.id, aws_subnet.singapore_pub_sn2.id]
}

# Singapore-ALB 로드밸런싱 리스너
resource "aws_lb_listener" "singapore_front_end" {
  provider   = aws.singapore
  load_balancer_arn = aws_lb.singapore_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
    target_group_arn = aws_lb_target_group.singapore_alb_tg.arn
  }
}

resource "aws_lb_listener" "singapore_front_end2" {
  provider   = aws.singapore
  load_balancer_arn = aws_lb.singapore_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = ""

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.singapore_alb_tg.arn
  }
}

# Singapore-Launch-Template시작 템플릿
resource "aws_launch_template" "singapore_web" {
  provider   = aws.singapore
  name = "Singapore-WEB"

  image_id = ""

  instance_type = "t2.micro"

  network_interfaces {
    security_groups = [aws_security_group.singapore_pri_sg.id]
  }

  tags = {
    Name = "Singapore-WEB"
  }

  user_data = base64encode(<<EOF
  #!/bin/bash
  echo "p@ssw0rd" | passwd --stdin root
  sed -i "s/^PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
  sed -i "s/^#PermitRootLogin yes/PermitRootLogin yes/g" /etc/ssh/sshd_config
  service sshd restart
  EOF
  )
}

# Seoul-ASG 생성 
resource "aws_autoscaling_group" "seoul_asg" {
  name               = "Seoul-ASG"
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2
  vpc_zone_identifier = [aws_subnet.seoul_pri_sn3.id, aws_subnet.seoul_pri_sn4.id]

  launch_template {
    id      = aws_launch_template.seoul_web.id
    version = "$Default"
  }

  target_group_arns = [aws_lb_target_group.seoul_alb_tg.arn]

  tags = [
    {
      key                 = "Name"
      value               = "Seoul-WEB"
      propagate_at_launch = true
    }
  ]

  default_cooldown = 120  // 워밍업 시간 (초)
}

# Seoul-ASG-Policy 생성 대상 추적 크기 조정
resource "aws_autoscaling_policy" "seoul_asg_scaling_policy" {
  name                   = "Seoul-ASG-Scaling-Policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.seoul_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 30.0
  }
}

# Singapore-ASG 생성 
resource "aws_autoscaling_group" "singapore_asg" {
  provider   = aws.singapore
  name               = "Singapore-ASG"
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2
  vpc_zone_identifier = [aws_subnet.singapore_pri_sn3.id, aws_subnet.singapore_pri_sn4.id]

  launch_template {
    id      = aws_launch_template.singapore_web.id
    version = "$Default"
  }

  target_group_arns = [aws_lb_target_group.singapore_alb_tg.arn]

  tags = [
    {
      key                 = "Name"
      value               = "Singapore-WEB"
      propagate_at_launch = true
    }
  ]

  default_cooldown = 120  // 워밍업 시간 (초)
}

# Singapore-ASG-Policy 생성 대상 추적 크기 조정
resource "aws_autoscaling_policy" "singapore_asg_scaling_policy" {
  provider   = aws.singapore
  name                   = "singapore-ASG-Scaling-Policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.singapore_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 30.0
  }
}