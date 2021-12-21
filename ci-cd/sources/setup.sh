#! /bin/bash

# Jenkins on AWS

# package update
sudo yum update -y
# Add jenkins repo
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
#import a key file from jenkins-CI to enable installation from the package
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade
#Error: Package: jenkins-2.306-1.1.noarch jenkins Requires: daemonize
sudo amazon-linux-extras install epel -y
sudo yum update -y
#install jenkins
sudo yum install jenkins java-1.8.0-openjdk-devel -y
sudo systemsctl daemon-reload
#start jenkins
sudo systemctl start jenkins