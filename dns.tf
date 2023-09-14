# Find the public hosted zone
data "aws_route53_zone" "base_dns" {
  name         = var.aws_base_dns_domain
  private_zone = false
}

# Create a public DNS alias for microshift cluster
resource "aws_route53_record" "public_dns_record" {
  depends_on = [aws_instance.microshift_node]

  zone_id = data.aws_route53_zone.base_dns.zone_id
  name    = local.cluster_id
  type    = "A"
  ttl     = 300
  records = [aws_instance.microshift_node.public_ip]
}
