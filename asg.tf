#---------------------- AUTOSCALING GROUP FOR WEBSERVERS ----------------------------#
resource "aws_launch_configuration" "web_asg_conf" {
  name                 = "web_launch_config"
  image_id             = data.aws_ami.ubuntu.id
  instance_type        = "t3.small"
  key_name             = "ta-mumbai"
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  security_groups      = [aws_security_group.web_sg.id]
  user_data            = <<EOF
  #!/bin/bash
  sudo su apt-get update
  sudo su apt-get install stress
  sleep 600
  stress --cpu 2 --timeout 600
  EOF
}

resource "aws_autoscaling_group" "web_asg" {
  name                 = "web-sg"
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  launch_configuration = aws_launch_configuration.web_asg_conf.name
  vpc_zone_identifier  = [aws_subnet.web_public["a"].id, aws_subnet.web_public["b"].id]

  tag {
    key                 = "Name"
    value               = "WebServer"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "web_asg_policy" {
  name                   = "web-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

resource "aws_cloudwatch_metric_alarm" "web_alarm" {
  alarm_name          = "web-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 60
  actions_enabled     = true

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

  alarm_description = "Metric to monitor ec2 CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.web_asg_policy.arn]
}

resource "aws_autoscaling_policy" "web_asg_policy_scaledown" {
  name                   = "web-policy-scaledown"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

resource "aws_cloudwatch_metric_alarm" "web_alarm_scaledown" {
  alarm_name          = "web-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 20
  actions_enabled     = true

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

  alarm_description = "Metric to monitor ec2 CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.web_asg_policy_scaledown.arn]
}

#------------------------------------ AUTOSCALING GROUP FOR APPSERVERS ----------------------------------#

resource "aws_launch_configuration" "app_asg_conf" {
  name                 = "app_launch_config"
  image_id             = data.aws_ami.ubuntu.id
  instance_type        = "t3.small"
  key_name             = "ta-mumbai"
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  security_groups      = [aws_security_group.app_sg.id]
  user_data            = <<EOF
  #!/bin/bash
  sudo su apt-get update
  sudo su apt-get install stress
  sleep 600
  stress --cpu 2 --timeout 600
  EOF
}

resource "aws_autoscaling_group" "app_asg" {
  name                 = "app-sg"
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  launch_configuration = aws_launch_configuration.app_asg_conf.name
  vpc_zone_identifier  = [aws_subnet.app_private["a"].id, aws_subnet.app_private["b"].id]

  tag {
    key                 = "Name"
    value               = "AppServer"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "app_asg_policy" {
  name                   = "app-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}

resource "aws_cloudwatch_metric_alarm" "app_alarm" {
  alarm_name          = "app-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 60
  actions_enabled     = true

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }

  alarm_description = "Metric to monitor ec2 CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.app_asg_policy.arn]
}

resource "aws_autoscaling_policy" "app_asg_policy_scaledown" {
  name                   = "app-policy-scaledown"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}

resource "aws_cloudwatch_metric_alarm" "app_alarm_scaledown" {
  alarm_name          = "app-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 20
  actions_enabled     = true

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }

  alarm_description = "Metric to monitor ec2 CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.app_asg_policy_scaledown.arn]
}