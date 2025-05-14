#Environment
variable "project_name" {
    description = "The name of the project"
    type        = string
    default     = "" # Default project name
  
}

variable "environment" {
    description = "The project environment" 
    type        = string
    default     = "" # Default environment
  
}

variable "extra_tags" {
  description = "Extra tag to be applied to resources"
  type        = any
  default     = {}

}

variable "name" {
  description = "The name of the Helm release"
  type        = string
}

variable "namespace" {
  description = "The namespace to install the Helm release into"
  type        = string
}

variable "repository" {
  description = "The repository URL of the Helm chart"
  type        = string
}

variable "chart" {
  description = "The name of the Helm chart"
  type        = string
}

variable "chart_version" {
  description = "The version of the Helm chart"
  type        = string
  
}

variable "create_namespace" {
  description = "Whether to create the namespace if it does not exist"
  type        = bool
  default     = false
}

variable "values" {
  description = "Path to the values file for the Helm release"
  type        = string
}


