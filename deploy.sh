#!/bin/bash

REPO_PATH=`dirname "$0"`
REPO_PATH=`cd "$REPO_PATH"; pwd`

cd $REPO_PATH


if which apt-get; then
	bash Debian-based.sh
fi

if which yum; then
	bash RPM-based.sh
fi


# config git
git config --global user.name Young Yang
git config --global user.email afe.young@gmail.com
if ! grep "gitlog" ~/.bashrc ; then
	echo 'alias gitlog="git log --all --oneline --graph --decorate"' >> ~/.bashrc
fi
git config --global merge.tool vimdiff
git config --global mergetool.prompt false



# clone repos
cd ~
if [ ! -e code_tools_repo ]; then
	git clone https://github.com/you-n-g/code_tools_repo
fi


# config bashrc
if ! grep "export EDITOR" ~/.bashrc ; then
	echo "export EDITOR=`which vim`" >> ~/.bashrc
fi

if ! grep "export PATH" ~/.bashrc ; then
    mkdir -p $HOME/bin/
	echo 'export PATH="$HOME/bin/:$PATH"' >> ~/.bashrc
fi

# proxy_related
if ! grep "^proxy_up" ~/.bashrc ; then
    cat >>~/.bashrc <<EOF
function proxy_up() {
    # don't capitalize them
    export http_proxy=127.0.0.1:6489
    export https_proxy=127.0.0.1:6489
    export SOCKS_SERVER=127.0.0.1:8964
}
function proxy_down() {
    unset http_proxy https_proxy SOCKS_SERVER
}
export no_proxy=localhost,127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.sock
EOF
fi


# config vim

if [ -e ~/.vim ]; then
    mv ~/.vim ~/.vim.bak
fi
git clone https://github.com/tpope/vim-pathogen ~/.vim

cd ~/.vim

if [ ! -e bundle ]; then
    git clone https://github.com/you-n-g/bundle
    cd bundle
    # git submodule init
    git submodule update --init --recursive
fi

## config for command-t
cd ~/.vim/bundle/command-t/ruby/command-t/
ruby extconf.rb && make

## config for YCM
wget https://raw.githubusercontent.com/rasendubi/dotfiles/master/.vim/.ycm_extra_conf.py -O ~/.vim/.ycm_extra_conf.py
cd  ~/.vim/bundle/YouCompleteMe/
git submodule update --init --recursive
bash ./install.sh

## 最后才copy vimrc， 因为太早拷贝vimrc会导致错误
if [ ! -e ~/.vimrc ]; then
	cp ~/code_tools_repo/code_to_copy/backend/etc/vimrc ~/.vimrc
fi
