locals {
  rg_name     = "tf-${var.company}-${var.env}-${substr(var.location, 0, 2)}-rg-01"
  rg_shd_name = "tf-${var.company}-${var.env}-${substr(var.location, 0, 2)}-rg-shd-01"
  kv_name     = "tf${var.company}${var.env}${substr(var.location, 0, 2)}kv01"
  vnet_name   = "tf-${var.company}-${var.env}-${substr(var.location, 0, 2)}-vnet-01"
  aks_name    = "tf-${var.company}-${var.env}-${substr(var.location, 0, 2)}-aks-01"
}

variable "company" {
  type        = string
  description = "Company name"
  default     = "summit"
}

variable "env" {
  type        = string
  description = "Environment name"

  validation {
    condition     = contains(["dev", "test", "stage", "prod"], var.env)
    error_message = "Validation error for env variable."
  }
}

variable "location" {
  type        = string
  description = "Azure region for deployment"

  validation {
    condition     = contains(["westeurope", "northeurope"], var.location)
    error_message = "Validation error for location variable."
  }
}

variable "vnetAddressPrefix" {
  type        = string
  description = "Virtual Network address prefix"
}

variable "aksSubnetAddressPrefix" {
  type        = string
  description = "AKS Subnet Address Prefix"
}
