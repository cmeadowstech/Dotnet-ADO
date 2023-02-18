variable "env" {
  default = "DEV"
  type    = string
}

variable "appname" {
  default = "NET-TEST"
  type    = string
}

variable "location" {
  default = "East US"
  type    = string
}

variable "sku" {
  default     = "F1"
  type        = string
  description = "Which SKU to deploy the ASP to. Choose F1 or B1"

  validation {
    condition     = contains(["F1", "B2"], var.sku)
    error_message = "Valid values for var: test_variable are (F1, B1)."
  }
}