module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.8.0"

  for_each = var.ec2_instances

  name          = each.key
  ami           = each.value.ami
  instance_type = each.value.instance_type
  #TODO - It should create the key pair if it does not exist and if enabled by the user
  key_name   = each.value.key_name
  monitoring = each.value.monitoring
  #TODO - This module can create a SG or apply an existing one if the user set it
  vpc_security_group_ids      = each.value.vpc_security_group_ids
  subnet_id                   = each.value.subnet_id
  create_iam_instance_profile = true
  iam_role_description        = "IAM role for the EC2 instance"
  iam_role_policies = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  }


  #TODO - Fix it to be possible to add extra tags
  # extra_tags = {
  #   Terraform   = "true"
  #   Environment = "dev"
  # }
}