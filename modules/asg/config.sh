#!/bin/bash

URL='https://www.tooplate.com/zip-templates/2131_wedding_lite.zip'
ART_NAME='2131_wedding_lite'
TEMPDIR="/tmp/webfiles"

PACKAGE="apache2 wget unzip"
SVC="apache2"

echo "Installing packages."
sudo apt update
sudo apt install $PACKAGE -y > /dev/null

echo "Start & Enable HTTPD Service"
sudo systemctl start $SVC
sudo systemctl enable $SVC

echo "Starting Artifact Deployment"
mkdir -p $TEMPDIR
cd $TEMPDIR

wget $URL > /dev/null
unzip $ART_NAME.zip > /dev/null
sudo cp -r $ART_NAME/* /var/www/html/

echo "Restarting HTTPD service"
systemctl restart $SVC

echo "Removing Temporary Files"
rm -rf $TEMPDIR
echo "cleanup done"