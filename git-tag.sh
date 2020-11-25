#!/bin/bash

nextcloud="19.0.5"
ext=".0"
office="6.4.1.3"
mariadb="10.5"
tagversion=$nextcloud$ext

git add .
git commit . -m "Nextcloud "$nextcloud" / Collabora "$office" / MariaDB "$mariadb
git tag -a $tagversion -m "Nextcloud "$nextcloud" / Collabora "$office" / MariaDB "$mariadb
git push -u origin master
git push -u origin --tag
