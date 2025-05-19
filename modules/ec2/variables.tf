#Environment variables
variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The project environment"
  type        = string
  default     = "" # Default environment 
}


#Tags
variable "extra_tags" {
  description = "Extra tag to be applied to resources"
  type        = any
  default     = {}
}

#EC2 Instance
variable "ec2_instances" {
  description = "Defines the EC2 instance"
  type = map(object({
    ami                    = string
    instance_type          = string
    key_name               = string
    monitoring             = bool
    subnet_id              = string
    vpc_security_group_ids = list(string)
    # tags          = map(string)
  }))
  default = {
    instance1 = {
      ami                    = ""
      instance_type          = ""
      key_name               = ""
      monitoring             = false
      subnet_id              = ""
      vpc_security_group_ids = [""]
      # tags                  = { Name = "instance1" }
    }
  }
}

