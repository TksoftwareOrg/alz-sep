variable "audit_log_analytics_enabled" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
Enable or disable the deployment of a dedicated Log Analytics Workspace for audit logs.

When set to `true`, a resource group and Log Analytics Workspace will be deployed according to the
`audit_log_analytics_settings` variable, separate from the platform Log Analytics Workspace deployed
by `management_resource_settings`.
When set to `false`, no audit Log Analytics resources will be deployed.

Defaults to `true`.
DESCRIPTION
}

variable "audit_log_analytics_settings" {
  type = object({
    location                                  = string
    resource_group_name                       = optional(string)
    log_analytics_workspace_name              = optional(string)
    log_analytics_workspace_sku               = optional(string)
    log_analytics_workspace_retention_in_days = optional(number)
    log_analytics_workspace_daily_quota_gb    = optional(number)
    tags                                      = optional(map(string))
  })
  default     = null
  description = <<DESCRIPTION
The settings for the dedicated audit Log Analytics Workspace.

Properties:
- `location` - (Required) The Azure region where the audit Log Analytics Workspace will be deployed.
- `resource_group_name` - (Optional) The name of the resource group for the audit resources.
- `log_analytics_workspace_name` - (Optional) The name of the audit Log Analytics Workspace.
- `log_analytics_workspace_sku` - (Optional) The SKU of the audit Log Analytics Workspace.
- `log_analytics_workspace_retention_in_days` - (Optional) The data retention period in days for the audit workspace.
- `log_analytics_workspace_daily_quota_gb` - (Optional) The daily ingestion quota in GB for the audit workspace.
- `tags` - (Optional) A map of tags to assign to the audit resources.

Details of the underlying settings can be found in the module documentation at
https://registry.terraform.io/modules/Azure/avm-res-operationalinsights-workspace/azurerm
DESCRIPTION
}
