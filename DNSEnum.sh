#!/bin/bash

#Get URL for Enumeration
url=$1

#Verify argument
if [ -z "$2" ];then
	echo "##############################################################"
	echo "Exemplo de uso ./DNSEnum exemplo.com.br wordlistSubdomains.txt"
	echo "##############################################################"
	exit 1
fi


# Discovery name services
echo "#######Descovery name services########"
host -t NS $url | cut -d " " -f 4
echo""

echo "#######Discovery mail services########"
# Discoveru Mail services
host -t MX $url | cut -d " " -f 7
echo""

echo "#######################################"
echo "#############Transfer Zone#############"
echo "#######################################"

for nss in $(host -t NS $url | cut -d " " -f 4);do

if host -l $1 $nss | grep -q ";";then

echo "TransferZoneFail on : ${nss}"
echo""
else
echo "TransferZoneSucess on :${nss}"
host -l $1 $nss | grep " has address"
echo""
fi
done
echo""
echo "################################"
echo "#######Search Sub Domains#######"
echo "################################"
echo""

#read line by line on this for
#brute force on subdomains
for subD in $(cat $2); do
	host "$subD$1" | grep "has address"
done
