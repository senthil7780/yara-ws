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