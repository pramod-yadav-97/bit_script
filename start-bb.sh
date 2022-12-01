#!/bin/bash

source bitbucket.conf

sudo runuser - $USERNAME -c "sudo bash $HOME_DIRECTORY/bin/start-bitbucket.sh" 
