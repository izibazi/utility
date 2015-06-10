#!/bin/bash
echo "Input username.This name is projectname and hostname."
read name

id $name > /dev/null 2>&1
if [ 0 -eq $? ]; then
	echo "Error.${name} already exists."
	exit 1
fi

echo "Add user '$name'.?"
echo "If yes, input 'y'."
read confirm
if [ "y" != $confirm ]; then
	echo "You canceled."
	exit 1
fi

which useradd > /dev/null 2>&1
if [ 0 -eq $? ]; then
	useradd -m ${name}
	dir="/home/${name}"
	passwd $name
else 
	echo "Error.useradd command not found."
	echo "Execute as root user."
	exit 1
fi

cd $dir

which gpasswd
if [ 0 -eq $? ]; then
	gpasswd -a apache $name
	gpasswd -a ftpuser $name
	mkdir -p www/htdocs
	mkdir -p www/logs
	mkdir -p www/apps
	touch www/htdocs/index.html
	chown -R $name:$name www
	chmod 750 .
	chmod -R 770 ./www
	ls -al
	cd www/htdocs/
	echo $name > index.html
fi

# Virtualhost setting
conf_dir='/etc/httpd/sites-available'
template="${conf_dir}/_template_auth"
echo "Required basic auth?"
echo "If yes, input 'y'."
read confirm
if [ "y" != $confirm ]; then
template="${conf_dir}/_template"
fi

conf="${conf_dir}/${name}"
enabled_sym_conf="/etc/httpd/sites-enabled/${name}"
echo "VirtualHost file creating..."
sed -e s/username/$name/g $template > $conf
ln -s $conf $enabled_sym_conf
echo "$enabled_sym_conf created."
cat $enabled_sym_conf

echo "httpd configtest OK?"
service httpd configtest
echo "httpd restart now?"
echo "If yes, input 'y'."

read confirm
if [ "y" != $confirm ];then
	echo "Canceled httpd restart."
	exit 1
else
	echo "Start httpd restart."
	service httpd restart
fi

