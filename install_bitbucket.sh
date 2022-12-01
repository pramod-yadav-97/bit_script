#!/usr/bin/bash

source directory-check.sh     # count_port_7992 , count_port_7993 , count_port_no 
			 # osname , url_code
			 # User will be created

# Creation of BitBucket user with home directory and adding it to sudoers file.
# We will need root previleges to add user to sudoers file.

bin_name=$(basename $BINARY_URL)

# Downloading the bin file
if [[ -f "$DIRECTORY/$bin_name" ]]; then
	echoMessage "Binary file Exist. Updating executable permission."
	sudo runuser - $USERNAME -c "sudo chmod 755 $bin_name"
	echoSuccess "Permission changed."
else
	echoMessage "Downloading $bin_name file."
	sudo runuser - $USERNAME -c "wget $BINARY_URL"
	sudo runuser - $USERNAME -c "sudo chmod 755 $bin_name"
	echoSuccess "Downloaded and Permissions changed"
fi

# Now to run the installation wizard to complete the installation

#sudo runuser - $USERNAME -c "echo -e \"$PROCESS\n$TYPE\n$HOME_DIRECTORY\n$INSTALLATION_DIRECTORY\n$PORT\n$INSTALL_AS_SERVICE\n$FINAL_APPROVAL\n$LAUNCH_APPLICATION\n$LAUNCH_BROWSER\" | sudo ./$bin_name"

if [[ $? -eq 0 ]]; then
	echoSuccess "The BitBucket Application is Up and Running"
else
	echoError "Something's Wrong \n Check free Space \n BitBucket Already installed "
fi



