#!/bin/bash

nextcloud="18.0.1"
ext=".0"
office="4.2.0.4"
mariadb="10.4"
tagversion=$nextcloud$ext

git add .
git commit . -m "Nextcloud "$nextcloud" / Collabora "$office" / MariaDB "$mariadb
git tag -a $tagversion -m "Nextcloud "$nextcloud" / Collabora "$office" / MariaDB "$mariadb
git push -u origin master
git push -u origin --tag
