#! /bin/bash

  sudo apt-get update
  sudo apt-get install default-jdk -y
  sudo apt-get install tomcat9 -y
  sudo apt-get install tomcat9-docs tomcat9-examples tomcat9-admin -y
  sudo cp -r /usr/share/tomcat9-admin/* /var/lib/tomcat9/webapps/ -v

  sudo bash -c 'cat > /etc/tomcat9/tomcat-users.xml <<EOF
<?xml version="1.0" encoding="UTF-9"?>
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
  <role rolename="manager-script"/>
  <user username="tomcat" password="password" roles="manager-script"/>
</tomcat-users>
EOF'

# Restart Tomcat service
sudo systemctl restart tomcat9
#delete this line and input your datadog api key inside
done
