#! /bin/bash
#set -ex

# Use a db backup form another environment for this install
# and change all settings to match this context.
# 
############################################
# Notes:
# 
# 1. Put the SQL dump file in this folder and call it magento-db.sql
# 2. Any backups will bbe created in the current dir with the dateime in the name
# 3. see sourcefile for ENV variables that are mentioned within this script
############################################

DATETIME=$(date +'%Y%m%d%s')

# Restore the DB, backup the current DB first if required
if [ 1 == $BK_DUMP_BEFORE_RESTORE ]; then
  mysqldump -h $MAGEDB_DBHOST -u $MAGEDB_DBUSER $MAGEDB_DBNAME > magento-db-bk-$DATETIME.sql  
fi

mysql -h $MAGEDB_DBHOST -u $MAGEDB_DBUSER -p$MAGEDB_DBPASS -e "DROP DATABASE $MAGEDB_DBNAME"
mysql -h $MAGEDB_DBHOST -u $MAGEDB_DBUSER -p$MAGEDB_DBPASS -e "CREATE DATABASE $MAGEDB_DBNAME"
mysql -h $MAGEDB_DBHOST -u $MAGEDB_DBUSER $MAGEDB_DBNAME < $DB_DUMP -p$MAGEDB_DBPASS

# Switch out the domain on all urls that contain the old domain (base urls & cookie domain)
mysql -h $MAGEDB_DBHOST -u $MAGEDB_DBUSER $MAGEDB_DBNAME -p$MAGEDB_DBPASS -e "UPDATE core_config_data SET value=REPLACE(value,'$BK_ORIGIN_BASEURL','$MAGE_DOMAIN') WHERE value LIKE '%$BK_ORIGIN_BASEURL%';"

# Change the email account used for all the transactional emails etc. so any automatic emails are sent to us
# Then print out any config value that has 
mysql -h $MAGEDB_DBHOST -u $MAGEDB_DBUSER $MAGEDB_DBNAME -p$MAGEDB_DBPASS -e "UPDATE core_config_data SET value='$DEV_EMAIL' WHERE value LIKE '%@%' AND path LIKE 'trans_email%';"
mysql -h $MAGEDB_DBHOST -u $MAGEDB_DBUSER $MAGEDB_DBNAME -p$MAGEDB_DBPASS -e "SELECT * FROM core_config_data WHERE value LIKE '%@%';"

cd htdocs

#  Reset encryption key if set in vars
if [ -z "$BK_ORIGIN_ENCRYPTIONKEY" ]; then
  sed -i -e 's/<key><\!\[CDATA\[.*\]\]><\/key>/<key><\!\[CDATA\[$BK_ORIGIN_ENCRYPTIONKEY]\]><\/key>/g' app/etc/local.xml
fi

# Create an admin account for the magento backend
php ../n98-magerun.phar admin:user:create magentodev $DEV_EMAIL $DEFAULT_PASSWORD Magento Dev Administrators
php ../n98-magerun.phar admin:user:list

# Re-index the catalog (rewrites etc)
php ../n98-magerun.phar cache:clean
php ../n98-magerun.phar index:reindex:all

# clear caches
php ../n98-magerun.phar cache:clean
php ../n98-magerun.phar cache:list