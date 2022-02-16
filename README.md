# simpl_ec2
Terraform script for ceation linux server (Ubuntu and Amazon Linux) in AWS ec2.

On each set up nginx server and some start page

## Parametrs define in variables.tf file:

 1. Region - region (by default "eu-central-1")
 2. Project owner - pr_owner (by default = "Ownrer_of_project")
 3. Project name - pr_name "Name_of_project"
 4. Name of enviroment - env (by default = "Environment_name")
 5. Name of key file - key_name (by default "ga-frank")
 6. List of allow ports - allow_ports (by default ["80", "443", "22"])
 7. Count of Ubuntu servers - count_ub_serv" (by default 1)
 8. Count of Amazon Linux servers - count_aml_serv  (by default 1)

You can redifine variables in variables.tf (.tfvar) or in another way (in command terraform line, env, etc..)
