#!/bin/bash
# DSPBuilds Utility Script
INPUT=/tmp/menu.sh.$$
OUTPUT=/tmp/output.sh.$$
vi_editor=${EDITOR-vi}
# Location of DSP_Build_Scripts
DSPLOC="/home/dan/git/custom_slackbuilds/dspbuilds/"
#Location of DSP Packages
DSPPKGLOC="/usr/share/files/dspbuilds/"
# trap and delete temp files
trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM
CWD=$(pwd)
WKGPATH=$CWD'/temp/'
TMPFILE="/tmp/dsp1.tmp"
# Purpose - display output using msgbox $1- height $2 -width $3 - title
#
function display_output(){
	local h=${1-10}			# box height default 10
	local w=${2-41} 		# box width default 41
	local t=${3-Output} 	# box title 
    dialog --backtitle "Root Comand Menu" --title "${t}" --clear --msgbox "$(<$OUTPUT)" ${h} ${w} 
}
function display_text(){
    local h=${1-10}
    local w=${2-41}
    local t=${3-Output}
    dialog --backtitle "Root Command Menu" --title "${t}" --clear --textbox $OUTPUT ${h} ${w}
}
function display_info(){
    local h=${1-10}
    local w=${2-41}
    local bt=${3-"Searching"}
    local ti=${4-"Found"}
    dialog --backtitle "${bt}" --title "${ti}" --infobox "$(<$OUTPUT)" ${h} ${w}
}
function display_com(){
	dialog --clear --title "$1" --prgbox "$1" 30 80
	
}
function show_com(){
     display_com $1    
#	dialog --clear --progressbox 30 80 < $1
}
function view_com(){
    $1 > $OUTPUT
    local h=${3-0}
    local w=${4-0}
    display_text "${h}" "${w}" "$2"
}
function file_display(){
     cat $1 > $OUTPUT
    display_text 0 0 "$1"
}
function tail_display(){
    tail -100 $1 > $OUTPUT
    display_text 0 0 "Last 100 Lines of $1"
}
function pick_file(){
    dialog --backtitle "Pick File" --title "Choose File" \
        --fselect $1 20 70 2> "${INPUT}"
}
function mk_dsp_list(){
    file=$DSPLOC"dspbuilds.lst"
    cd $DSPLOC
    rm $file.old
    mv $file $file.old
    rm $file
    touch $file
    for i in */*; do
    NAME=$(echo $i | cut -d "/" -f2)
    FILES=$(ls $i)
    echo $NAME > $OUTPUT
    display_info 4 60 
    source $i/${NAME}.info 2> junk
        SHORTDES=$(grep -m 1 $NAME $i/slack-desc | cut -d " " -f2-)
            echo NAME: $NAME >> $file
            echo LOCATION: $i >> $file
            echo FILES: $FILES >> $file
            echo VERSION: $VERSION >> $file
            echo DOWNLOAD: $DOWNLOAD >> $file
            echo DOWNLOAD_x86_64: $DOWNLOAD_x86_64 >> $file
            echo MD5SUM: $MD5SUM >> $file
            echo D5SUM_x86_64: $MD5SUM_x86_64 >> $file
            echo REQUIRES: $REQUIRES >> $file
            echo SHORT DESCRIPTION: $SHORTDES >> $file
            echo >> $file
    done
    cd $CWD
}
function mk_dsp_sh_list(){
    file=$DSPLOC"dspshtlst.lst"
    cd $DSPLOC
    rm $file
    touch $file
    for i in */*; do
        NAME=$(echo $i | cut -d "/" -f2)
        echo $NAME > $OUTPUT
        display_info 4 60
        source $i/${NAME}.info 2>junk
            echo $NAME >> $file
    done
    sort $file > $OUTPUT
    cat $OUTPUT > $file
    cd $CWD
}
function pick_fft (){
    list=$1 
    rm $OUTPUT
    touch $OUTPUT
    while IFS= read -r line
    do
        printf "%s \" \" " $line >> $OUTPUT
    done < $list
    dialog --menu "Pick Package" 0 0 0 \
        --file $OUTPUT 2>"${INPUT}"
}
function pick_pkg (){
	list=$DSPLOC"dspshtlst.lst"
	pick_fft $list
}	
function show_build (){
    #list=$DSPLOC"dspshtlst.lst"
    #pick_fft $list
    #dialog --menu "Pick One" 0 0 0 \
    #    --file $OUTPUT 2>"${INPUT}"
    pick_pkg
    dsp_build_list "$(<"${INPUT}")"
}
function dsp_build_list(){
#make list of req to build pkg
    cd $DSPLOC
    ./buildlst.sh $1 > $OUTPUT
    make_ord $OUTPUT > $TMPFILE
    view_com "./rmvdup.sh $TMPFILE " "$1's Build List" 30 60
    cd $CWD
}
function make_ord(){
NAME=$1
cat $NAME | awk '{l[lines++] =$0}
                    END {
                        for ( i= lines -1; i >=0 ; i--) 
                            if (length(l[i])>1){print l[i]}
                        }'

}
function show_deps(){
	pick_pkg
	name="$(<"${INPUT}")"
    	./newdep.sh $name > $OUTPUT
    	display_output 0 0 $name $OUTPUT

}
function pick_build_pkg (){
	pick_pkg
	name="$(<"${INPUT}")"
	build_pkg $name
}
function build_pkg (){
    list=$DSPLOC"dspshtlst.lst"
    filein=$DSPLOC"dspbuilds.lst"
    tempfile='killme.txt'
    name=$1
    grep -A 9 'NAME: '$name $filein | cut -d " " -f2 > $tempfile    
    exec < $tempfile
    read NAME
    read LOCATION
    read FILES
    read VERSION
    read DOWNLOAD
    read DOWNLOAD_x86_64
    read REQUIRES
    read SHORT
    rm $tempfile
    if ["$(grep -c 'NAME: '$NAME $filein)" == "0" ]; then
        show_com "echo ERROR!! MISSING $NAME"
        exit 69
    fi
    mkdir $WKGPATH
    cd $WKGPATH
    cp -r $DSPLOC$LOCATION/* ./
    if [ "$DOWNLOAD_x86_64" == "DOWNLOAD_x86_64:" ]; then
        wget $DOWNLOAD
    else
        wget $DOWNLOAD_x86_64
    fi
    chmod +x $NAME.dspbuild
    show_com "./$NAME.dspbuild"
    cd $CWD
    exit
    rm -R $WKGPATH
    cp -v /tmp/$NAME*dsp.tgz $DSPPKGLOC

    }
function  install_pkg (){
	pick_pkg	
	$name= "$(<"${INPUT}")"
	ls $DSPPKGLOC$name*.dsp.tgz > $TEMPFILE
    	exec < $TMPFILE
    	read INPKG
    	rm $TMPFILE 
    	display_com "./dspinstall.sh $INPKG"
}
function rmv_pkg(){
	pick_pkg
	$name= "$(<"${INPUT}")"
	display_com "removepkg $name"
}
############ MENUS ###################

function slack_up(){
    while true
    do
        dialog --clear  --help-button --backtitle "Slackware Update" \
            --title "[U P D A T E - S Y S T E M]" \
            --menu "Choose" 0 0 0 \
            Update_GPG "Update Mirror GPG Files" \
            Update_Slackpkg "Sync Package List With Mirrors" \
            Install_New "Install New Packages" \
            Clean_System "Remove Old/Unofficial Packages" \
            Upgrade_All "Upgrade all Packages" \
            Exit "Exit To Main" 2>"${INPUT}"
        menuitem=$(<"${INPUT}")
        
        case $menuitem in
            Update_GPG) display_com "slackpkg update gpg";;
            Update_Slackpkg) display_com "slackpkg update";;
            Install_New) slackpkg install-new;;
            Clean_Syetem) slackpkg clean-system;;
            Upgrade_All) slackpkg upgrade-all;;
            Exit) break;;
        esac
    done
}
function dsp_menu(){
    while true
    do  
        dialog --clear --backtitle "DSP Package Menu" \
            --title "[D S P - M E N U]" \
            --menu "Options:" 0 0 0 \
            Pkg_List "List Packages" \
            Pkg_Short "List Package Names" \
            Make_List "Make dspbuilds.lst" \
            Make_Name_List "Make dspshtlst.lst" \
            Show_Build_List "Show Build List" \
            Show_Deps "Show What Depends on Package" \
            Build_Package "Build Package" \
            Install_Pkg "Install Package" \
	    Remove_Pkg "Remove Package" \
	    PKG_Tool "Slackware PKG TOOL" \
	    Exit "Exit Menu" 2>"${INPUT}"
        menuitem=$(<"${INPUT}")
        case $menuitem in
            Pkg_List) file_display $DSPLOC"dspbuilds.lst";;
            Pkg_Short) file_display $DSPLOC"dspshtlst.lst";;
            Make_List) mk_dsp_list;;
            Make_Name_List) mk_dsp_sh_list;;
            Show_Build_List) show_build;;
            Show_Deps) show_deps;;
            Build_Package) pick_build_pkg;;
	    Install_Pkg) install_pkg;;
	    Remove_Pkg) rmv_pkg;;
	    PKG_Tool) pkgtool;;
	    Exit) break;;
        esac
    done
}
#*******MAIN*****
dsp_menu
# if temp files found, delete em
[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT
