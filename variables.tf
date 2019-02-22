variable "aws_region" {
  default     = "ap-southeast-1"
}
variable "ami_key_pair_name" {
  default = "mykeypair"
} 

variable "aws_instance_type" {
  default = "m3.medium"
}
variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "network_address_space" {
  default = "172.16.0.0/16"
}
variable "subnet_address_space" {
  default = "172.16.0.0/24"
}