#!/bin/bash
CWD=$(pwd)
infile=~/git/slackbuilds/$1
outfile=$1
mkdir $outfile
echo $CWD
echo $outfile
#1
echo MTD=$CWD/$outfile
echo $MTD
#2
echo cd $MTD
#3
echo cd ..
#4
echo cp -vur $infile ./
echo $outfile $outFile
#5
echo cd $MTD
#rm *.SlackBuild
echo cd $CWD
