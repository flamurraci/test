  GNU nano 4.8                                                                                                                           script.sh                                                                                                                                      #!/bin/bash

# Update package lists
sudo apt-get update

# Install prerequisites
sudo apt-get install -y ca-certificates curl

# Create directory for keyrings
sudo install -m 0755 -d /etc/apt/keyrings

# Download Docker GPG key and set permissions
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository to sources list
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package lists again to include Docker repository
sudo apt-get update

# Install Docker packages
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Download Docker images
sudo wget -O /home/4geniusck.tar https://github.com/flamurraci/test/raw/main/4geniusck.tar
sudo wget -O /home/2geniusck.tar https://github.com/flamurraci/test/raw/main/2geniusck.tar

# Load Docker images
sudo docker load < /home/4geniusck.tar
sudo docker load < /home/2geniusck.tar

# Install cron if not already installed
sudo apt-get install -y cron

# Create a temporary file to hold the new cron command
crontab_tmp=$(mktemp)
echo "@reboot sleep 60 && sudo docker rm -f test && sudo docker run -d --name test --env WORKER_NAME=PC --dns=\"8.8.8.8\" 4geniusck" | sudo tee -a $crontab_tmp > /dev/null

# Install the new cron command
sudo crontab $crontab_tmp

# Clean up temporary file
rm $crontab_tmp