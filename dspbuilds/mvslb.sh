#!/bin/bash
NAME=$1
DEFPATH="/home/dan/git/slackbuilds"
FILEIN=$DEFPATH'/dspbuilds.txt'
TMPFILE='/tmp/dsp.tmp'
CWD=$(pwd)
WKGPATH='/home/dan/git/custom_slackbuilds/dspbuilds/'
#echo $WKGPATH
grep -A 9 'NAME: '$1 $FILEIN | cut -d " " -f2- > $TMPFILE
exec < $TMPFILE
read  NAME  
read  LOCATION
read  FILES
read  VERSION
read  DOWNLOAD
read  DOWNLOAD_x86_64
read  MD5SUM
read  MD5SUM_x86_64
read  REQUIRES
read  SHORT
rm $TMPFILE
mkdir $WKGPATH/$LOCATION
cd $WKGPATH/$LOCATION
cp -vur $DEFPATH/$LOCATION/* ./
mv $NAME.SlackBuild $NAME.dspbuild
chmod +x $NAME.dspbuild
cd $CWD
