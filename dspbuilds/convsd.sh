mv $1 $1.old
sed -e s/SBo/dsp/g -e s/SlackBuild/dspbuild/g <$1.old > $1
chmod +x $1
cat $1
