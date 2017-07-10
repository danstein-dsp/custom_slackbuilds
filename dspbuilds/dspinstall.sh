#Build and install pkgs & their REQ pkgs
INAME=$1
DESTDIR='/usr/share/files/dspbuilds'
DEFPATH="/home/dan/git/custom_slackbuilds/dspbuilds"
FILEIN=$DEFPATH'/dspbuilds.lst'
TMPFILE='/tmp/dspbt.tmp'
TMPFILE2='/tmp/dspbt2.tmp'
BUILDLST='/tmp/bldlst.tmp'
CWD=$(pwd)
WKGPATH=$CWD'/temp/'
#echo 1
./buildlst.sh $INAME > $TMPFILE
#echo 2
./makeodr.sh $TMPFILE > $TMPFILE2
#echo 3
./rmvdup.sh $TMPFILE2 > $BUILDLST

function build_pkg (){
#    echo 4
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
        echo ERROR!!! MISSING $NAME
        exit 69
    fi
#    echo Making Package for $NAME
#    echo from $LOCATION
#    echo in $WKGPATH
#echo $DOWNLOAD
    
    mkdir $WKGPATH
    cd $WKGPATH
    cp -r $DEFPATH/$LOCATION/* ./
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
    cp -v /tmp/$NAME*dsp.tgz $DESTDIR
    ls $DESTDIR/$NAME*dsp.tgz > $TMPFILE
    exec < $TMPFILE
    read INPKG
    rm $TMPFILE
#    echo install $INPKG
    installpkg $INPKG

}
#echo working on $BUILDLST
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

    done 

