#!/bin/bash


# Install wget
echo "Installing wget..."
sudo yum install wget -y

# Install Open JDK
echo "Installing Open JDK..."
sudo yum install java-1.8.0-openjdk.x86_64 -y

# Navigate to /opt directory
echo "Navigating to /opt directory..."
cd /opt

# Download Nexus
NEXUS_VERSION="3.23.0-03"
NEXUS_DOWNLOAD_URL="http://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz"

echo "Downloading Nexus..."
sudo wget ${NEXUS_DOWNLOAD_URL}

# Extract Nexus
echo "Extracting Nexus..."
sudo tar -xvf nexus-${NEXUS_VERSION}-unix.tar.gz

echo "Moving Nexus directory..."
sudo mv nexus-${NEXUS_VERSION} nexus

# Create a Nexus user
echo "Creating Nexus user..."
sudo adduser nexus

# Change ownership of Nexus files
echo "Changing ownership of Nexus files..."
sudo chown -R nexus:nexus /opt/nexus

sudo chown -R nexus:nexus /opt/sonatype-work

# Configure Nexus to run as Nexus user
echo "Configuring Nexus to run as Nexus user..."
sudo sed -i 's/#run_as_user=""/run_as_user="nexus"/' /opt/nexus/bin/nexus.rc

# Modify memory settings in Nexus configuration file
echo "Modifying memory settings in Nexus configuration file..."
sudo tee /opt/nexus/bin/nexus.vmoptions > /dev/null <<EOL
-Xms512m
-Xmx512m
-XX:MaxDirectMemorySize=512m
EOL

# Configure Nexus to run as a service
echo "Configuring Nexus to run as a service..."
sudo tee /etc/systemd/system/nexus.service > /dev/null <<EOL
[Unit]
Description=nexus service
After=network.target
[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort
[Install]
WantedBy=multi-user.target
EOL

# Create a link to Nexus
echo "Creating a link to Nexus..."
sudo ln -s /opt/nexus/bin/nexus /etc/init.d/nexus

# Add Nexus service to boot
echo "Adding Nexus service to boot..."
sudo chkconfig --add nexus

sudo chkconfig --levels 345 nexus on

# Start Nexus
echo "Starting Nexus..."
sudo service nexus start

echo "Nexus installation and setup complete. Access Nexus at http://<your-ip>:8081"
