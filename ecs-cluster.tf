resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name

  capacity_providers = var.capacity_providers
}
