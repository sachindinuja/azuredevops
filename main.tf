provider "azurerm" {
  features {}
}

# Variables for dynamic configuration
variable "resource_group_name" {
  default = "my-resource-group"
}

variable "location" {
  default = "East US"
}

variable "acr_name" {
  default = "myacr"
}

variable "frontend_container_name" {
  default = "frontend-container"
}

variable "backend_container_name" {
  default = "backend-container"
}

variable "frontend_image" {
  default = "myacr.azurecr.io/frontend-app:latest"
}

variable "backend_image" {
  default = "myacr.azurecr.io/backend-app:latest"
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Frontend Container Instance
resource "azurerm_container_group" "frontend" {
  name                = var.frontend_container_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"

  container {
    name   = "frontend"
    image  = var.frontend_image
    cpu    = "1"
    memory = "1.5"

    ports {
      port     = 3000
      protocol = "TCP"
    }
  }

  ip_address_type = "Public"
  dns_name_label  = "frontend-${var.resource_group_name}"
}

# Backend Container Instance
resource "azurerm_container_group" "backend" {
  name                = var.backend_container_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"

  container {
    name   = "backend"
    image  = var.backend_image
    cpu    = "1"
    memory = "1.5"

    ports {
      port     = 5000
      protocol = "TCP"
    }
  }

  ip_address_type = "Public"
  dns_name_label  = "backend-${var.resource_group_name}"
}
