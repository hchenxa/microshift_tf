#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#          OUTPUT           #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Output cluster access commands/addresses
output "node_ssh" {
  value       = "ssh -i ${var.ssh_private_key_path} ec2-user@${aws_instance.microshift_node.public_ip}"
  description = "Public IP of node (for SSH access)"
}

# Output the kubeconfig
output "kubeconfig_file" {
  value       = "ssh -i ${var.ssh_private_key_path} ec2-user@${aws_instance.microshift_node.public_ip} sudo cat /var/lib/microshift/resources/kubeadmin/${var.cluster_name}.${var.aws_base_dns_domain}/kubeconfig"
  description = "The commands can get the kubeconfig file"
}
