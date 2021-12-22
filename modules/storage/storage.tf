# variable to assign ACLs at scope:access and default
locals {
  scopetype = [ "access" , "default" ]
}

# create storage account 
resource "azurerm_storage_account" "sa" {  
  name                  = var.saname
  resource_group_name      = var.rgname
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"
  access_tier             = "hot"
  allow_blob_public_access = "false"
  is_hns_enabled            = "true"
  enable_https_traffic_only = "true"
  account_kind              = "StorageV2"
  min_tls_version           = "TLS1_2"

  blob_properties {
   delete_retention_policy {
     days = 30
   }
   container_delete_retention_policy {
     days = 30
   }
 }

  # restrict access to the storage account
  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = var.subnetid
  }

  # Enable identity on the storage account
  identity {
      type = "SystemAssigned"
  }
 
  # prevent any accidental deletes of the storage account by terraform
  lifecycle {
        prevent_destroy= true
  }
}

# assign RBAC role "key vault crypto user" access to the storage account, this is needed to enable encryption on the sa 
resource "azurerm_role_assignment" "sa-role" {
  scope                = data.azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Crypto User"
  principal_id = azurerm_storage_account.sa.identity[0].principal_id  
}

# enable encryption on storage account
resource "azurerm_storage_account_customer_managed_key" "cmk" {  
  storage_account_id = azurerm_storage_account.sa.id
  key_vault_id       = data.azurerm_key_vault.keyvault.id
  key_name           = var.enckeyname
  key_version        = var.enckeyversion
}

# enable lock on storage account to prevent accidental deletes on the storage account
resource "azurerm_management_lock" "lock" {
  name       = var.salockname
  scope      = azurerm_storage_account.sa.id 
  lock_level = "CanNotDelete"
}

# create gen2_filesystem on the storage account
resource "azurerm_storage_data_lake_gen2_filesystem" "filesystem" {
  for_each    = toset(var.fs)
  name               = each.value
  storage_account_id = azurerm_storage_account.sa.id
  lifecycle {
    prevent_destroy= true
  }

  #Assign read ACL(r-x) to all groups defined under category : grpread, gets executed only when there are grpreads defined for the geven gen2_filesystem
  #setproduct assigns the ACL for both the scopes: access and default
  dynamic "ace" {                     
                     for_each = setproduct((lookup(var.fsacl, each.value, null) == null ? [] : lookup(lookup(var.fsacl, each.value, null),"grpread",[]) ),local.scopetype)                    
                     content { 
                                 type = "group"
                                 scope = ace.value.1
                                 id = lookup(var.objectid,ace.value.0,"")
                                 permissions = "r-x"                                                       
                               }
                } 

  #Assign write ACL(rwx) to all groups defined under category : grpwrite
  dynamic "ace" {
                     for_each = setproduct((lookup(var.fsacl, each.value, null) == null ? [] : lookup(lookup(var.fsacl, each.value, null),"grpwrite",[]) ),local.scopetype) 
                     content {
                                 type = "group"
                                 scope = ace.value.1
                                 id = lookup(var.objectid,ace.value.0,"")
                                 permissions = "rwx"                                                       
                            }
                }  

  #Assign read ACL(r-x) to all groups defined under category : usrread
  dynamic "ace" {
                     for_each =  setproduct((lookup(var.fsacl, each.value, null) == null ? [] : lookup(lookup(var.fsacl, each.value, null),"usrread",[]) ),local.scopetype)                    
                     content {
                                 type = "user"
                                 scope = ace.value.1
                                 id = lookup(var.objectid,ace.value.0,"")
                                 permissions = "r-x"                                                       
                            }
                }  

  #Assign write ACL(rwx) to all groups defined under category : usrwrite
  dynamic "ace" {
                     for_each =  setproduct((lookup(var.fsacl, each.value, null) == null ? [] : lookup(lookup(var.fsacl, each.value, null),"usrwrite",[]) ),local.scopetype)                               
                     content {
                                type = "user"
                                scope = ace.value.1
                                id = lookup(var.objectid,ace.value.0,"")
                                permissions = "rwx"                                                       
                            }
                }                   
           
}




