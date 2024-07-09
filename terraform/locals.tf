locals {
  resource_group_name   = "rg-molyneux-me-${var.environment}-${var.location}"
  static_web_app_name   = "stapp-molyneux-me-${var.environment}-${var.location}"
  app_data_storage_name = "sa${random_id.environment_id.hex}"
}
