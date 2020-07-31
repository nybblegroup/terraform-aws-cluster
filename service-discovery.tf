resource "aws_service_discovery_private_dns_namespace" "theconnectedpet" {
  name        = "${var.stage}.${var.dns_domain}"
  description = "${var.cluster_name} Internal DNS"
  vpc         = var.vpc_id
}