# Terraform AWS RDS Web Application
# Root Module Variables

# ---------------------------------------------------------
# General Settings
# ---------------------------------------------------------

variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
  default     = "terraform-rds-webapp"
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }

  default = "dev"
}

variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}


# ---------------------------------------------------------
# Network Settings
# ---------------------------------------------------------

variable "vpc_cidr" {
  description = "CIDR block for the application VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private RDS subnets"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}


# ---------------------------------------------------------
# Compute Settings
# ---------------------------------------------------------

variable "ec2_instance_type" {
  description = "EC2 instance type for the web application"
  type        = string
  default     = "t3.micro"
}

variable "ssh_allowed_cidr" {
  description = "CIDR block allowed to access the EC2 instance through SSH"
  type        = string
  default     = "0.0.0.0/0"
}


# ---------------------------------------------------------
# Database Settings
# ---------------------------------------------------------

variable "db_name" {
  description = "Application database name"
  type        = string
  default     = "webappdb"
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  sensitive   = true
  default     = "admin"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 10
}

variable "db_engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0"
}