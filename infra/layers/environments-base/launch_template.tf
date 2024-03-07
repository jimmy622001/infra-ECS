########################################################################################################################
## EC2 launch template
########################################################################################################################

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}

resource "aws_launch_template" "ecs_launch_template" {
  name                   = "${var.resource_prefix}_EC2_LaunchTemplate_${var.environment}"
  image_id               = data.aws_ami.amazon_linux_2.id
  instance_type          = var.ecs_ec2_instance_type
  key_name               = aws_key_pair.default.key_name
  user_data              = base64encode(data.template_file.user_data.rendered)
  vpc_security_group_ids = [aws_security_group.ec2.id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_instance_role_profile.arn
  }

  monitoring {
    enabled = true
  }

  tags = {
    Scenario = var.tag_scenario
  }
}

data "template_file" "user_data" {
  template = file("user_data.sh")

  vars = {
    ecs_cluster_name = aws_ecs_cluster.default.name
    environment      = var.environment
  }
}

########################################################################################################################
## EC2 instance role
########################################################################################################################

resource "aws_iam_role" "ec2_instance_role" {
  name               = "${var.resource_prefix}_EC2_InstanceRole_${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ec2_instance_role_policy.json

  tags = {
    Scenario = var.tag_scenario
  }
}

resource "aws_iam_role_policy_attachment" "ec2_instance_role_policy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ec2_instance_role_profile" {
  name  = "${var.resource_prefix}_EC2_InstanceRoleProfile_${var.environment}"
  role  = aws_iam_role.ec2_instance_role.id

  tags = {
    Scenario = var.tag_scenario
  }
}

data "aws_iam_policy_document" "ec2_instance_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "ecs.amazonaws.com"
      ]
    }
  }
}
