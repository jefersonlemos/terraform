#TODO - Outputs -> EC2 name, sg id, subnet

output "ec2_instance_ids" {
  description = "IDs of all EC2 instances"
  value = {
    for k, inst in module.ec2_instance :
    k => inst.id
  }
}

output "ec2_instance_private_dns" {
  description = "Private DNS of all EC2 instances"
  value = {
    for k, inst in module.ec2_instance :
    k => inst.private_dns
  }
}
