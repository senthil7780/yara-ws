resource "aws_instance" "jenkins_ec2" {
  ami           = "ami-04677bdaa3c2b6e24"
  instance_type = "${var.aws_instance_type}"
  key_name =  "${var.ami_key_pair_name}"
  #vpc_security_group_ids
  subnet_id = "${aws_subnet.jenkins-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.jenkins-sg.id}"]

  tags {
    Name = "jenkins_server"
  }
}
resource "aws_vpc" "jenkins-vpc" {
  cidr_block = "${var.network_address_space}"
  enable_dns_hostnames = "true"

  tags {
    Name = "jenkins-vpc"
  }
}

resource "aws_internet_gateway" "jenkins-igw" {
  vpc_id = "${aws_vpc.jenkins-vpc.id}"
}

resource "aws_subnet" "jenkins-subnet" {
  cidr_block = "${var.subnet_address_space}"
  vpc_id = "${aws_vpc.jenkins-vpc.id}"
  map_public_ip_on_launch = "true"
}

resource "aws_route_table" "jenkins_rtb" {
  vpc_id = "${aws_vpc.jenkins-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.jenkins-igw.id}"
  }
}

resource "aws_route_table_association" "jenkins-rta-subnet" {
  route_table_id = "${aws_route_table.jenkins_rtb.id}"
  subnet_id = "${aws_subnet.jenkins-subnet.id}"
}

resource "aws_security_group" "jenkins-sg" {
  name = "Jenkins group"
  description = "Allow SSH/HTTP"
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