resource "aws_autoscaling_group" "ec2_autoscaling_group" {
  name                = "${local.prefix}-ASG"
  vpc_zone_identifier = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]

  # Increase the number below if traffic is higher.
  min_size         = 1
  max_size         = 1
  desired_capacity = 1

  # Moved from launch configuration to launch template.
  # launch_configuration      = aws_launch_configuration.asg_launch_configuration.name
  launch_template {
    id      = aws_launch_template.asg_launch_configuration.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 600 # 10 minutes. We want the libraries/modules to be installed.
  default_cooldown          = 150
  force_delete              = true
  target_group_arns         = [aws_alb_target_group.server_backend_tg.arn]
  enabled_metrics           = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_elasticache_replication_group.chimein_redis_cluster]

  tag {
    key                 = "Name"
    value               = "EC2-ASG-${terraform.workspace}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Type"
    value               = "Backend-${terraform.workspace}"
    propagate_at_launch = true
  }
}
