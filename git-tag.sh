#!/bin/bash

nextcloud="16.0.7"
ext=".1"
office="4.2.0.1"
mariadb="10.4"
tagversion=$nextcloud$ext

git add .
git commit . -m "Nextcloud "$nextcloud" / Collabora "$office" / MariaDB "$mariadb
git tag -a $tagversion -m "Nextcloud "$nextcloud" / Collabora "$office" / MariaDB "$mariadb
git push -u origin master
git push -u origin --tag
