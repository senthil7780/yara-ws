resource "aws_instance" "jenkins_ec2" {
  ami           = "ami-04677bdaa3c2b6e24"
  instance_type = "${var.aws_instance_type}"
  key_name =  "${var.ami_key_pair_name}"
  security_groups = ["${aws_security_group.jenkins_sg.name}"]
  user_data = "${file("jenkins-setup.sh")}"

  tags {
    Name = "jenkins_server"
  }
}
# Setup the VPC for jenkins server
resource "aws_vpc" "jenkins-vpc" {
  cidr_block = "172.16.0.0/16"
  enable_dns_hostnames = "true"

  tags {
    Name = "jenkins-vpc"
  }
}
# setup the internet gateway to install jenkins and allow internet traffic
resource "aws_internet_gateway" "jenkins-igw" {
  vpc_id = "${aws_vpc.jenkins-vpc.id}"
}

# setup the security group to allow SSH & HTTP
resource "aws_security_group" "jenkins_sg" {
  name = "Jenkins SG"
  description = "Allow SSH & HTTP"
  vpc_id = "${aws_vpc.jenkins-vpc.id}"
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  tags {
    Name = "jenkins-sg"
  }

}