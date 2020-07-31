locals {

  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
echo ECS_INSTANCE_ATTRIBUTES={\"purchase-option\":\"ondemand\"} >> /etc/ecs/ecs.config
echo ECS_ENABLE_AWSLOGS_EXECUTIONROLE_OVERRIDE=true >> /etc/ecs/ecs.config
EOF

  user_data_spot = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
echo ECS_INSTANCE_ATTRIBUTES={\"purchase-option\":\"spot\"} >> /etc/ecs/ecs.config
echo ECS_ENABLE_AWSLOGS_EXECUTIONROLE_OVERRIDE=true >> /etc/ecs/ecs.config
EOF

  user_data_spot_with_gh_runner = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
echo ECS_INSTANCE_ATTRIBUTES={\"purchase-option\":\"spot\"} >> /etc/ecs/ecs.config
echo ECS_ENABLE_AWSLOGS_EXECUTIONROLE_OVERRIDE=true >> /etc/ecs/ecs.config

sudo yum install -q -y jq
mkdir actions-runner && cd actions-runner
curl -O -L https://github.com/actions/runner/releases/download/v2.267.1/actions-runner-linux-x64-2.267.1.tar.gz
tar xzf ./actions-runner-linux-x64-2.267.1.tar.gz

REG_TOKEN=$(curl -sX POST -H "Authorization: token ${var.github_access_token}" https://api.github.com/orgs/${var.github_runner_org}/actions/runners/registration-token | jq .token --raw-output)
yes '' | ./config.sh --url https://github.com/${var.github_runner_org} --token $REG_TOKEN --labels ${var.github_runner_labels} --unattended
sudo ./svc.sh install
sudo ./svc.sh start

echo "sh /home/ec2-user/actions-runner/svc.sh stop" >> unreg_runner.sh
echo "sh /home/ec2-user/actions-runner/svc.sh uninstall" >> unreg_runner.sh
echo "sh /home/ec2-user/actions-runner/config.sh remove --unattended --token $REG_TOKEN" >> unreg_runner.sh
chmod +x unreg_runner.sh

sudo cp unreg_runner.sh /usr/lib/systemd/system-shutdown/
EOF

}

locals {
  service_name = "forum"
  owner        = "Community Team"
}

# Create two launch configs one for ondemand instances and the other for spot.
resource "aws_launch_configuration" "ecs_config_launch_config_spot" {
  name_prefix                 = "${var.cluster_name}_ecs_cluster_spot"
  image_id                    = var.ecs_ami_id
  instance_type               = var.instance_type_spot
  spot_price                  = var.spot_bid_price
  enable_monitoring           = true
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy     = true
  }
  user_data                   = (var.github_runner_enabled == true ? local.user_data_spot_with_gh_runner : local.user_data_spot)

  security_groups             = var.security_groups
  key_name                    = var.ssh_key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2_iam_instance_profile.arn
}

resource "aws_launch_configuration" "ecs_config_launch_config_ondemand" {
  name_prefix                 = "${var.cluster_name}_ecs_cluster_ondemand"
  image_id                    = var.ecs_ami_id
  instance_type               = var.instance_type_ondemand
  enable_monitoring           = true
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy     = true
  }
  user_data                   = local.user_data
  security_groups             = var.security_groups
  key_name                    = var.ssh_key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2_iam_instance_profile.arn
}
