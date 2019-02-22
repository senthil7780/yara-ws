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