#!/bin/bash

# Update your system
sudo apt-get update
sudo apt-get upgrade -y

# Install Java
sudo apt-get install -y default-jre
sudo apt-get install -y default-jdk

# Install PostgreSQL
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
sudo wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
sudo apt -y install postgresql postgresql-contrib


# Create a new PostgreSQL user
sudo -u postgres createuser sonar
sudo -u postgres psql -c "ALTER USER sonar WITH ENCRYPTED PASSWORD 'password';"
sudo -u postgres psql -c "CREATE DATABASE sonarqube OWNER sonar;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;"
sudo -u postgres createdb -O sonar sonarqube

# Download and extract SonarQube
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.6.0.39681.zip
sudo apt -y install unzip
sudo unzip sonarqube*.zip -d /opt
sudo mv /opt/sonarqube-8.6.0.39681 /opt/sonarqube -v

# Create Group and User
sudo groupadd sonarGroup
sudo useradd -c "user to run SonarQube" -d /opt/sonarqube -g sonarGroup sonar 
sudo chown sonar:sonarGroup /opt/sonarqube -R

# Configure SonarQube
sudo sed -i 's|#sonar.jdbc.username=|sonar.jdbc.username=sonar|' /opt/sonarqube/conf/sonar.properties
sudo sed -i 's|#sonar.jdbc.password=|sonar.jdbc.password=password|' /opt/sonarqube/conf/sonar.properties
echo "sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube" | sudo tee -a /opt/sonarqube/conf/sonar.properties


# Edit profile run as user
sudo sed -i 's|#RUN_AS_USER=|RUN_AS_USER=sonar|' /opt/sonarqube/bin/linux-x86-64/sonar.sh

# Create the SonarQube systemd service file
sudo tee /etc/systemd/system/sonar.service > /dev/null <<EOF
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
LimitNOFILE=131072
LimitNPROC=8192

User=sonar
Group=sonarGroup
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Kernel System change
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
echo "fs.file-max=65536" | sudo tee -a /etc/sysctl.conf

# Security change
echo "sonar   -   nofile   65536" | sudo tee -a /etc/security/limits.conf
echo "sonar   -   nproc    4096" | sudo tee -a /etc/security/limits.conf

# Start SonarQube
sudo sysctl -p
sudo systemctl start sonar
sudo systemctl enable sonar
#delete this line and input your datadog api key inside

done
