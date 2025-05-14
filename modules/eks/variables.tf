variable "project_name" {
    description = "The name of the project"
    type        = string
  
}

variable "environment" {
    description = "The project environment" 
    type        = string
    default     = "" # Default environment
  
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "cluster_endpoint_public_access" {
  description = "Whether the EKS cluster endpoint is publicly accessible"
  type        = bool
  default     = false
}

#Access
variable "define_admin_users" {
  description = "Whether to define admin users"
  type        = bool
  default     = false
  
}

variable "enable_cluster_creator_admin_permissions" {
  description = "Enable admin permissions for the cluster creator"
  type        = bool
  default = false
}

variable "access_entries" {
  description = "Map of access entries to add to the cluster"
  type        = any
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "control_plane_subnet_ids" {
  description = "List of subnet IDs for the EKS control plane"
  type        = list(string)
}

variable "extra_tags" {
  description = "Extra tag to be applied to resources"
  type        = any
  default     = {}

}
