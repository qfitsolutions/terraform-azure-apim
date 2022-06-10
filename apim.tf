    data "azurerm_resource_group" "rg" {
      name = "Your resource group name"
      
    }


    data "azurerm_api_management" "apim_service" {
      name                = "your apim service name"
      resource_group_name = data.azurerm_resource_group.rg.name
      
    }


    terraform {
      required_providers {
        azurerm = {
          source  = "hashicorp/azurerm"
          version = "=2.66.0"
        }
      }
    }


    # Configure the Microsoft Azure Provider

     provider "azurerm" {
       features {}
     }

  
  resource "azurerm_api_management_api" "sample-api" {
      name                = "Test-2"
      resource_group_name = data.azurerm_resource_group.rg.name
      api_management_name = data.azurerm_api_management.apim_service.name
      revision            = "1"
      display_name        = "API-1"
      path                = "API"
      protocols           = ["https", "http"]
      description         = "example"
      
    }


    resource "azurerm_api_management_api_schema" "example" {
      api_name            = azurerm_api_management_api.sample-api.name
      api_management_name = azurerm_api_management_api.sample-api.api_management_name
      resource_group_name = azurerm_api_management_api.sample-api.resource_group_name
      schema_id           = "example-schema"
      content_type        = "application/vnd.oai.openapi.components+json"
      value               = <<JSON
      {
    "properties": {
        "contentType": "application/vnd.oai.openapi.components+json",
        "document": {
          "components": {
            "schemas": {
                "Definition1": {
                  "type": "object",
                  "properties": {
                    "String1": {
                      "type": "string"
                    }
                  }
                },
                "Definition2": {
                  "type": "object",
                  "properties": {
                    "String2": {
                      "type": "integer"
                    }
                  }
                }
              }
          }
        }
      }
    }
    JSON
    }


    resource "azurerm_api_management_api_operation" "get-info" {
      operation_id        = "info"
      api_name            = azurerm_api_management_api.sample-api.name
      api_management_name = data.azurerm_api_management.apim_service.name
      resource_group_name = data.azurerm_resource_group.rg.name
      display_name        = "Get info Testing"
      method              = "POST"
      url_template        = "/info"
      description         = "foo"
      request {
         representation {
        schema_id    = azurerm_api_management_api_schema.example.schema_id
        content_type = azurerm_api_management_api_schema.example.content_type
        sample = azurerm_api_management_api_schema.example.value
        type_name = "test"
      }
      }
      response {
        status_code = 200
      }
      response {
        status_code = 400
      }
      response {
        status_code = 401
      }
      response {
        status_code = 403
      }
      response {
        status_code = 404
      }
    }
