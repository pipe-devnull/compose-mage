#! /bin/bash
#set -ex

# Required Environment variables are defined in the
# sroucefile file.  Run `source sourcefile` on the
# cmd line prior to running this script or export the
# varialbes manually or in a CI script/tool.


wget https://getcomposer.org/composer.phar
mkdir htdocs

# OPTIONAL: Clone a mage install and restored a test DB here in place of using  
# magerun.  Standard Method ids to use Mage run for the base magento code due 
# to an issue with how it performs its sample-data installs in conjunction 
# with the noDownload flag.
#------------------------------------------------------------------------------- 
##------------------------------------------------------------------------------- 
#cd htdocs && git clone https://pipedevnull@bitbucket.org/pipedevnull/magento-community-edition-1.git .
#mysql -u $MAGEDB_DBUSER -p$MAGEDB_DBPASS $MAGEDB_DBNAME < /path/to/mysqldump.sql
#cd ../
#-------------------------------------------------------------------------------
##------------------------------------------------------------------------------- 

# Get mage run
wget https://files.magerun.net/n98-magerun.phar 

# Install all ouor modules
php composer.phar install

# Install Magento using mage-run
# NO-DOWNLOAD OPTION php n98-magerun.phar install --dbHost=$DBHOST --dbUser=$DBUSER --dbPass=$DBPASS --dbName=$DBNAME --installSampleData=$SAMPLEDATA --useDefaultConfigParams=yes --magentoVersionByName="magento-mirror-1.9.3.1" --installationFolder="htdocs" --baseUrl="http://magento-demo.com" --noDownload
php n98-magerun.phar install --dbHost=$MAGEDB_DBHOST --dbUser=$MAGEDB_DBUSER --dbPass=$MAGEDB_DBPASS --dbName=$MAGEDB_DBNAME --installSampleData=$MAGEDB_SAMPLEDATA --useDefaultConfigParams=yes --magentoVersionByName="magento-mirror-1.9.3.1" --installationFolder="htdocs" --baseUrl=$MAGE_BASEURL

echo "===================================="
echo "Now update your hosts entry & create"
echo "a vhost"
echo "===================================="
