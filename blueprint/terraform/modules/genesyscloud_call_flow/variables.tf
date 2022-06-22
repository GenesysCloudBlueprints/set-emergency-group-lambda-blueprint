variable "prefix" {
  type        = string
  description = "A name that is to be used as the resource name prefix. Usually it's the project name."
}

variable "environment" {
  type        = string
  description = "Name of the environment, e.g., dev, test, stable, staging, uat, prod etc."
}

variable "secondary_flow_file_path" {
  type        = string
  description = "YAML file path for architect flow configuration. This is the flow referenced by the emergency group."
}
