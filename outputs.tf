output "cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_execution_role_name" {
  value = aws_iam_role.ecs_task_execution_role.name
}

output "asg_ondemand_arn" {
  value = aws_autoscaling_group.ecs_cluster_ondemand.arn
}

output "asg_spot_arn" {
  value = aws_autoscaling_group.ecs_cluster_spot.arn
}