variable "ENV" {
  default = "DEV"
  type    = string
}

variable "APPNAME" {
  default = "NET-TEST"
  type    = string
}

variable "LOCATION" {
  default = "East US"
  type    = string
}

variable "SKU" {
  default     = "F1"
  type        = string
  description = "Which SKU to deploy the ASP to. Choose F1 or B1"

  validation {
    condition     = contains(["F1", "B2"], var.SKU)
    error_message = "Valid values for var: test_variable are (F1, B1)."
  }
}