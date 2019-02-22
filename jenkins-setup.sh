# https://docs.aws.amazon.com/aws-technical-content/latest/jenkins-on-aws/installation.html

sudo yum update –y

sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat/jenkins.repo

sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

sudo yum install jenkins -y

sudo service jenkins start