resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name

  capacity_providers = var.capacity_providers

  dynamic "default_capacity_provider_strategy" {
    for_each = var.default_capacity_provider_strategies
    content {
      capacity_provider  = default_capacity_provider_strategy.value["capacity_provider"]
      weight  = default_capacity_provider_strategy.value["weight"]
      base  = default_capacity_provider_strategy.value["base"]
    }
  }
  
}
