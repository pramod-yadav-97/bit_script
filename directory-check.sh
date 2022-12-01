#!/bin/bash

source check-user.sh

create_directory() {
    su - $USERNAME << DONE
        if [ -d "$1" ]; then
	  printf "|     MESSAGE:  %5s \n" "$1 Already Exist."
	else
	  printf "|     MESSAGE:  %5s \n"  "$1 does not exist"
	  printf "|     MESSAGE:  %5s \n"  "Creating the directory"
	  sudo mkdir -p $1                                     # Added NOPASSWD 
	  printf "|* SUCCESS:  %5s \n"  "Directory $1 Created."
	fi
DONE

}


create_directory $INSTALLATION_DIRECTORY
create_directory $HOME_DIRECTORY
