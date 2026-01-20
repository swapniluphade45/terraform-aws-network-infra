output "environment" {
  value = terraform.workspace
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "public_ec2_public_ip" {
  value = aws_instance.public_ec2.public_ip
}

output "private_ec2_private_ip" {
  value = aws_instance.private_ec2.private_ip
}
