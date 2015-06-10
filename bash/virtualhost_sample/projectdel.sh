#!/bin/bash
echo "Input username.This name is projectname and hostname."
read name

id $name > /dev/null 2>&1
if [ 0 -ne $? ]; then
	echo "Error.${name} not exists."
	exit 1
fi

echo "Delete user '$name'?If OK, input 'y'."
read confirm
if [ "y" != $confirm ]; then
	echo "You canceled."
	exit 1
fi

which userdel > /dev/null 2>&1
if [ 0 -eq $? ]; then
	userdel -r ${name}
	groupdel ${name}
else 
	echo "Error.userdel command not found."
	echo "Execute as root user."
	exit 1
fi

cd $dir

# Virtualhost setting
conf_dir='/etc/httpd/sites-available'
template="${conf_dir}/_template"
conf="${conf_dir}/${name}"
enabled_sym_conf="/etc/httpd/sites-enabled/${name}"
echo "VirtualHost file deleting..."
rm $enabled_sym_conf

echo "httpd configtest OK?"
service httpd configtest
echo "httpd restart now?"
echo "If yes, input 'y'"

read confirm
if [ "y" != $confirm ];then
	echo "Canceled httpd restart."
	exit 1:
else
	echo "Start httpd restart."
	service httpd restart
fi
