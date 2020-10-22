sudo apt-get update
sudo apt-get upgrade

# Install dependencies to support the addition of a new package repo (docker) that’s using HTTPS connectivity
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker’s official apt repo
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install Docker CE (Community Edition)
sudo apt-get update
sudo apt-get install docker-ce

# Verify installation
docker -v

# Allow docker without "sudo" by adding yourself to the docker group
# You'll need to reboot (or re-login) to apply
sudo groupadd docker
sudo usermod -aG docker "$USER"
newgrp docker
docker run hello-world
