output "public_ec2_id" {
  value = aws_instance.public.id
}

output "private_ec2_id" {
  value = aws_instance.private.id
}
