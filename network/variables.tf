variable "env_name" {
  type = string
}

# variable "public_subnet_cidrs" {
#   type = list(string)
# }
# variable "private_subnet_cidrs" {
#   type = list(string)
# }

# variable "availability_zones" {
#   type = list(string)
# }


variable "public_subnets" {
  type = list(object({
    cidr = string
    zone = string
  }))
}

variable "private_subnets" {
  type = list(object({
    cidr = string
    zone = string
  }))
}
