
#for i in */*; do
#echo $i
#NAME=$(echo $i | cut -d "/" -f2)
NAME=$1
#FILES=$(ls $i)
#source dspbuilds.txt
grep -A 9 'NAME: '$1 dspbuilds.txt | cut -d " " -f2- > tmp.tmp
exec < tmp.tmp
read  name  
read  location
read  files
read  VERSION
read  DOWNLOAD
read  DOWNLOAD_x86_64
read  MD5SUM
read  MD5SUM_x86_64
read  REQUIRES
read  SHORT

#done
echo $name
echo $location
echo $SHORT
