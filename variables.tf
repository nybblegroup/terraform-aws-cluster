variable "cluster_name" {
  description = "The name to use to create the cluster and the resources. Only alphanumeric characters and dash allowed (e.g. 'my-cluster')"
}
variable "region" {
  default     = null
  description = "The AWS region where to launch the cluster and releated resources"
}
variable "ssh_key_name" {
  description = "SSH key to use to enter and manage the EC2 instances within the cluster. Optional"
  default     = ""
}
variable "instance_type_spot" {
  default = "t3a.medium"
}
variable "instance_type_ondemand" {
  default = "t3a.micro"
}
variable "spot_bid_price" {
  default = "0.0113"
}
variable "min_spot_instances" {
  default     = "0"
  description = "The minimum EC2 spot instances to have available within the cluster when the cluster receives less traffic"
}
variable "max_spot_instances" {
  default     = "5"
  description = "The maximum EC2 spot instances that can be launched during period of high traffic"
}
variable "min_ondemand_instances" {
  default     = "0"
  description = "The minimum EC2 ondemand instances to have available within the cluster when the cluster receives less traffic"
}
variable "max_ondemand_instances" {
  default     = "3"
  description = "The maximum EC2 ondemand instances that can be launched during period of high traffic"
}
variable "vpc_id" {
  default     = "invalid-vpc"
  description = "A VPC where the EC2 instances will be launched in. Either pass this variable or \"create_vpc=true\""
}
variable "subnet_ids" {
  description = "A list of subnet IDs in which to launch EC2 instances in"
  type        = list(string)
  default = [
    "non-existing-1",
    "non-existing-2"
  ] 
}
variable "create_iam_service_linked_role" {
  default     = "false"
  description = "Whether or not to create a service-linked role for ECS inside your AWS account. Such role is automatically created the first time you provision an ECS cluster using the AWS UI, CLI, Terraform, etc. If you previously created an ECS cluster, set this to false, else set it to true"
}

variable "create_vpc" {
  description = "Whether or not to create a VPC to contain this cluster and its resources, or reuse an existing VPC (passed to the module as a vpc_id parameter)"
}

variable "ecs_ami_id" {
  default = null
}

variable "account_id" {
  default = null
}

variable "dns_domain" {
  default = null
}

variable "stage" {
  default = "dev"
}

variable "security_groups" {
  default = null
}

variable "capacity_providers" {
  type = list
  default = null
}

variable "github_access_token" {
  default = null
}

variable "github_runner_enabled" {
  description = "Installs GitHub Action Runner on each box"
  default = false
}

variable "github_runner_org" {
  default = null
}

variable "github_runner_labels" {
  default = null
}

variable "default_capacity_provider_strategies" {
  default = []
}