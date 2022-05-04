#!/bin/bash

# Dieses Skript archiviert alle Erweiterungen des extensions-Ordners als einzelne Archive und legt diese im ordner zips ab.

mkdir zips

pwdbak=$(pwd)

ls -1 extensions | while read extension; do
	echo "Create \"${extension}\" zip..."
	cd extensions/$extension/$extension
	zip -r ../../../zips/${extension} *
	cd ${pwdbak}
done

exit 0
