#make list of req to build pkg
NAME=$1
DEFPATH="/home/dan/git/custom_slackbuilds/dspbuilds"
FILEIN=$DEFPATH'/dspbuilds.lst'
TMPFILE='/tmp/dspl.tmp'
CWD=$(pwd)
WKGPATH=$CWD'/temp/'
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
REQTMP=$NAME'.bl'
if  [ "$REQUIRES" != "REQUIRES:" ] 
        then
            echo $REQUIRES | awk ' {printf"%i\n",NF
                                    for (i=1; i<=NF; i++) 
                                    printf"%s\n",$i}
                                '>$REQTMP
fi
echo $NAME
if [ -e $REQTMP ]
    then
        exec < $REQTMP
        read NUMDEPS
        for ((i=0 ;i< NUMDEPS;i++))
            do
            read DEP
            ./buildlst.sh $DEP
        done
        rm $REQTMP
fi
