#!/usr/bin/bash


sudo apt update

sudo apt install libz-dev libssl-dev libcurl4-gnutls-dev libexpat1-dev gettext cmake gcc -y

cd /tmp

curl -o git.tar.gz https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.37.1.tar.gz

tar -zxf git.tar.gz

cd git-*

make prefix=/usr/local all

sudo make prefix=/usr/local install

exec bash

git --version

cd ~
