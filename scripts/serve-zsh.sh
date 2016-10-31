#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

if [ ! -f /usr/local/extra_homestead_software_installed ]; then

    apt-get -y install zsh joe-jupp
    yes yes |  git clone git://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh
    cp /home/vagrant/.oh-my-zsh/templates/zshrc.zsh-template /home/vagrant/.zshrc
    sudo chsh -s $(which zsh) vagrant

    echo 'export PATH=vendor/bin:$PATH'  >> /home/vagrant/.zshrc
    echo "alias art='php artisan'" >> /home/vagrant/.zshrc
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/vagrant/.oh-my-zsh/plugins/zsh-syntax-highlighting

    sed -i "s/plugins=(git)/plugins=(git composer symfony2 z git-extras git-flow zsh-syntax-highlighting )/" /home/vagrant/.zshrc

    touch /home/vagrant/.z
    touch /usr/local/extra_homestead_software_installed

fi