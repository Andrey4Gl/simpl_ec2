#---------------------------------------------------------------------
# Scripts for ceation linux server (Ubuntu or Amazon Linux) in AWS ec2.
# Main script
# TF (c) AG 2021
# Create resources
#   - Elastic IP
#   - Security group (ports: 80, 443, 22)
#   - Linux Ubuntu 20.04 with nginx (AZ[0])
#   - Amazon Linux (kernel 5.10) with nginx (AZ[0])
#----------------------------------------------------------------------

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpcs" "my_vpcs" {}


# AMI for ubuntu-focal-20.04-amd64-server
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# AMI for Amazon Linux (kernel v 5.10)
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}


# AMI for MS Windows 2019 Base
data "aws_ami" "latest_windows" {
  owners      = ["801119661308"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
}


/* Select vpc by tag Name
data "aws_vpc" "prod_vpc" {
  tags = {
    Name = "prod"
  }
}
*/

resource "aws_eip" "terr_static_ub" {
  instance = aws_instance.server_ter01.id
  tags = {
    Name  = "elc_ip_ub_${var.pr_name}"
    Owner = var.pr_owner
    Env   = var.env
  }
}

resource "aws_eip" "terr_static_aml" {
  instance = aws_instance.server_ter02.id
  tags = {
    Name  = "elc_ip_aml_${var.pr_name}"
    Owner = var.pr_owner
    Env   = var.env
  }
}


# ----- Template for ubuntu server -----
resource "aws_instance" "server_ter01" {
  availability_zone = data.aws_availability_zones.working.names[0]
  ami               = data.aws_ami.latest_ubuntu.id
  instance_type     = var.inst_type
  key_name          = var.key_name


  user_data = templatefile("user_data.sh.tpl", var.dt_fl_ubuntu)

  lifecycle {
    create_before_destroy = true
  }

  vpc_security_group_ids = [aws_security_group.sg_ter01.id]

  # depends_on = []

  tags = {
    Name  = "Ub_Server_${var.pr_name}"
    Owner = var.pr_owner
    Env   = var.env
  }
}

# ----- Template for amazon linux server -----
resource "aws_instance" "server_ter02" {
  availability_zone = data.aws_availability_zones.working.names[0]
  ami               = data.aws_ami.latest_amazon_linux.id
  instance_type     = var.inst_type
  key_name          = var.key_name

  user_data = templatefile("user_data.sh.tpl", var.df_fl_aml)

  lifecycle {
    create_before_destroy = true
  }

  vpc_security_group_ids = [aws_security_group.sg_ter01.id]

  # depends_on = []

  tags = {
    Name  = "Amazon_Linux_Server_5.10_${var.pr_name}"
    Owner = var.pr_owner
    Env   = var.env
  }
}


resource "aws_security_group" "sg_ter01" {
  name        = "sg_${var.pr_name}"
  description = "SG for web server for project ${var.pr_name}"

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "sg_${var.pr_name}"
    Owner = var.pr_owner
  }
}
