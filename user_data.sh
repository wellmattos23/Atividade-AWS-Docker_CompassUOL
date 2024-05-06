#!/bin/bash
sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user

sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo yum install -y amazon-efs-utils
sudo systemctl start amazon-efs-utils
sudo systemctl enable amazon-efs-utils

sudo mkdir /mnt/efs

sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-07dd8b042408b3dc2.efs.us-east-1.amazonaws.com:/ /mnt/efs
sudo echo "fs-07dd8b042408b3dc2:/ /mnt/efs nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0" >> /etc/fstab

sudo mkdir /mnt/efs/wordpress


sudo cat <<EOL > /mnt/efs/docker-compose.yaml
version: '3.8'
services:
  wordpress:
    image: wordpress:latest
    restart: always
    ports:
      - 80:80
    environment:
      TZ: America/Sao_Paulo
      WORDPRESS_DB_HOST: database-project.czw4o8kqe03v.us-east-1.rds.amazonaws.com
      WORDPRESS_DB_NAME: rds_project
      WORDPRESS_DB_USER: admin
      WORDPRESS_DB_PASSWORD: admin123
    volumes:
      - /mnt/efs/wordpress:/var/www/html
EOL

sudo yum install libxcrypt-compat -y
docker-compose -f /mnt/efs/docker-compose.yaml up -d