#-------------------------------------------------------------------------------
# This script is used to add new odoo devloper user used in database engine
#-------------------------------------------------------------------------------
OE_USER="odoo"
OE_group="odoo"

sudo groupadd $OE_group

echo -e "\n---- Creating the ODOO PostgreSQL User  ----"
sudo su - postgres -c "createuser -s $OE_USER" 2> /dev/null || true

sudo adduser --system --quiet --shell=/bin/bash --no-create-home --gecos 'ODOO' --group $OE_USER
sudo adduser $OE_USER $OE_group
