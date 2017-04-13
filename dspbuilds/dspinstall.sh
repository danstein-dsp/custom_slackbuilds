INAME=$1
DEFPATH="/home/dan/git/custom_slackbuilds/dspbuilds"
FILEIN=$DEFPATH'/dspbuilds.txt'
TMPFILE='/tmp/dsp.tmp'
TMPFILE2='/tmp/dsp2.tmp'
BUILDLST='/tmp/bldlst.tmp'
CWD=$(pwd)
WKGPATH=$CWD'/temp/'
./buildlst.sh $INAME > $TMPFILE
./makeodr.sh $TMPFILE > $TMPFILE2
./rmvdup.sh $TMPFILE2 > $BUILDLST
function build_pkg {
$NAME=$1
grep -A 9 'NAME: '$NAME $FILEIN | cut -d " " -f2- > $TMPFILE
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
#echo $DOWNLOAD
mkdir $WKGPATH
cd $WKGPATH
cp $DEFPATH/$LOCATION/* ./
#echo $DOWNLOAD_x86_64
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
}



