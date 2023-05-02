terraform {
  required_version = ">= 1.1.0"
  backend "azurerm" {
    resource_group_name  = "dogfacttfstate"
    storage_account_name = "dogfacttfstate"
    container_name       = "dogfacttfstate"
    key                  = "dogfacts-ci.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.53.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "dogfacts"
  location = "North Europe"
  tags = {
    environment = "prod"
    project     = "dogfacts"
    managed_by  = "terraform"
  }
}

resource "azurerm_cosmosdb_account" "db" {
  name                = "dogfacts-db"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  offer_type          = "Standard"
  kind                = "MongoDB"
  enable_free_tier    = true

  capacity {
    total_throughput_limit = 1000
  }

  capabilities {
    name = "MongoDBv3.4"
  }
  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }
}

resource "azurerm_service_plan" "plan" {
  name                = "dogfacts"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "F1"
  tags = {
    environment = "prod"
    project     = "dogfacts"
    managed_by  = "terraform"
  }
}

resource "azurerm_linux_web_app" "app" {
  name                = "dogfacts"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.plan.location
  service_plan_id     = azurerm_service_plan.plan.id
  https_only          = true
  site_config {
    minimum_tls_version = "1.2"
    http2_enabled       = true
    always_on           = false
    health_check_path   = "/ping"
    application_stack {
      docker_image     = "docker.io/tualanen/dogfacts"
      docker_image_tag = "latest"
    }

  }
  connection_string {
    name  = "DB"
    type  = "Custom"
    value = azurerm_cosmosdb_account.db.connection_strings[0]
  }

  tags = {
    environment = "prod"
    project     = "dogfacts"
    managed_by  = "terraform"
  }
}
