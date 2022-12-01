#!/usr/bin/bash

source bitbucket.conf

osname=$(cat /etc/os-release | grep -w "NAME" | cut -d'"' -f2)

count_port_7992=$(ss -tp -H state listening sport = :7992 | wc -l)
count_port_7993=$(ss -tp -H state listening sport = :7993 | wc -l)
count_port_no=$(ss -tp -H state listening sport = :$port | wc -l)

url_code=$(curl -Is $BINARY_URL | head -1 | awk '{ print $2 }')



echoError(){
	
	printf "| ERROR  : %5s \n" "$1"
}


echoSuccess(){
	echo ""
	printf "| ----------------------------------------------------------\n"
        printf "|* SUCCESS: %5s \n" "$1"
	printf "| ----------------------------------------------------------\n"
	echo ""
}

echoMessage(){ 
        printf "|     MESSAGE: %5s \n" "$1"
}


