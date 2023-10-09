variable "env_name" {
  type = string
}

variable "dns_zone_name" {
  type = string
}

variable "dns_zone_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(object({
    id    = string
    cidr  = string
    zone  = string
    index = number
  }))
}

variable "private_subnets" {
  type = list(object({
    id    = string
    cidr  = string
    zone  = string
    index = number
  }))
}
