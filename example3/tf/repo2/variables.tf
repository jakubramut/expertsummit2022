locals {
  rg_name     = "tf-${var.company}-${var.env}-${substr(var.location, 0, 2)}-rg-0302"
  rg_shd_name = "tf-${var.company}-${var.env}-${substr(var.location, 0, 2)}-rg-shd-0301"
  kv_name     = "tf${var.company}${var.env}${substr(var.location, 0, 2)}kv0301"
  vnet_name   = "tf-${var.company}-${var.env}-${substr(var.location, 0, 2)}-vnet-0302"
  aks_name    = "tf-${var.company}-${var.env}-${substr(var.location, 0, 2)}-aks-0302"
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
