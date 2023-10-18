variable "env_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "dns_zone_name" {
  type = string
}

variable "bucket_state" {
  type = string
}

variable "bucket_discovery" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "admin_ssh_key" {
  type = string
}

variable "kubernetes_version" {
  type = string
}


variable "master_machine_type" {
  type = string
}

variable "node_machine_type" {
  type = string
}

variable "node_min_size" {
  type = number
}

variable "node_max_size" {
  type = number
}

variable "public_subnets" {
  type = list(object({
    id    = string
    zone  = string
    cidr  = string
    index = number
  }))
}
