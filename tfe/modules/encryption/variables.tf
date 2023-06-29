variable "default_tags" {
  type        = map(string)
  description = "Default tags for all resources"
}

variable "env" {
  type        = string
  description = "Environment (nonprod, prod)"
}

variable "resource_prefix" {
  type        = string
  description = "Pefix for alle resources"
}
