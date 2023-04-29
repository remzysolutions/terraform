#! /bin/bash

  sudo apt-get update
  sudo apt-get install default-jdk -y
  sudo apt-get install tomcat9 -y
  sudo apt-get install tomcat9-docs tomcat9-examples tomcat9-admin -y
  sudo cp -r /usr/share/tomcat9-admin/* /var/lib/tomcat9/webapps/ -v

  # Define the new roles and user
NEW_ROLES="<role rolename=\"manager\"/>\n  <role rolename=\"manager-gui\"/>\n  <role rolename=\"manager-script\"/>\n  <role rolename=\"manager-status\"/>"
NEW_USER="<user username=\"tomcat\" password=\"password\" roles=\"manager,manager-gui,manager-script,manager-status\"/>"

# Add the new roles and user to the tomcat-users.xml file
sudo sed -i "/<\/tomcat-users>/i \ \ $NEW_ROLES\n\n  $NEW_USER" /etc/tomcat9/tomcat-users.xml

# Restart Tomcat service
sudo systemctl restart tomcat9
#delete this line and input your datadog api key inside
done
