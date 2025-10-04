#!/bin/bash
sudo apt update && apt install openjdk-17-jdk -y
sudo apt install maven -y
sudo apt install nodejs npm -y
sudo apt install mariadb-client -y
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins -y
sudo apt install docker.io -y


# #!/bin/bash
# ## Java 
# sudo apt update && apt install openjdk-17-jdk -y
# ## Java 17
# sudo apt install mariadb-client -y

# ## Jenkins
# sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
#   https://pkg.jenkins.io/debian/jenkins.io-2023.key
# echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
#   https://pkg.jenkins.io/debian binary/ | sudo tee \
#   /etc/apt/sources.list.d/jenkins.list > /dev/null
# sudo apt update
# sudo apt install jenkins -y

# ## Docker
# sudo apt install docker.io -y

