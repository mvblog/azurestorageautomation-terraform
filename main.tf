#Create resourcegroup
resource "azurerm_resource_group" "rg" {
  name     = var.rgname
  location = var.location
  tags = var.tagsmap
}

#Call storage module for each storageaccount
module "createstorage" {
  for_each = var.sa
  source  = "./modules/storage"

  rgname= azurerm_resource_group.rg.name
  saname= each.key
  location= var.location
  subnetid= lookup(var.subnetidmap,each.key)
  keyvault= var.keyvault
  keyvaultresourcegroup= var.keyvaultresourcegroup
  enckeyname = var.enckeyname
  enckeyversion =  var.enckeyversion
  salockname = var.salockname
  fs= each.value  
  fsacl= var.fsacl
  objectid = var.objectid
  tagsmap =var.tagsmap  
}