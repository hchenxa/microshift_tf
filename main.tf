provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#   CLUSTER/INSTANCE INFO   #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Create local variables for tags and cluster ID

locals {
  cluster_id = var.cluster_name
  common_tags = tomap({
    "Cluster"                                   = "${local.cluster_id}"
    "kubernetes.io/cluster/${local.cluster_id}" = "owned"
  })
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#       SSH KEY PAIR        #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Set up a key pair for SSH access to instances
resource "aws_key_pair" "default" {
  key_name   = "${local.cluster_id}_ssh_key"
  public_key = file(var.ssh_public_key_path)
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#   INSTANCE INITIALIZATION SCRIPT   #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Cloud-Init script to register and update nodes
data "template_file" "cloud-init" {
  template = file("./cloud-init.sh")
  vars = {
    rh_subscription_username   = var.rh_subscription_username
    rh_subscription_password   = var.rh_subscription_password
    openshift_image_pullsecret = var.openshift_image_pullsecret
    aws_base_dns_domain        = var.aws_base_dns_domain
    node_name                  = var.cluster_name
  }
}

resource "null_resource" "microshift_installation" {
  connection {
    type        = "ssh"
    host        = aws_instance.microshift_node.public_ip
    user        = "ec2-user"
    private_key = file(var.ssh_private_key_path)
  }

  # Check for cloud-init file to be created
  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /home/ec2-user/cloud-init-complete ]; do echo WAITING FOR NODES TO UPDATE...; sleep 30; done"
    ]
    on_failure = continue
  }
}
