#read full file and grep requires line for defp $1
CWD=$(pwd)
QFILE=$1
DEFPATH="/home/dan/git/custom_slackbuilds/dspbuilds"
FILEIN=$DEFPATH'/dspbuilds.lst'
TOTAL=0
FOUND=0
BUILDS=$(grep -c "NAME:" $FILEIN)
#echo number if builds $BUILDS
exec < $FILEIN
for ((i=0; i < BUILDS; i++)) do
        read NAME
        read LOCATION
        read FILES
        read VERSION
        read DOWNLOAD
        read DOWNLOAD_x86_64
        read MD5SUM
        read MD5SUM_x86_64
        read REQUIRES
        read SHORT
        read blank 
        #echo $TOTAL
        if [ "$REQUIRES" != "REQUIRES:" ]
            then
                #echo $REQUIRES | grep -c $QFILE
                FOUND=$(echo $REQUIRES | grep -c $QFILE)    
            if [ $FOUND -ne  0 ]
            then
                #let TOTAL=TOTAL+1
                echo $(echo $NAME | cut -d " " -f2- )
                ./newdep.sh $(echo $NAME | cut -d " " -f2- )
            fi
            
        fi
done
#echo $TOTAL :files affected
