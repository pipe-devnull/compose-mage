Base Magento Repo
=========================


Stand Alone Environment
------------------------------------

1.  Set up the environment varialbes in `sourcefile`

    # MySQL host location
    export MAGEDB_DBHOST=localhost

    # MySQL user
    export MAGEDB_DBUSER=root

    # MySQL password
    export MAGEDB_DBPASS=

    # MySQL database name
    export MAGEDB_DBNAME=magento_demo

    # Set to yes or no to load the magento sample data
    export MAGEDB_SAMPLEDATA=yes

    # The base URL of the website we are creating
    export MAGE_BASEURL="http://magento-demo.com"

(if you don't want the sample data loaded change the last setting to `no`)

2.  Apply the env variables

    source sourcefile

3.  Install

    ./install.sh

This deos a few things:

* Downloads Composer
* Downloads mage-run
* Installs base modules
* Installs a full magneto instance into ./htocs using mage-run installer

4. Set up a host entry for http://magento-demo.com

    sudo echo "127.0.0.1    magento-demo.com" >> /etc/hosts

5. Set up a Vhost in Apache / Nginx

    Google it


Stand Alone Environment and restore a databse from a different environment
-----------------------------------------------------------------------------

1.  Set up the environment varialbes in `sourcefile`

    # MySQL host location
    export MAGEDB_DBHOST=localhost

    # MySQL user
    export MAGEDB_DBUSER=root

    # MySQL password
    export MAGEDB_DBPASS=

    # MySQL database name
    export MAGEDB_DBNAME=magento_demo

    # Set to yes or no to load the magento sample data
    export MAGEDB_SAMPLEDATA=yes

    # The base URL of the website we are creating
    export MAGE_BASEURL="http://magento-demo.com"

    ##############################################
    # Options below if DB restore is required    #
    ##############################################

    # Path to the magento dump file you want to load
    export DB_DUMP=magento-db.sql

    # The base URL of the dev site we are creating
    export MAGE_DOMAIN="magento-demo.com"

    # The defauly password will be used for creating a new Administrator account
    export DEFAULT_PASSWORD="Asdasd-123"

    # All support email addresses etc. will be reset to the value of this var
    export DEV_EMAIL="dev@dev-email.com"

    # The base URL of the instance the DB dump was taken from 
    export BK_ORIGIN_BASEURL="magento-demo.com"

    # The Magneto encryption key of the instance the DB dump was taken from 
    export BK_ORIGIN_ENCRYPTIONKEY="XXXXXXXXXXXXX"

    # Set 1 if you want to backup the current database before overwriting with this dump
    export BK_DUMP_BEFORE_RESTORE=0


2.  Apply the env variables

    source sourcefile

3.  Install

    ./install.sh

4. Set up a host entry for http://magento-demo.com

    sudo echo "127.0.0.1    magento-demo.com" >> /etc/hosts

5. Set up a Vhost in Apache / Nginx

    Google it

6. Restore your database over the top

    ./restore-database.sh


Base Magento Project
------------------------------------

1. Clone
2. Remove remote (git remote rm origin)
3. Create a new repo and add new remote localtion 
4. Follow steps in above `Stand Alone Environment` section.
5. Optionally clone a base Magento / install from a package rather than installing using Mage-run (see notes in install.sh)
---- Follow whatever branching strategy-----


For Module Builds (CI)
------------------------------------

Use this in order to build a module in isloation against a standard magento installation.

1. Setup a new build job that looks at the module's repo (for change /tag detection)
2. In the build step:
    2.1 Clone this repo
    2.2 Run the `install.sh`
    2.3 Install new module using composer (e.g. composer require ___/___ )
3. Run tests
4. Run checks etc.
5. Issue reports
6. Clear down Build environment using `uninstall.sh`


    
