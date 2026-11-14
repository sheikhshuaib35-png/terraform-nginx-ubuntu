output "instance_public_ip" {
  description = "Public IPv4 address of the Terraform-managed Nginx server."
  value       = aws_instance.nginx.public_ip
}