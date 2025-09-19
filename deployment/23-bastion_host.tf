# Fetch Amazon Linux 2023 Minimal (x86_64)
data "aws_ssm_parameter" "al2023_minimal" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-minimal-kernel-default-x86_64"
}

resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ssm_parameter.al2023_minimal.value
  instance_type               = var.bastion_host_type
  vpc_security_group_ids      = [aws_security_group.bastion_host_sg.id]
  subnet_id                   = aws_subnet.public_subnet_a.id
  key_name                    = "chimeinEC2KeyPair"
  associate_public_ip_address = true

  root_block_device {
    volume_size = 2
    volume_type = "gp3"
  }

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-bastion-host" })
  )
}
