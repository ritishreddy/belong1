#!/bin/bash
sudo yum update -y
sudo yum install wget unzip httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime
wget https://belong-coding-challenge.s3-ap-southeast-2.amazonaws.com/belong-test.html
sudo mv belong-test.html /var/www/html/
sudo systemctl restart httpd
