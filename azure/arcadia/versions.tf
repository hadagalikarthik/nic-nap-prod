terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
    source = "hashicorp/azurerm"
    version = ">=4.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.15.0"
    }
  }

}