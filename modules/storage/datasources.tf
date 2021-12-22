# Import data sources Information

data "azurerm_key_vault" "keyvault" {
    name                = "${var.keyvault}"
    resource_group_name = "${var.keyvaultresourcegroup}"
}
