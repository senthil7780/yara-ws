variable "aws_region" {
  default = "ap-southeast-1"
}
variable "aws_availability_zone" {
    default = "ap-southeast-1b"
}
variable "ami_key_pair_name" {
  default = "mykeypair"
} 
variable "aws_instance_type" {
  default = "m3.medium"
}
variable "network_address_space" {
  default = "172.16.0.0/16"
}
variable "subnet_address_space" {
  default = "172.16.0.0/24"
}

variable "private_key_path" {
    default = "mykeypair.pem"
}