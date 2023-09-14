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
  }
}
