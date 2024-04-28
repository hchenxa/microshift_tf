variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}

variable "ocp_version" {
  type        = string
  description = "Version of the cluster"
  default     = "4.14"
}

variable "aws_access_key_id" {
  type        = string
  description = "AWS Access Key ID"
}

variable "aws_secret_access_key" {
  type        = string
  description = "AWS Secret Access Key"
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
}

variable "aws_base_dns_domain" {
  type        = string
  description = "Base public DNS domain under which to create resources"
}

variable "ssh_private_key_path" {
  type        = string
  description = "Path to SSH private key"
  default     = "~/.ssh/id_rsa"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "rh_subscription_username" {
  description = "Red Hat Network login username for registration system of the OpenShift Container Platform cluster"
}

variable "rh_subscription_password" {
  description = "Red Hat Network login password for registration system of the OpenShift Container Platform cluster"
}

variable "openshift_image_pullsecret" {
  type        = string
  description = "Path to the OpenShift image pull secret"
}

data "aws_availability_zones" "zones" {}

variable "vpc_cidr" {
  type        = string
  description = "microshift VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "Public Subnet CIDR"
  default     = "10.0.0.0/20"
}

variable "private_subnet_cidr" {
  type        = string
  description = "Private Subnet CIDR"
  default     = "10.0.16.0/20"
}
