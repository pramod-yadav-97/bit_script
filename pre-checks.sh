#!/usr/bin/bash

source initiation.sh     # count_port_7992 , count_port_7993 , count_port_no
			 #  osname , url_code

clear
# Checking the Linux Flavor
if [ $osname != "Ubuntu" ]; then
	echoError "$osname is not supported"
	exit 1
else
	echoSuccess "Found Compatible Linux Flavor."
fi

# Checking the URL accessibility
if [ $url_code -ne 301 ] && [ $url_code -ne 200 ]; then

        echoError "ERROR : The BitBucket installer url is not accessible. Error Code :: $url_code"
        exit 1
else
	echoSuccess "The BitBucket Binary download URL is accessible."
fi

# Checking the port accessibility
if [ $count_port_7992 -eq 1 ] || [ $count_port_7993 -eq 1 ]; then

        echoError "ERROR: Port 7992 or/and 7993 seems unavailable."
	exit 1

elif [ $count_port_no -eq 1 ] ; then
        echoError "ERROR: Port $PORT is not open."
	exit 1
else
	echoSuccess "Required Ports are accessible"
fi

# Checking the java version

java=$(type -p java)          # Adding this as when directly used print the output in console.

if [[ "$java" == "/usr/bin/java" ]]; then
    echoMessage "Java is Installed." 	
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
    
    echoMessage "Java is Installed." 	
else
    echoMessage "Java is not there, installing Java"
    sudo apt update
    sudo apt install openjdk-11-jre-headless -y
    echoSuccess "Java version 11 is installed"
fi

java_version=$(java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}')

first_com=$(echo "$java_version" | cut -d'.' -f1)

if [ "$first_com" -eq 1 ]; then
        first_com=$(echo "$java_version" | cut -d'_' -f1)		# Overrides if equal to 1
fi

if [ "$first_com" -eq 11 ]; then
        second_com=$(echo $java_version | cut -d'.' -f2)
        third_com=$(echo $java_version | cut -d'.' -f3)
        
        if [ "$second_com" -ge 0 ] && [ "$third_com" -le 8 ]; then
                echoError "This java version $java_version is not supported. Try 11.0.8+ versions."
		exit 1
        fi
        
elif [ "$first_com" == "1.8.0" ]; then
        second_com=$(echo "$java_version" | cut -d'_' -f2)	 
        if [ "$second_com" -le 65 ] || [ "$second_com" -eq 311 ] || [ "$second_com" -eq 321 ]; then
                echoError "This java version $java_version is not supported. Try 8u65+ excluding 8u311 and 8u321."
		exit 1
        fi
else
        echoError "This Java version $java_version isn't supported by Bitbucket."
        exit 1
fi


# Checking the Git version

git=$(type -p git)

if [[ "$git" == "/usr/bin/git" ]] || [[ "$git" == "/usr/local/bin/git" ]] ; then
	echoMessage "Git is Installed"
#        git_ver=$(git --version | cut -d' ' -f3)
#        echo "Installed version is $git_ver"
else
        echoError "Git is not installed. Execute upgrade-git.sh first."
	exit 1
fi

git_version=$(git version | awk '{ print $3 }')

first_com=$(echo "$git_version" | cut -d'.' -f1)
second_com=$(echo "$git_version" | cut -d'.' -f2)
third_com=$(echo "$git_version" | cut -d'.' -f3)

git_flag=0

if [ "$first_com" -lt 2 ]; then
        echoMessage "Git version $git_version is not supported"
	git_flag=1
elif [ "$first_com" -eq 2 ]; then
        if [ "$second_com" -le 25 ] && [ "$third_com" -ge 0 ]; then
                echoMessage "Git version $git_version is not supported"
		git_flag=1
	fi
fi

if [[ "$git_flag" -eq 1 ]] ;then

        echoError "Upgrade git to latest Supported version. Execute upgrade-git.sh first"
        exit 1
fi
