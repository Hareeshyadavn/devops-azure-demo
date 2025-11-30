terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "random" {}

variable "location" {
  default = "eastus"
}

variable "resource_group_name" {
  default = "demo-rg"
}

variable "acr_name" {
  default = "mydemoacr12345" # change to globally unique name
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_app_service_plan" "plan" {
  name                = "demo-appservice-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "azurerm_web_app" "app" {
  name                = "demo-webapp-${random_id.suffix.hex}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.plan.id

  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/devops-azure-demo:latest"
  }

  identity {
    type = "SystemAssigned"
  }
}