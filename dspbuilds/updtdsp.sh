TMP1="tmp1.txt"
TMP2="tmp2.txt"
LIST2="updatedsb.txt"
FILELIST=()
junk=NULL
while IFS= read -r line
    do 
        FILELIST+=("$line")
done < $LIST2
    for PKG in "${FILELIST[@]}"
    do 
        if [ "$(grep -c 'NAME: '$PKG $DSPBUILDS)" -lt 1 ]; then
            echo ERRROR MISSING PACKAGE $PKG Adding now!
            ./mvslb.sh $PKG 
            ./dspinstall $PKG 
            echo START OVER! Maybe I should Move This!
            exit 69
        fi
        echo $PKG
        ./newdep.sh $PKG 
    done
    
