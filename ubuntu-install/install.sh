#!/bin/bash
dir=$PWD
RUNZHS='no'

sudo apt install apt-transport-https ca-certificates curl software-properties-common

# We need to install specific version of PostgreSQL because of this we add here packages from
# official repository
sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
echo 'deb http://www.rabbitmq.com/debian/ testing main' | sudo tee /etc/apt/sources.list.d/rabbitmq.list
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb https://repo.pritunl.com/stable/apt focal main
EOF
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A

sudo apt update
sudo apt upgrade

# Install soft from snap
sudo snap install bitwarden
sudo snap install telegram-desktop
sudo snap install kontena-lens --classic
sudo snap install spotify
sudo snap install phpstorm --classic
sudo snap install --classic code

# Install some needed software
sudo apt install gnome-tweak-tools
sudo apt install pritunl-client-electron
sudo apt install vim

# Installing JetBrainsMono fonts
mkdir JetBrainsMono
cd JetBrainsMono
wget https://download.jetbrains.com/fonts/JetBrainsMono-2.001.zip
unzip JetBrainsMono-2.001.zip
cd ttf
mkdir ~/.local/share/fonts/
mv JetBrainsMono-*.ttf ~/.local/share/fonts/
cd $dir
rm -rf JetBrainsMono

# Install and setup ZSH
sudo apt install zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
cd ..
rm $(realpath ~)/.zshrc
ln -s $(realpath zshrc) $(realpath ~)/.zshrc

# Configure git
rm $(realpath ~)/.gitconfig
ln -s $(realpath gitconfig) $(realpath ~)/.gitconfig

# Installing php 7.4 and some other needed tools
sudo apt install php7.4	
sudo apt install php7.4-cli php7.4-common php7.4-curl php7.4-fpm php7.4-intl php7.4-json php7.4-mbstring php7.4-pgsql php7.4-xml
sudo apt install php-pear
sudp apt install php-xdebug

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
# TODO: add here copying php config file for installed php 

# Installing pgsql
sudo apt install postgresql-9.6
# TODO: Add default configs for pgsql if needed

# Installing RabbitMQ
sudo apt-get install rabbitmq-server
sudo rabbitmq-plugins enable rabbitmq_management

# Installing MongoDB
sudo apt install mongodb-server

# Installing docker
sudo apt install docker-ce
sudo usermod -aG docker ${USER}
# Installing docker compose
curl -s https://api.github.com/repos/docker/compose/releases/latest \
  | grep browser_download_url \
  | grep docker-compose-Linux-x86_64 \
  | cut -d '"' -f 4 \
  | wget -qi -
chmod +x docker-compose-Linux-x86_64
sudo mv docker-compose-Linux-x86_64 /usr/local/bin/docker-compose

