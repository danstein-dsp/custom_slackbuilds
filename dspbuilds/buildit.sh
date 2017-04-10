
NAME=$1
DEFPATH="/home/dan/git/custom_slackbuilds/dspbuilds"
FILEIN=$DEFPATH'/dspbuilds.txt'
TMPFILE='/tmp/dsp.tmp'
CWD=$(pwd)
WKGPATH=$CWD'/temp/'
echo $WKGPATH
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
echo Making Package for $NAME
echo from $LOCATION
echo in $WKGPATH
echo $DOWNLOAD
mkdir $WKGPATH
cd $WKGPATH
cp $DEFPATH/$LOCATION/* ./
echo $DOWNLOAD_x86_64

if [ "$DOWNLOAD_x86_64" == "DOWNLOAD_x86_64:" ];  then
    echo BOOM
    wget $DOWNLOAD
else
    wget $DOWNLOAD_x86_64
fi
chmod +x $NAME.dspbuild
./$NAME.dspbuild
cd $CWD
rm -R $WKGPATH

