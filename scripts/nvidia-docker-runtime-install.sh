# Add apt repo for nvidia container runtime
curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list

sudo apt-get update

# Install it
sudo apt-get install nvidia-container-runtime

# Restart docker daemon to apply
sudo service docker restart

# Verify that it works
docker run --gpus all ubuntu:18.04 nvidia-smi
# If it works it should print a table with info about your gpu(s)
