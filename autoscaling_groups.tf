# Create two autoscaling groups one for spot and the other for spot.
resource "aws_autoscaling_group" "ecs_cluster_ondemand" {
  name_prefix = "${var.cluster_name}_asg_ondemand_"
  termination_policies = ["OldestInstance"]
  default_cooldown          = 30
  health_check_grace_period = 30
  max_size                  = var.max_ondemand_instances
  min_size                  = var.min_ondemand_instances
  desired_capacity          = null
  launch_configuration      = aws_launch_configuration.ecs_config_launch_config_ondemand.name
  protect_from_scale_in     = true

  lifecycle {
    create_before_destroy = true
  }
  vpc_zone_identifier = local.public_subnet_ids

  tags = [
    {
      key                 = "Name"
      value               = var.cluster_name,
      propagate_at_launch = true
    }
  ]
}

resource "aws_autoscaling_group" "ecs_cluster_spot" {
  name_prefix = "${var.cluster_name}_asg_spot_"
  termination_policies = [
  "OldestInstance"]
  default_cooldown          = 30
  health_check_grace_period = 30
  max_size                  = var.max_spot_instances
  min_size                  = var.min_spot_instances
  desired_capacity          = null
  launch_configuration      = aws_launch_configuration.ecs_config_launch_config_spot.name
  protect_from_scale_in     = true

  lifecycle {
    create_before_destroy = true
  }
  vpc_zone_identifier = local.public_subnet_ids

  tags = [
    {
      key                 = "Name"
      value               = var.cluster_name,
      propagate_at_launch = true
    }
  ]
}
