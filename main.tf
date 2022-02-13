#---------------------------------------------------------------------
# Output data (tamplate file)
# TF (c) AG 2021
# Create resources
#   - Elastic IP
#   - Security group (ports: 80, 443, 22)
#   - Linux Ubuntu 20.04 with nginx (AZ[0])
#   - Amazon Linux (kernel 5.10) with nginx (AZ[0])
#----------------------------------------------------------------------

provider "aws" {
  region = "eu-central-1"
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

resource "aws_eip" "terr_static_ip" {
  instance = aws_instance.server_ter01.id
  tags = {
    Name  = "Terr_stat_ip"
    Owner = "terraform_user"
  }
}


# ----- Template for ubuntu server -----
resource "aws_instance" "server_ter01" {
  availability_zone = data.aws_availability_zones.working.names[0]
  ami               = data.aws_ami.latest_ubuntu.id
  instance_type     = "t2.micro"
  key_name          = "ga-frank"

  user_data = templatefile("user_data.sh.tpl", {
    home_dir   = "/var/www/html/"
    S_name     = "Ubuntu",
    pm         = "apt",
    instal_cmd = "apt -y install nginx-light",
    auto_cmd   = "update-rc.d nginx defaults"
  })

  lifecycle {
    create_before_destroy = true
  }

  vpc_security_group_ids = [aws_security_group.sg_ter01.id]

  # depends_on = []

  tags = {
    Name  = "Ub_Server_ter"
    Owner = "terraform_user"
  }
}

# ----- Template for amazon linux server -----
resource "aws_instance" "server_ter02" {
  availability_zone = data.aws_availability_zones.working.names[0]
  ami               = data.aws_ami.latest_amazon_linux.id
  instance_type     = "t2.micro"
  key_name          = "ga-frank"

  user_data = templatefile("user_data.sh.tpl", {
    home_dir   = "/usr/share/nginx/html/",
    S_name     = "Amazon Linux",
    pm         = "yum",
    instal_cmd = "amazon-linux-extras install nginx1 -y",
    auto_cmd   = "chkconfig nginx on"
  })

  lifecycle {
    create_before_destroy = true
  }

  vpc_security_group_ids = [aws_security_group.sg_ter01.id]

  # depends_on = []

  tags = {
    Name  = "Amazon_Linux_Server_5.10_ter"
    Owner = "terraform_user"
  }
}


resource "aws_security_group" "sg_ter01" {
  name        = "sg_ter01_def"
  description = "SG for web server from terrafom"

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
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
    Name  = "sg_ter01_def"
    Owner = "terraform_user"
  }
}
