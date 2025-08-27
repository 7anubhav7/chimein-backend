resource "aws_launch_template" "asg_launch_configuration" {
  name          = "${local.prefix}-launch-config"
  image_id      = data.aws_ami.ec2_ami.id
  instance_type = var.ec2_instance_type
  key_name      = "chimeinEC2KeyPair"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  block_device_mappings {
    device_name = "/dev/xvda" # root volume
    ebs {
      volume_size           = 8     # Increase root volume to 8 GB
      volume_type           = "gp3" # General Purpose SSD
      delete_on_termination = true
    }
  }

  metadata_options {
  http_endpoint               = "enabled"
  http_tokens                 = "optional" # not "required"
  http_put_response_hop_limit = 2
  }


  network_interfaces {
    network_card_index          = 0
    device_index                = 0
    associate_public_ip_address = false
    security_groups             = [aws_security_group.autoscaling_group_sg.id]
  }

  user_data = filebase64("${path.module}/userdata/user-data.sh")
  lifecycle {
    create_before_destroy = true
  }
}
