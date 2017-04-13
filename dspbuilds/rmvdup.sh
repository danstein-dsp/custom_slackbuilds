NAME=$1
DEFPATH="/home/dan/git/custom_slackbuilds/dspbuilds"
FILEIN=$DEFPATH'/dspbuilds.txt'
TMPFILE='/tmp/dsp.tmp'
CWD=$(pwd)
WKGPATH=$CWD'/temp/'
cat $NAME | awk '!l[$0]++'
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
