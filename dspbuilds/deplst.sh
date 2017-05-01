# Finds Deps
NAME=$1
DEFPATH="/home/dan/git/custom_slackbuilds/dspbuilds"
FILEIN=$DEFPATH'/dspbuilds.txt'
TMPFILE='/tmp/dsp.tmp'
CWD=$(pwd)
PKGLIST=""
#echo $WKGPATH
grep -B 8 --no-group-separator 'REQUIRES: '$1 $FILEIN | cut -d " " -f2- > $TMPFILE
TOTAL=$(grep -c 'REQUIRES: '$1 $FILEIN)
exec < $TMPFILE
C=0
while [ $C -lt $TOTAL ];    do
    read  NAME  
    read  LOCATION
    read  FILES
    read  VERSION
    read  DOWNLOAD
    read  DOWNLOAD_x86_64
    read  MD5SUM
    read  MD5SUM_x86_64
    read  REQUIRES
    PKGLIST=$PKGLIST$NAME' '
    let C=C+1
done
rm $TMPFILE
echo $TOTAL 'package(s)' affected: $PKGLIST 

