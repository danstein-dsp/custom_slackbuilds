#!/bin/bash
#Moves list of slackbuild
txtfile=$1
CWD=$(pwd)

while IFS= read -r inline; do

    infile=~/git/slackbuilds/$inline
    outfile=$inline
    echo $CWD
    echo $outfile
    MTD=$CWD/$outfile
    echo $MTD
    echo "look Good ?"
    echo ok
    mkdir $outfile
    cd $MTD
    cd ..
    cp -vur $infile ./
    echo $outfile $outFile
    cd $MTD
    rm *.SlackBuild
    cd $CWD
    echo "next"
done < "$txtfile"
