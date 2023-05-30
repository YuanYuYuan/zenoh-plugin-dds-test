## Install Docker & Docker Compose on Ubuntu 20.04

### Docker and docker compose prerequisites

```bash
sudo apt-get install -y \
    curl \
    gnupg \
    ca-certificates \
    lsb-release
```

### Download the docker gpg file to Ubuntu

```bash
sudo mkdir -p /etc/apt/demokeyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/demokeyrings/demodocker.gpg
```

### Add Docker and docker compose support to the Ubuntu's packages list

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/demokeyrings/demodocker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update -y
```

### Install docker and docker compose on Ubuntu

```bash
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

### Verify the Docker and docker compose install on Ubuntu

```bash
docker run hello-world
```
