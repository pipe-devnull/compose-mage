#! /bin/bash
# set -ex

# Required Environment variables are defined in the
# sroucefile file.  Run `source sourcefile` on the
# cmd line prior to running this script or export the
# varialbes manually or in a CI script/tool.

rm -f composer.phar
rm -f n98*.phar
rm -rf htdocs
rm -rf vendor
rm -f composer.lock


mysql -h $MAGEDB_DBHOST -u $MAGEDB_DBUSER -p$MAGEDB_DBPASS -e "drop database ${MAGEDB_DBNAME}"