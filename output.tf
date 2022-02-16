#---------------------------------------------------------------------
# Scripts for ceation linux server (Ubuntu or Amazon Linux) in AWS ec2.
# TF (c) AG 2021
# Outputs parameters:
#   - Common parameters (user_id, region name, region description etc)
#   - Latest ami version name (Ubunt, AmLinux, Windows2019)
#   - Instances information (id, public and private ip's, AZ)
#----------------------------------------------------------------------


# Common parameters

output "data_aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}

output "data_aws_region_name" {
  value = data.aws_region.current.name
}

output "data_aws_region_description" {
  value = data.aws_region.current.description
}

output "data_aws_availability_zones" {
  value = data.aws_availability_zones.working.names
}


# Latest ami version

output "latest_ami_ubuntu" {
  value = data.aws_ami.latest_ubuntu.name
}

output "latest_ami_ubuntu_id" {
  value = data.aws_ami.latest_ubuntu.id
}

output "latest_ami_amazon" {
  value = data.aws_ami.latest_amazon_linux.name
}

output "latest_ami_amazon_id" {
  value = data.aws_ami.latest_amazon_linux.id
}


# VPC resources

output "aws_vpcs" {
  value = data.aws_vpcs.my_vpcs.ids
}

# Instances resources

# Server Ubuntu

output "Ubuntu_server_instance_id" {
  value = aws_instance.server_ter01[*].id
}

output "Ubuntu_server_public_ip" {
  value = aws_eip.terr_static_ub[*].public_ip
}

output "Ubuntu_server__private_ip" {
  value = aws_instance.server_ter01[*].private_ip
}

output "Ubuntu_server_AZ" {
  value = aws_instance.server_ter01[*].availability_zone
}

# Server AmLinux

output "AmL_server_instance_id" {
  value = aws_instance.server_ter02[*].id
}

output "AmL_server_public_ip" {
  value = aws_eip.terr_static_aml[*].public_ip
}

output "AmL_server_private_ip" {
  value = aws_instance.server_ter02[*].private_ip
}

output "AmL_server_AZ" {
  value = aws_instance.server_ter02[*].availability_zone
}
