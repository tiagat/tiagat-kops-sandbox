variable "env_name" {
  type = string
}

variable "domain" {
  type = string
}

variable "vpc_subnet" {
  type = string
}

variable "public_subnets" {
  type = list(object({
    cidr = string
    zone = string
  }))
}
