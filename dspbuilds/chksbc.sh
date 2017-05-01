TMP1="tmp1.txt"
TMP2="tmp2.txt"
LIST1="listofdspbuilds.txt"
LIST2="updatedsb.txt"
echo Removing Old Lists
rm $LIST2
rm $LIST1
echo Generating $LIST1
for i in */* ; do
    echo $i >> $LIST1
done   
echo getting SB Changelog
diff SBCL.old ~/git/slackbuilds/ChangeLog.txt > $TMP1
echo Extracting New Changes
FILELIST=()
while IFS= read -r line
    do
        FILELIST+=("$line")
    done < $LIST1
for PKG in "${FILELIST[@]}"
    do
        grep $PKG $TMP1 >> $LIST2
    done
 
#mv SBCL.old SBCL.old.old
#cp ~/git/slackbuilds/ChangeLog.txt SBCL.old

