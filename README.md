# yara-ws
workspace for yara exercise

Approach i took to complete the exercise

1) Setup an EC2 instance 
2) setup the security group for EC2 instance
3) setup the subnet
4) setup the route table
5) setup the subnet route table association
6) setup the vpc
7) setup the internet gateway
8) setup the EBS block volume
9) attach the volume to the EC2 instance
10) setup an elastic ip
11) create an elastic ip association
12) setup the installation script
13) use the file provisioner to copy the script
14) use the remote-exec to install jenkins along with java 8

while i am working i found out that my aws account was compromised  due to some careless mistake and have to wait until i setup a new account.

until now the task took around 3.5 hrs without writing unit tests. I have not practised unit tests earlier hence i will take some time.

Inputs: Apart from the access key, secret key & region, we could parameterize the all the names of the resources and size of the EBS block and their availability zones. we could setup appropriate user and role for jenkins by provisioning optimal roles for the EC2 instance.

For extensiblity with other teams/reusing for multiple environments, i would keep the state file uploaded into s3 bucket and pass variables outside from the state file to keep it modularized.


