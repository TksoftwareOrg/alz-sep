resource "azurerm_user_assigned_identity" "ama" {
  location            = var.location
  name                = "id-management-ama-${var.location}"
  resource_group_name = var.resource_group_name
}


resource "azurerm_log_analytics_workspace" "example" {
  name                = "log-analytics-management-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  # plan                = "Basic" // Spare penger da dette ikke er low-latency data. Skal kun brukes til statistikk og Defender workbooks
  retention_in_days   = 180 // Eller lengre for man vil gjerne ha statistikk
}

resource "azurerm_log_analytics_solution" "example" {
  solution_name         = "SecurityCenterFree"
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.example.id
  workspace_name        = azurerm_log_analytics_workspace.example.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityCenterFree" // Denne lager nødvendige tabeller slik at continous export fungerer via Defender policies
  }
}