NAME=$1
DEFPATH="/home/dan/git/custom_slackbuilds/dspbuilds"
FILEIN=$DEFPATH'/dspbuilds.txt'
TMPFILE='/tmp/dsp.tmp'
CWD=$(pwd)
WKGPATH=$CWD'/temp/'
cat $NAME | awk '{l[lines++] =$0}
                    END {
                        for ( i= lines -1; i >=0 ; i--) 
                            if (length(l[i])>1){print l[i]}
                        }'

#>$REQTMP
#echo $NAME
#if [ -e $REQTMP ]
#3    then
#3        exec < $REQTMP
#        read NUMDEPS
#        for ((i=0 ;i< NUMDEPS;i++))
#            do
#3            read DEP
#            ./buildlst.sh $DEP
#        done
#        rm $REQTMP
#fi
