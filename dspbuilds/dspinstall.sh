#Build and install pkgs & their REQ pkgs
INAME=$1
DESTDIR='/usr/share/files/dspbuilds'
DEFPATH="/home/dan/git/custom_slackbuilds/dspbuilds"
FILEIN=$DEFPATH'/dspbuilds.lst'
TMPFILE='/tmp/dspbt.tmp'
TMPFILE2='/tmp/dspbt2.tmp'
BUILDLST='/tmp/'$1'bldlst.tmp'
CWD=$(pwd)
WKGPATH=$CWD'/temp/'
./buildlst.sh $INAME > $TMPFILE
./makeodr.sh $TMPFILE > $TMPFILE2
./rmvdup.sh $TMPFILE2 > $BUILDLST
function build_pkg (){
    NAME=$1
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
    if [ "$(grep -c 'NAME: '$NAME $FILEIN)" == "0" ]; then
        echo ERRRR!!! MISSING $NAME ADDING NOW!
	./mvslb.sh $PKG
	./dspinstall $PKG
    fi
    mkdir $WKGPATH
    cd $WKGPATH
    cp -r $DEFPATH/$LOCATION/* ./
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
    cp -v /tmp/$NAME*dsp.tgz $DESTDIR
    ls $DESTDIR/$NAME*dsp.tgz > $TMPFILE
    exec < $TMPFILE
    read INPKG
    rm $TMPFILE
    installpkg $INPKG

}
####MAIN####
FILELIST=()
while IFS= read -r line
    do  
        FILELIST+=("$line")
    done < $BUILDLST
for PKG in "${FILELIST[@]}"        
    do
#        echo building $PK
        PKLOC="/var/log/packages/"$PKG"*"

        if [ ! -f $PKLOC ];
        then build_pkg $PKG 
        fi
# add checks if pkg prebuilt or needs updating	
    done 

