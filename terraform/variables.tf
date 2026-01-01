variable "workload_name" {
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

variable "platform_monitoring_state" {
  description = "Backend config for platform-monitoring remote state"
  type = object({
    resource_group_name  = string
    storage_account_name = string
    container_name       = string
    key                  = string
    subscription_id      = string
    tenant_id            = string
  })
}

variable "platform_workloads_state" {
  description = "Backend config for platform-workloads remote state"
  type = object({
    resource_group_name  = string
    storage_account_name = string
    container_name       = string
    key                  = string
    subscription_id      = string
    tenant_id            = string
  })
}
