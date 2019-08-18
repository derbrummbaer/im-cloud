#!/bin/bash

nextcloud="15.0.11"
ext=".0"
office="4.0.5.2"
tagversion=$nextcloud$ext

git tag -a $tagversion -m "Nextcloud "$nextcloud" / Collabora "$collabora
git push -u origin master
git push -u origin --tag
