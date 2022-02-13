#---------------------------------------------------------------------
# Output data (tamplate file)
# TF (c) AG 2021
# Outputs parameters:
#   - Common parameters (user_id, region name, region description etc)
#   - Latest ami version name (Ubunt, AmLinux, Windows2019)
#   - VPC resources
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

output "latest_ubuntu_ami_name" {
  value = data.aws_ami.latest_ubuntu.name
}

output "latest_amazon_linux_ami_name" {
  value = data.aws_ami.latest_amazon_linux.name
}

output "latest_windows_ami_name" {
  value = data.aws_ami.latest_windows.name
}


# VPC resources

output "aws_vpcs" {
  value = data.aws_vpcs.my_vpcs.ids
}

# Instances resources

# Server Ubuntu

output "server_01_instance_id" {
  value = aws_instance.server_ter01.id
}

output "server_01_public_ip" {
  value = aws_instance.server_ter01.public_ip
}

output "server_01_private_ip" {
  value = aws_instance.server_ter01.private_ip
}

output "server_01_AZ" {
  value = aws_instance.server_ter01.availability_zone
}

# Server AmLinux

output "server_02_instance_id" {
  value = aws_instance.server_ter02.id
}

output "server_02_public_ip" {
  value = aws_instance.server_ter02.public_ip
}

output "server_02_private_ip" {
  value = aws_instance.server_ter02.private_ip
}

output "server_02_AZ" {
  value = aws_instance.server_ter02.availability_zone
}
