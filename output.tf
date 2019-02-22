output "aws_instance_public_dns" {
  value = "${aws_instance.jenkins_ec2.public_dns}"
}