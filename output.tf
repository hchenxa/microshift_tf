#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#          OUTPUT           #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Output cluster access commands/addresses
output "node_ssh" {
  value       = "ssh -i ${var.ssh_private_key_path} ec2-user@${aws_instance.microshift_node.public_ip}"
  description = "Public IP of node (for SSH access)"
}
