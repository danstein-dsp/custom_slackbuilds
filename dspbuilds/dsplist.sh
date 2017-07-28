CWD=$(pwd)
OUTFILE="dspbuilds.lst"
rm $ITFILE.old
mv $OUTFILE $OUTFILE.old
touch $OUTFILE

for i in */*; do
   NAME=$(echo $i | cut -d "/" -f2)
   FILES=$(ls $i)
   source $i/${NAME}.info
   SHORTDES=$(grep -m 1 $NAME $i/slack-desc | cut -d " " -f2-)
   echo NAME: $NAME >> $OUTFILE
   echo LOCATION: "./"$i >> $OUTFILE
   echo FILES: $FILES >> $OUTFILE
   echo VERSION: $VERSION >> $OUTFILE
   echo DOWNLOAD: $DOWNLOAD >> $OUTFILE
   echo DOWNLOAD_x86_64: $DOWNLOAD_x86_64 >> $OUTFILE
   echo MD5SUM: $MD5SUM >> $OUTFILE
   echo MD5SUM_x86_64: $MD5SUM_x86_64 >> $OUTFILE
   echo REQUIRES: $REQUIRES >> $OUTFILE
   echo SHORT DESCRIPTION: $SHORTDES >> $OUTFILE
   echo >> $OUTFILE
done 
