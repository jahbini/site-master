#! /bin/bash
#
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get python
apt-cache policy docker-ce
sudo apt-get install -y docker-ce
sudo systemctl status docker
apt-get install -y docker-compose
# add swap space
fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
for i in *.sh
do
  j=`basename $i .sh`
  cp $i /usr/games/$j
  chmod 555 /usr/games/$j
done
#