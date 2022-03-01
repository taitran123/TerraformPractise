#!/bin/bash
sudo yum update -y && sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
# # docker run -p 8080:80 nginx
# sudo mount /dev/xvdh /data_disk
volume="xvdh"
mount_point="/data_disk"
sudo mkdir $mount_point
sudo chown ec2-user:ec2-user $mount_point

uuid=$(lsblk -f | grep $volume)
uuid=$(echo $uuid | awk '{print $NF}')
echo $uuid
sudo echo "UUID=$uuid $mount_point  xfs  defaults,nofail  0  2" >> /etc/fstab     
                                                                      
sudo mount /dev/$volume $mount_point

cd /home/ec2-user
docker-compose up -d
