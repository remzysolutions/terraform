#! /bin/bash

  sudo apt-get update
  sudo apt-get install default-jdk -y
  sudo apt-get install tomcat9 -y
  sudo apt-get install tomcat9-docs tomcat9-examples tomcat9-admin -y
  sudo cp -r /usr/share/tomcat9-admin/* /var/lib/tomcat9/webapps/ -v

  echo "<role rolename="manager-script"/>" | sudo tee -a /etc/tomcat9/tomcat-users.xml
  echo "<user username="tomcat" password="password" roles="manager-script"/>" | sudo tee -a /etc/tomcat9/tomcat-users.xml

# Restart Tomcat service
sudo systemctl restart tomcat9
#delete this line and input your datadog api key inside
done
