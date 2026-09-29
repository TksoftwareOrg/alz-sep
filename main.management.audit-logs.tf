module "audit_resource_group" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.2.2"
  count   = var.audit_log_analytics_enabled ? 1 : 0

  name             = coalesce(module.config.outputs.audit_log_analytics_settings.resource_group_name, "rg-audit-${module.config.outputs.audit_log_analytics_settings.location}")
  location         = module.config.outputs.audit_log_analytics_settings.location
  enable_telemetry = var.enable_telemetry
  tags             = coalesce(module.config.outputs.audit_log_analytics_settings.tags, module.config.outputs.tags)

  providers = {
    azurerm = azurerm.management
  }
}

module "audit_log_analytics_workspace" {
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "0.5.1"
  count   = var.audit_log_analytics_enabled ? 1 : 0

  name                                      = coalesce(module.config.outputs.audit_log_analytics_settings.log_analytics_workspace_name, "law-audit-${module.config.outputs.audit_log_analytics_settings.location}")
  resource_group_name                       = module.audit_resource_group[0].name
  location                                  = module.config.outputs.audit_log_analytics_settings.location
  log_analytics_workspace_sku               = module.config.outputs.audit_log_analytics_settings.log_analytics_workspace_sku
  log_analytics_workspace_retention_in_days = module.config.outputs.audit_log_analytics_settings.log_analytics_workspace_retention_in_days
  log_analytics_workspace_daily_quota_gb    = module.config.outputs.audit_log_analytics_settings.log_analytics_workspace_daily_quota_gb
  enable_telemetry                          = var.enable_telemetry
  tags                                      = coalesce(module.config.outputs.audit_log_analytics_settings.tags, module.config.outputs.tags)

  providers = {
    azurerm = azurerm.management
  }
}
