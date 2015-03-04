#!/bin/sh

# プロジェクトテンプレート
# プロジェクトディレクトリ作成
# バーチャルホスト設定、アパッチ再起動までを自動化
#
# author ishibashi@shed
#

echo "Input new project name, please."
read project

if [ ${#project} -gt 1 ]; then

	if [ -e $project ]; then
		echo "[ERROR] '$project' directory exists already!"
		exit 1
	else
		original=${project}
		project=`tr '[A-Z]' '[a-z]' <<<$project`
		htdocs="$original/$project.example.co.jp/htdocs"
		logs="$original/$project.example.co.jp/logs"
		files="$original/$project.example.co.jp/files"
		staff="$original/Staff"

		mkdir -pv $htdocs
		if [ $? -ne 0 ]; then
			echo [ERROR] Cant make directory.
			exit 1
		fi
		mkdir -pv $files
		mkdir -pv $logs
		mkdir -pv $staff

		echo "$project created.Upload your project files." > "$htdocs/index.html"
		chmod -R 777 $htdocs
		chmod -R 777 $files
		echo "[SUCCESS]"
		echo "'$project' project files created."

		conf=local.$project.example.co.jp.conf
		cd /etc/apache2/virtualhost.d/


		if [ $? -ne 0 ]; then
			echo "[WANING]Virtual host file directory not exist."
			echo "Can't create '$conf'."
			exit 1
		fi
		dir=$(pwd)
		if [ -e $conf ]; then
			echo "[ERROR] '$conf' file already exists."
			exit 1
		else
			if [ ! -e template.txt ]; then
				echo "[ERROR]"
				echo "$dir/template.txt is not found."
				exit 1
			fi

			sed -e "s/hostname/$project/g" -e "s/ProjectName/$original/g" template.txt > $conf
			sudo sh -c "echo 127.0.0.1 local.$project.example.co.jp >> /etc/hosts"
			echo "[SUCCESS] Virtual host file '$dir/$conf' created." 
			echo "Added 127.0.0.1 local.$project.example.co.jp to /etc/hosts"
			echo ">>>> Start apachectl configtest."
			echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
			sudo apachectl configtest
			echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
			
			cat << EOF
		
Setup svn and trac on your server.

# Setup svn.

1.ssh sakura_example_svn
2.svnadmin create /var/www/svn/$project
3.svn mkdir file:///var/www/svn/$project/trunk file:///var/www/svn/$project/trunk/$project.example.co.jp file:///var/www/svn/$project/trunk/$project.example.co.jp/htdocs file:///var/www/svn/$project/trunk/$project.example.co.jp/files  file:///var/www/svn/$project/tags file:///var/www/svn/$project/branches -m "init repos"
4.sudo chown -R apache:apache /var/www/svn/$project

# Setup trac.

1.sudo trac-admin /var/www/trac/$project initenv
2.sudo chown -R apache:apache /var/www/trac/$project

3./var/www/trac/$project/htdocs/logo.pngを配置
4./var/www/trac/$project/conf/trac.iniを編集
[header_logo]
link = /trac/$project
src = site/logo.png

svn/hook/post-commitで、自動アップロード設定
既存からコピーして必要な部分を変更する
EOF
		fi
	fi
else
		echo "[ERROR] Invalid project name. More than 2 character."
		exit 1
fi
