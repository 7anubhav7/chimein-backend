resource "aws_launch_template" "asg_launch_configuration" {
  name          = "${local.prefix}-launch-config"
  image_id      = data.aws_ami.ec2_ami.id
  instance_type = var.ec2_instance_type
  key_name      = "chimeinEC2KeyPair"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  network_interfaces {
    network_card_index          = 0
    device_index                = 0
    associate_public_ip_address = false
    security_groups             = [aws_security_group.auto_scaling_group_sg.id]
  }

  lifecycle {
    create_before_destroy = true
  }
}
