# SNS 알람 주제 설정
resource "aws_sns_topic" "seoul_asg_scaling_alert_topic" {
  name = "Seoul-ASG-Scaling-Alert-Topic"
}

# SNS 주제에 이메일 구독 추가
resource "aws_sns_topic_subscription" "seoul_asg_scaling_alert_email_subscription" {
  topic_arn = aws_sns_topic.seoul_asg_scaling_alert_topic.arn
  protocol  = "email"
  endpoint  = ""
}

# CloudWatch 인스턴스 CPU 상태 알람
resource "aws_cloudwatch_metric_alarm" "seoul_asg_cpu_alarm" {
  alarm_name          = "Seoul-ASG-CPU-Alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "CPU utilization"
  alarm_actions       = [aws_sns_topic.seoul_asg_scaling_alert_topic.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.seoul_asg.name
  }
}

# CloudWatch 인스턴스 확장 상태 알람
resource "aws_cloudwatch_metric_alarm" "seoul_asg_scaling_alarm" {
  alarm_name          = "Seoul-ASG-Scaling-Alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "GroupDesiredCapacity"
  namespace           = "AWS/AutoScaling"
  period              = 300
  statistic           = "Maximum"
  threshold           = 2
  alarm_description   = "Auto Scaling group scaling activities"
  alarm_actions       = [aws_sns_topic.seoul_asg_scaling_alert_topic.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.seoul_asg.name
  }
}