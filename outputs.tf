output "dev-vpc-id" {
  value = aws_vpc.myapp-vpc.id
}

output "ec2_public_ip" {
  value = module.myapp-server.instance.public_ip
}
