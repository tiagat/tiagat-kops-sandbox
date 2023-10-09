variable "env_name" {
  type = string
}

variable "dns_zone_name" {
  type = string
}

variable "dns_zone_id" {
  type = string
}

variable "admin_ssh_key" {
  type      = string
  sensitive = true
}

variable "vpc_id" {
  type = string
}


variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}
