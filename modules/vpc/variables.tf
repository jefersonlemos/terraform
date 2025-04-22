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
variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
    default     = "" # Default CIDR block for the VPC
}

variable "enable_dns_hostnames" {
    description = "Enable DNS hostnames in the VPC"
    type        = bool
    default     = true # Default to true
  
}

variable "enable_dns_support" {
    description = "Enables DNS support in the VPC"
    type        = bool
    default     = true # Default to true
  
}

#Subnet

variable "routes" {
  type = map(object({
    #   vpc_id = string
      cidr_block = string
      subnet_type = string
  }))
}