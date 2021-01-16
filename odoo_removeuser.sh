#-------------------------------------------------------------------------------
# This script is used to remove odoo service
#-------------------------------------------------------------------------------
# Make a new file:
# sudo nano odoo_removeuser.sh
# Place this content in it and then make the file executable:
# sudo chmod +x odoo_removeuser.sh
# Execute the script to install Odoo:
# ./odoo_removeuser
################################################################################
##fixed parameters
OE_USER="odoo"
OE_HOME="/$OE_USER"
OE_CONFIG="${OE_USER}-server"
# Set the website name
WEBSITE_NAME="_"

# remove website from nginx
sudo rm /etc/nginx/sites-available/$OE_USER
sudo rm /etc/nginx/sites-enabled/$OE_USER
sudo nginx -t
sudo service nginx reload

# remove service from startup
sudo update-rc.d $OE_CONFIG remove
sudo rm /etc/init.d/$OE_CONFIG

# remove user from database
echo -e "\n---- remove the ODOO PostgreSQL User  ----"
sudo su - postgres -c "dropuser -s $OE_USER" 2> /dev/null || true

# remove folder from server
echo -e "\n---- remove Server Directory ----"
sudo rm /etc/${OE_CONFIG}.conf
sudo su $OE_USER -c "rm -r /var/log/$OE_USER"
sudo su $OE_USER -c "rm -r $OE_HOME"

# remove user
sudouserdel -r -f $OE_USER

# Update Server
echo -e "\n---- Update Server ----"
sudo apt-get update
sudo apt-get upgrade -y
