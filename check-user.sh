#!/bin/bash

source pre-checks.sh

DIRECTORY="/home/$USERNAME"
flag=0

group_count=$(cat /etc/group | awk -F ':' '{print $1}' | grep "^$USERNAME-group$" | wc -l)
# echo "Group= $group_count"

home_path=$(cat /etc/passwd | grep -w "^$USERNAME" | awk -F':' '{print $6}')
#echo "$home_path"

user_count=$(cat /etc/passwd | awk -F ':' '{print $1}' | grep "^$USERNAME$" | wc -l)
# echo "User= $user_count"

if [ "$group_count" -eq 1 ]; then
	echoMessage "Group $USERNAME-group already exist."
else
	sudo groupadd $USERNAME-group
	echoSuccess "Group $USERNAME-group Created."
fi

if [ -d "$DIRECTORY" ] && [ $user_count -eq 1 ]; then
	flag=1
	if [ "$DIRECTORY" != "$home_path" ]; then		# If user exist but having having diff home dir
		echoMessage "Existing User has different home directory"
		echoMessage "Updating the Home Directory to $DIRECTORY"
		sudo usermod -d $DIRECTORY $USERNAME
	else
		echoSuccess "The User $USERNAME already exist with home directory"
	fi		
fi

if [ $flag -eq 0 ]; then

	if [ -d "$DIRECTORY" ]; then
		#echo "$DIRECTORY exist."
		sudo useradd -m -d $DIRECTORY -g $USERNAME-group -s /bin/bash -c "BitBucket User" $USERNAME # Home Dir overwritten
		echo -e "$PASSWORD\n$PASSWORD" | passwd "$USERNAME"
		echoSuccess "User $USERNAME Created Successfully with password."
	else
		#echo "$DIRECTORY do not exist."
		sudo useradd -m -g $USERNAME-group -s /bin/bash -c "BitBucket User" $USERNAME
		echo -e "$PASSWORD\n$PASSWORD" | passwd "$USERNAME"
		echoSuccess "User $USERNAME Created Successfully with password."
	fi
fi


STRING="$USERNAME ALL=(ALL:ALL) NOPASSWD:ALL"
FILE="/etc/sudoers"

#echoMessage "Adding Sudo entry for $USERNAME"

if  grep -q "$STRING" "$FILE" ; then
	 echoMessage "Sudo Entry is already Present."
else
         echo "$STRING" >> "$FILE"
	 echoSuccess "Sudo Entry is added to the Sudoers File."
fi
