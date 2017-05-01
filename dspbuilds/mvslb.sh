#!/bin/bash
NAME=$1
DEFPATH="/home/dan/git/slackbuilds"
FILEIN=$DEFPATH'/slackbuilds.lst'
TMPFILE='/tmp/dsp.tmp'
CWD=$(pwd)
WKGPATH='/home/dan/git/custom_slackbuilds/dspbuilds'
if [ -f $FILEIN ]; then
    grep -A 9 'NAME: '$1 $FILEIN | cut -d " " -f2- > $TMPFILE
    if [ $(grep -c 'NAME: '$1 $FILEIN) -lt 1 ]; then
        echo ERROR
        exit 69
    else
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
        echo '#Script Modified by Dan Stein (email:dstein614@gmail.com) on '$(date) > $NAME.dspbuild
        sed -e s/SBo/dsp/g -e s/SlackBuild/dspbuild/g < $NAME.SlackBuild >> $NAME.dspbuild
        rm $NAME.SlackBuild
        chmod +x $NAME.dspbuild
        cd $CWD
        ./dspbuildlist.sh > dspbuilds.txt
        echo ______________________________________________
        echo $NAME
        echo Moved to $LOCATION
        echo ______________________________________________
    fi
fi
