OUTFILE="update.lst"
TEMP3="temp3.me"
TEMP="temp.me"
TEMP2="temp2.tmp"
rm $TEMP3
rm $TEMP2
rm $TEMP
touch $TEMP3
echo getting list
./updtdsp.sh > $TEMP
#cat $TEMP
echo rmving dups
./rmvdup.sh $TEMP > $TEMP2
#cat $TEMP2
echo --
FILELIST=()
echo reading in list
    while IFS= read -r line
        do
            FILELIST+=("$line")
    done < $TEMP2
echo doing count now
    for PKG in "${FILELIST[@]}"
        do
        echo $(grep -c $PKG $TEMP) $PKG >>$TEMP3
    done
echo  ordering list
sort -n $TEMP3 > $TEMP
cut -d " " -f2- $TEMP> $OUTFILE
echo Build list in $OUTFILE
