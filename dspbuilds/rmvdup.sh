NAME=$1
cat $NAME | awk '!l[$0]++'
