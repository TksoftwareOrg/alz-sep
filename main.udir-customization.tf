module "udir_customization" {
  source = "./modules/udir-customizations"
  location = var.starter_locations[0]
  resource_group_name = module.management_resources[0].resource_group.name
  
  providers = {
    azurerm = azurerm.management
  }
}