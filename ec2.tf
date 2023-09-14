# Define and query for the RHEL 9.2 AMI
data "aws_ami" "rhel" {
  most_recent = true
  owners      = ["309956199498"] # Red Hat's account ID

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "name"
    values = ["RHEL-9.2.0_HVM*"]
  }
}

# Create EC2 Instance
resource "aws_instance" "microshift_node" {
  ami           = data.aws_ami.rhel.id
  instance_type = "t2.medium"
  key_name      = aws_key_pair.default.key_name
  subnet_id     = aws_subnet.microshift_public_subnet.id
  vpc_security_group_ids = [
    aws_security_group.microshift_sg_ssh.id,
  ]
  associate_public_ip_address = true

  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${local.cluster_id}-microshift"
    })
  )

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.ssh_private_key_path)
    host        = self.public_ip
  }

  provisioner "file" {
    content     = file(var.openshift_image_pullsecret)
    destination = "/tmp/openshift-pull-secret"
  }

  user_data = data.template_file.cloud-init.rendered
}
