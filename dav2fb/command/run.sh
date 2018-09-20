#!/bin/bash

# Scripte zum starten des Imports der Carddav Kontakte in die Fritz Box

#cd /opt/carddav2fb

find /opt/carddav2fb/config/ -type f | while read line; do 
#	echo $line; 
	/usr/bin/php /opt/carddav2fb/carddav2fb.php $line;
done

exit

for i in "/opt/carddav2fb/config/*.php"; do
	/usr/bin/php /opt/carddav2fb/carddav2fb.php $i
done
# Kontakte für das Telefonbuch Familie Berger importieren
#echo "/usr/bin/php /opt/carddav2fb/carddav2fb.php /opt/carddav2fb/config.berger.php"

# Kontakte für das Telefonbuch Familie Harks importieren
#echo "/usr/bin/php /opt/carddav2fb/carddav2fb.php /opt/carddav2fb/config.harks.php"
