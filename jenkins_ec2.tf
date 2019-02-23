resource "aws_instance" "jenkins_ec2" {
  ami           = "ami-04677bdaa3c2b6e24"
  instance_type = "${var.aws_instance_type}"
  availability_zone = "${var.aws_availability_zone}"
  key_name =  "${var.ami_key_pair_name}"
  subnet_id = "${aws_subnet.jenkins-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.jenkins_sg.id}"]
  #user_data = "${file("./scripts/jenkins-setup.sh")}"

  connection {
    user = "ec2-user"
    private_key = "${file(var.private_key_path)}"
  }
  provisioner "file" {
    source = "./scripts/jenkins-setup.sh"
    destination = "/tmp/jenkins-setup.sh"
  }
  provisioner "remote-exec" {
    inline = [
     "chmod +x /tmp/jenkins-setup.sh",
     "/tmp/jenkins-setup.sh",
    ]
  }

  tags {
    Name = "jenkins_server"
  }
}
# Setup the VPC for jenkins server
resource "aws_vpc" "jenkins-vpc" {
  cidr_block = "${var.network_address_space}"
  
  enable_dns_hostnames = "true"

  tags {
    Name = "jenkins-vpc"
  }
}
# setup the internet gateway to install jenkins and allow internet traffic
resource "aws_internet_gateway" "jenkins-igw" {
  vpc_id = "${aws_vpc.jenkins-vpc.id}"
}
resource "aws_subnet" "jenkins-subnet" {
  cidr_block = "${var.subnet_address_space}"
  vpc_id = "${aws_vpc.jenkins-vpc.id}"
  availability_zone = "${var.aws_availability_zone}"
  map_public_ip_on_launch = "true"
}


# setup the route table for the default subnet to reach igw
resource "aws_route_table" "jenkins_rtb" {
  vpc_id = "${aws_vpc.jenkins-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.jenkins-igw.id}"
  }
}

resource "aws_route_table_association" "jenkins-rtb-subnet" {
  route_table_id = "${aws_route_table.jenkins_rtb.id}"
  subnet_id = "${aws_subnet.jenkins-subnet.id}"
}

# setup the security group to allow SSH & HTTP within the EC2
resource "aws_security_group" "jenkins_sg" {
  name = "jenkins_sg"
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
# Create an EBS block and attached to the EC2 instance
resource "aws_ebs_volume" "ebs-volume" {
    availability_zone = "${var.aws_availability_zone}"
    size = 500
    type = "st1"
    tags {
        Name = "EBS volume"
    }
}

resource "aws_volume_attachment" "ebs-volume-attachment" {
  device_name = "/dev/xvdf"
  volume_id = "${aws_ebs_volume.ebs-volume.id}"
  instance_id = "${aws_instance.jenkins_ec2.id}"
}


# elastic IP
resource "aws_eip" "jenkins_eip" {
  vpc = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.jenkins_ec2.id}"
  allocation_id = "${aws_eip.jenkins_eip.id}"
}
