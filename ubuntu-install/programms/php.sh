#!/bin/bash

sudo add-apt-repository ppa:ondrej/php

sudo apt install php7.4	 --yes
sudo apt install php7.4-bcmath php-redis php-soap php7.4-zip php7.4-cli php7.4-common php7.4-curl php7.4-fpm php7.4-intl php7.4-json php7.4-mbstring php7.4-pgsql php7.4-xml --yes
sudo apt install php-dev php-pear php-xdebug --yes

# Copy php config here

# Installing kafka
sudo apt install librdkafka-dev
sudo pecl install rdkafka
sudo pecl install mongodb

ln -s $(realpath 99-php-ini.ini)  /etc/php/7.4/cli/conf.d/99-php-ini.in
ln -s $(realpath 99-php-ini.ini)  /etc/php/7.4/fpm/conf.d/99-php-ini.in
ln -s $(realpath 99-php-ini.ini)  /etc/php/7.4/apache2/conf.d/99-php-ini.in
# Add rdkafka and mongo to php config

mkdir ~/Downloads/composer
cd ~/Downloads/composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
chmod +x composer.phar
sudo mv ./composer.phar /usr/local/bin/composer