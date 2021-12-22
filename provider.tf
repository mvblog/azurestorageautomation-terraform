provider "azurerm" {
  # Configuration options
  features {}
  #alternate to defining subscriptionid here would be to export environment variable ARM_SUBSCRIPTION_ID before running terraform.
  subscription_id = "" 
  use_msi = true
}
