# https://docs.aws.amazon.com/aws-technical-content/latest/jenkins-on-aws/installation.html

sudo yum update –y

sudo yum install java-1.8.0 -y
sudo yum remove java-1.7.0-openjdk -y

sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat/jenkins.repo

sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

sudo yum install jenkins -y

sudo service jenkins start