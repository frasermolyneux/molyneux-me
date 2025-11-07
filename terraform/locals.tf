locals {
  resource_group_name   = "rg-${var.workload}-${var.environment}-${var.location}"
  static_web_app_name   = "stapp-${var.workload}-${var.environment}-${var.location}"
  app_data_storage_name = "sa${random_id.environment_id.hex}"
}
