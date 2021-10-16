#===================================================================================================================================================
# Provider Information
#===================================================================================================================================================

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.81.0"
    }
  }
}

provider "azurerm" {
  features {
    
  }
}

#===================================================================================================================================================
# Get LAB Data
#===================================================================================================================================================

data "azurerm_resource_group" "LabRG" {
  name = "jarora-ians-rg"
}

output "id" {
  value = data.azurerm_resource_group.LabRG.id
}

data "azurerm_virtual_network" "LabVNet" {
  name                = "jarora-ians-rg-vnet"
  resource_group_name = "jarora-ians-rg"
}

output "virtual_network_id" {
  value = data.azurerm_virtual_network.LabVNet.id
}

data "azurerm_subnet" "LabSubnet" {
  name                 = "default"
  virtual_network_name = "jarora-ians-rg-vnet"
  resource_group_name  = "jarora-ians-rg"
}

output "subnet_id" {
  value = data.azurerm_subnet.LabSubnet.id
}

#===================================================================================================================================================
#LAB
#===================================================================================================================================================

module "windows_servers" {
  source              = "Azure/compute/azurerm"
  resource_group_name = data.azurerm_resource_group.LabRG.name
  vm_hostname         = var.vm_srv_hostname
  admin_password      = var.admin_passwd
  vm_os_sku           = "2019-datacenter"
  vm_os_publisher     = "microsoftwindowsserver"
  vnet_subnet_id      = data.azurerm_subnet.LabSubnet.id
  vm_size             = "Standard_B2ms"
  nb_instances        = "2"

}

module "windows_desktops" {
  source              = "Azure/compute/azurerm"
  resource_group_name = data.azurerm_resource_group.LabRG.name
  is_windows_image    = true
  vm_hostname         = var.vm_vdi_hostname
  admin_password      = var.admin_passwd
  vm_os_sku           = "20h1-pron"
  vm_os_publisher     = "windows-10"
  vnet_subnet_id      = data.azurerm_subnet.LabSubnet.id
  vm_size             = "Standard_B2ms"
  nb_instances        = "2"
}
