
# Allow the ssh
resource "aws_security_group" "microshift_sg_ssh" {
  name        = "${local.cluster_id}_ssh"
  description = "Security group to allow SSH"
  vpc_id      = aws_vpc.microshift_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # self      = true
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # self      = true
  }

  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${local.cluster_id}-ssh-group"
    })
  )
}
