variable "workload" {
  default = "molyneux-me"
}

variable "environment" {
  default = "dev"
}

variable "location" {
  default = "uksouth"
}

variable "subscription_id" {}

variable "dns" {
  type = object({
    subscription_id     = string
    resource_group_name = string
    domain              = string
    subdomain           = string
  })
}

variable "tags" {
  default = {}
}
