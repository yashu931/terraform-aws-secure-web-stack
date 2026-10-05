# Terraform AWS RDS Web Application
# Root Infrastructure Configuration

provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Secrets Module
module "secrets" {
  source = "./modules/secrets"

  project_name = var.project_name
  environment  = var.environment
  db_username  = var.db_username
  common_tags  = local.common_tags
}

# VPC Module
module "vpc" {
  source = "./modules/network"

  project_name         = var.project_name
  environment          = var.environment
  aws_region           = var.aws_region
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet_cidrs = var.private_subnet_cidrs
  common_tags          = local.common_tags
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security"

  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = module.vpc.vpc_id
  ssh_allowed_cidr = var.ssh_allowed_cidr
  common_tags      = local.common_tags
}

# RDS Module
module "rds" {
  source = "./modules/database"

  project_name         = var.project_name
  environment          = var.environment
  private_subnet_ids   = module.vpc.private_subnet_ids
  db_security_group_id = module.security_groups.db_sg_id
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = module.secrets.db_password
  instance_class       = var.db_instance_class
  allocated_storage    = var.db_allocated_storage
  engine_version       = var.db_engine_version
  common_tags          = local.common_tags
}

# EC2 Module
module "ec2" {
  source = "./modules/compute"

  project_name          = var.project_name
  environment           = var.environment
  instance_type         = var.ec2_instance_type
  public_subnet_id      = module.vpc.public_subnet_id
  web_security_group_id = module.security_groups.web_sg_id
  db_host               = module.rds.db_endpoint
  db_username           = var.db_username
  db_password           = module.secrets.db_password
  db_name               = var.db_name
  common_tags           = local.common_tags
}
