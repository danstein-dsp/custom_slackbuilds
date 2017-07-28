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
        if [ $(grep -c $PKG $TMP1) -gt 0 ]; then 
            echo $PKG | cut -d "/" -f2- >> $LIST2
        fi
    done
rm SBCL.old.old
mv SBCL.old SBCL.old.old
cp ~/git/slackbuilds/ChangeLog.txt SBCL.old
