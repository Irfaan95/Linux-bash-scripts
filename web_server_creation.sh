#!/bin/bash

# 1). Check if the the user has root privellages
# id -u returns the usersID (UID).
# -ne 0 checks if the UID is not equal to 0.
if [ "$(id -u)" -ne 0 ]; then
    echo "You need root privileges to run this script."
    exit 1
# If the UID is 0 it will print out a message saying you have root privelages.
else
    echo -e "You have root privileges. Continuing... \n"
    # Add your script logic here.
fi

# 2). Updating system packages
# Update system packages to its latest versions.
echo "checking for updates"
sudo apt update
sudo apt upgrade
echo -e "\nSystem packages have been updated as of $(date)" "\n"

# Functions for Apache/Nginx installations.
install_apache_ubuntu() {
        echo "installing Apache2..."
        sudo apt install apache2 -y
        echo "Apache installation complete"
}

install_nginx_ubuntu() {
	echo "installing Nginx..."
	sudo apt install nginx -y
	echo "Nginx installation complete"
}


# 3). Installing a web server
# Giving the user an option to install either apache or Nginx.
# Using a case statement to read the user input.
# Input determines which case to operate.
echo "Would you like to install Apache or Nginx?"
read web_server
case $web_server in 
	apache)
		install_apache_ubuntu
		;;

	nginx)
		install_nginx_ubuntu
		;;
	*)
	echo "invalid choice. Exiting..."
	exit 1
	;;
esac

# 4). Configure hostname and localhost

# Asking the user to set a custom hostname
echo "please enter a hostname:"
read new_hostname

# Set the hostname using hostnamectl
sudo hostnamectl set-hostname "$new_hostname"

# Update /etc/hosts file to reflect new hostname
sudo sed -i "s/$current_hostname/$new_hostname/g" /etc/hosts

# Inform the user that the hostname has been changed
echo "Hostname changed to: $new_hostname."

# Here is the upodated /etc/hosts file for confirmation
echo "Updated /etc/hosts file:"
cat /etc/hosts

# 5). -------  Creating a HTML web page automatically after initiallising a web server -------
echo "<DOCTYPE html>
    <head>
        <title>Welcome to My Website</title>
    </head>
    <body>
        <h1>Hello world!</h1>
    </body>

</html>" | sudo tee /var/www/html/index.html

# 6). Start and enable web server
# systemctl list-units --type=service command lists all services
# the grep -q apache2 checks if Apache is among the listed services
if systemctl list-units --type=service | grep -q apache2; then
   echo "starting Apache..."
   # Start the web server & set to run on boot
   sudo systemctl start apache2
   sudo systemctl enable apache2
   echo "Apache has been started and set to run on boot."

elif systemctl list-units --type=service | grep -q nginx; then
   echo "starting Nginx..."
   # Start the nginx web server & set to run on boot
   sudo systemctl start nginx
   sudo systemctl enable nginx
   echo "nginx has been started and set to run on boot"
fi

echo "My current IP address is $(hostname -I | awk '{ print $1 }')"
echo "Type this in the search bar to display the HTML page you created"
