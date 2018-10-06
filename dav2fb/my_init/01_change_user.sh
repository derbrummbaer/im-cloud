#!/bin/bash

echo "Benuter ID: "$USERID
echo "Gruppen ID: "$GROUPID


	[ "$USERID" ] && usermod  -o -u "$USERID" ubuntu
	[ "$GROUPID" ] && groupmod -o -g "$GROUPID" ubuntu

echo "Gruppen Bearbeiten erledigt"
