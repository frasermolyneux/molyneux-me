locals {
  static_web_app_name   = "stapp-${var.workload_name}-${var.environment}-${var.location}"
  app_data_storage_name = "sa${random_id.environment_id.hex}"

  workload_resource_groups = {
    for location in [var.location] :
    location => data.terraform_remote_state.platform_workloads.outputs.workload_resource_groups[var.workload_name][var.environment].resource_groups[lower(location)]
  }

  workload_backend = try(
    data.terraform_remote_state.platform_workloads.outputs.workload_terraform_backends[var.workload_name][var.environment],
    null
  )

  workload_administrative_unit = try(
    data.terraform_remote_state.platform_workloads.outputs.workload_administrative_units[var.workload_name][var.environment],
    null
  )

  workload_resource_group = local.workload_resource_groups[var.location]

  monitor_action_groups = data.terraform_remote_state.platform_monitoring.outputs.monitor_action_groups

  monitor_action_group_ids = {
    critical      = local.monitor_action_groups.critical.id
    high          = local.monitor_action_groups.high.id
    moderate      = local.monitor_action_groups.moderate.id
    low           = local.monitor_action_groups.low.id
    informational = local.monitor_action_groups.informational.id
  }
}
