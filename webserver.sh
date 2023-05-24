apt update
apt install git
apt-get install apache2 -y && service apache2 start
sudo apt-get install php php-mysqli git mariadb-server -y
cd /var/www/ && git clone https://github.com/OmTegar/tegar-ukl.git
sudo chmod 777 -R /var/www/tegar-ukl/

# Replace the default Apache2 configuration with the custom configuration
cd /etc/apache2/sites-available/
cat <<EOF >000-default.conf
<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/tegar-ukl/

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>
EOF

# Restart Apache2 service
sudo systemctl restart apache2

# Modify the config.php file to use the RDS database

sed -i "s/localhost/10.0.135.182/g" /var/www/tegar-ukl/engine/asset/koneksi.php
sed -i "s/root/tegar/g" /var/www/tegar-ukl/engine/asset/koneksi.php
sed -i "s/\"\"/\"rahasia\"/g" /var/www/tegar-ukl/engine/asset/koneksi.php

sudo mysql -h 10.0.135.182 -u tegar -p <<EOF

# Show existing databases
show databases;

# Create the datasiswa database
create database datasiswa;

# Use the datasiswa database
use datasiswa;

# Import the SQL script to create tables and populate data
source /var/www/tegar-ukl/engine/asset/database/datasiswa.sql

# Show tables in the datasiswa database
show tables;

# Select data from the users table
SELECT * FROM users;

# Exit the MySQL prompt
EOF


