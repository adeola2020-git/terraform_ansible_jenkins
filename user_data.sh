#!/bin/bash
apt update
apt upgrade -y
apt install apache2 -y
echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
systemctl start apache2
systemctl enable apache2

# echo "Hello world from highly available group of ec2 instances" > /var/www/html/index.html
