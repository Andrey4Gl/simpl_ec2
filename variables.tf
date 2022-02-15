#---------------------------------------------------------------------
# Scripts for ceation linux server (Ubuntu or Amazon Linux) in AWS ec2.
# TF (c) AG 2021
# Variables definition
#----------------------------------------------------------------------


variable "region" {
  description = "Please enter needed region."
  default     = "eu-central-1"
}

# Variables for tags and name

variable "pr_owner" {
  default = "Ownrer_of_project"
}

variable "pr_name" {
  default = "Name_of_project"
}

variable "env" {
  default = "Environment_name"
}


# Variables for servers

variable "count_ubuntu" {
  default = 1
}

variable "count_am_lin" {
  default = 1
}

variable "key_name" {
  description = "Please enter key file name."
  default     = "ga-frank"
}


variable "inst_type" {
  description = "Please enter instance type."
  default     = "t2.micro"
}

variable "dt_fl_ubuntu" {
  type = map(any)
  default = {
    home_dir   = "/var/www/html/"
    S_name     = "Ubuntu",
    pm         = "apt",
    instal_cmd = "apt -y install nginx-light",
    auto_cmd   = "update-rc.d nginx defaults"
  }
}

variable "df_fl_aml" {
  type = map(any)
  default = {
    home_dir   = "/usr/share/nginx/html/",
    S_name     = "Amazon Linux",
    pm         = "yum",
    instal_cmd = "amazon-linux-extras install nginx1 -y",
    auto_cmd   = "chkconfig nginx on"
  }
}


# Variables for security group

variable "allow_ports" {
  description = "Please enter allowing ports for security group."
  type        = list(any)
  default     = ["80", "443", "22"]
}
