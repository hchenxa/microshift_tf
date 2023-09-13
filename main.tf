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
