locals {
  existing_rg_name = "tf-rg-test-05"
  vnet_name        = "tf-${var.company}-${var.env}-${substr(var.location, 0, 2)}-vnet-05"
  st_name          = "tf${var.company}${var.env}${substr(var.location, 0, 2)}st05"
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
