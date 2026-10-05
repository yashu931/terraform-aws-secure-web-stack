# Secrets Module - Variables

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to secret resources"
  type        = map(string)
}