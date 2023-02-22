#! /bin/bash

  sudo apt-get update
  sudo apt-get install default-jdk -y
  sudo apt-get install tomcat8 -y
  sudo apt-get install tomcat8-docs tomcat8-examples tomcat8-admin -y
  sudo cp -r /usr/share/tomcat8-admin/* /var/lib/tomcat8/webapps/ -v

  sudo bash -c 'cat > /var/lib/tomcat8/conf/tomcat-users.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
  <role rolename="manager-script"/>
  <user username="tomcat" password="password" roles="manager-script"/>
</tomcat-users>
EOF'

# Restart Tomcat service
sudo systemctl restart tomcat8

done