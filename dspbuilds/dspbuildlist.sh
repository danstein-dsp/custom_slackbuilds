
for i in */*; do
NAME=$(echo $i | cut -d "/" -f2)
FILES=$(ls $i)
source $i/${NAME}.info
SHORTDES=$(grep -m 1 $NAME $i/slack-desc | cut -d " " -f2-)
            echo NAME: $NAME
            echo LOCATION: $i
            echo FILES: $FILES
            echo VERSION: $VERSION
            echo DOWNLOAD: $DOWNLOAD
            echo DOWNLOAD_x86_64: $DOWNLOAD_x86_64
            echo MD5SUM: $MD5SUM
            echo D5SUM_x86_64: $MD5SUM_x86_64
            echo REQUIRES: $REQUIRES
            echo SHORT DESCRIPTION: $SHORTDES
            echo
done

