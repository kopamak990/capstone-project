variable "availability_zone_1" {
  description = "Availability zone 1"
  default     = "eu-north-1a"
}

variable "availability_zone_2" {
  description = "Availability zone 2"
  default     = "eu-north-1b"
}

variable "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  type        = string
  sensitive   = true
}

variable "db_root_password" {
  description = "The password for the RDS root user"
  type        = string
  sensitive   = true
}

variable "wp_db_password" {
  description = "The password for the WordPress database user"
  type        = string
  sensitive   = true
}

variable "wp_db_user" {
  description = "The username for the WordPress database user"
  type        = string
  sensitive   = true
  default     = "kolade"
}

variable "key_name" {
  description = "The key name for EC2 instances"
  type        = string
}
