#!/bin/bash
#
# Developed by Fred Weinhaus 9/9/2015 .......... revised 11/9/2021
# Modified to accept PNG files with alpha channel
#
# ------------------------------------------------------------------------------
# 
# Licensing:
# 
# Copyright © Fred Weinhaus
# 
# My scripts are available free of charge for non-commercial use, ONLY.
# 
# For use of my scripts in commercial (for-profit) environments or 
# non-free applications, please contact me (Fred Weinhaus) for 
# licensing arrangements. My email address is fmw at alink dot net.
# 
# If you: 1) redistribute, 2) incorporate any of these scripts into other 
# free applications or 3) reprogram them in another scripting language, 
# then you must contact me for permission, especially if the result might 
# be used in a commercial or for-profit environment.
# 
# My scripts are also subject, in a subordinate manner, to the ImageMagick 
# license, which can be found at: http://www.imagemagick.org/script/license.php
# 
# ------------------------------------------------------------------------------
# 
####
#
# USAGE: texteffect2 -t "some text" [-f font] [-p pointsize] [-e effect] 
# [-c colors] [-s style] [-m mirror] [-mf mirrorfade] [-sc strokecolor] 
# [-gc glowcolor] [-tf texturefile] [-lw linewidth] [-hw hardshadowwidth] 
# [-sw shadowwidth] [-gw glowwidth] [-i intensity] [-h hardness] 
# [-mg mirrorgap] [-pd pad] [-bg bgcolor] [-r rounding] [-d direction] 
# [-ct chrometype] [-rt resizetexture] [-fv fuzzvalue] [-ff fadefactor] 
# [-B brightness] [-C contrast] outfile
# 
# USAGE: texteffect2 -in input.png [-e effect] [-c colors] [-s style] 
# [-m mirror] [-mf mirrorfade] [-sc strokecolor] [-gc glowcolor] 
# [-tf texturefile] [-lw linewidth] [-hw hardshadowwidth] [-sw shadowwidth] 
# [-gw glowwidth] [-i intensity] [-h hardness] [-mg mirrorgap] [-pd pad] 
# [-bg bgcolor] [-r rounding] [-d direction] [-ct chrometype] 
# [-rt resizetexture] [-fv fuzzvalue] [-ff fadefactor] [-B brightness] 
# [-C contrast] outfile
# 
# USAGE: texteffect2 [-help]
#
# OPTIONS:
#
# -t      "some text"         text to use; enclose in double quotes
# -in     input.png           input PNG file with alpha channel
# -f      font                fontname; recommend a broad/wide font; 
#                             default=Ubuntu-Bold
# -p      pointsize           pointsize for font; integer>0; default=200; 
# -e      effect              effect for text: choices are normal, bevel and 
#                             chrome; default=normal
# -c      colors              color or colors of text; default=red
# -s      style               text style; choices are: plain, stroke, 
#                             hardshadow, shadow or glow; default=plain
# -m      mirror              mirror text; choices are: yes or no; 
#                             default=no
# -mf     mirrorfade          fade the bottom of the mirror image; choices 
#                             are yes or no; default=no
# -sc     strokecolor         stroke color; default=black			
# -gc     glowcolor           glow color; default=black
# -tf     texturefile         path to texture file; default is no texture
# -lw     linewidth           stroke line width; integer>0; default=3
# -hw     hardshadowwidth     hard shadow width; integer>0; default=5
# -sw     shadowwidth         shadow width; integer>0; default=5
# -gw     glowwidth           glow width; integer>0; default=7			
# -i      intensity           intensity of shadow and glow; 0<=integer<=100;
#                             default=50
# -h      hardness            hardness of shadow and glow; 0<=integer<=100;
#                             default=50
# -mg     mirrorgap           gap between mirror top and bottom; integer>=0;
#                             default=0
# -pd     pad                 pad of output; integer>=0; default=0
# -bg     bgcolor             background color; default=none
# -r      rounding            rounding for bevel and chrome; default for 
#                             bevel=8; default for chrome=4
# -d      direction           direction for multi-color gradient rainbow 
#                             when colors is more than one color; choices 
#                             are: horizontal or vertical; default=horizontal
# -ct     chrometype          chrome type; choices are inner and outer; 
#                             default=inner
# -rt     resizetexture       resize the texture to fit the text area or 
#                             just crop at full resolution; choices are: 
#                             yes (for resize) or no (for just crop); 
#                             default=yes
# -fv     fuzzvalue           fuzz value as percent for trimming output; 
#                             integer>=0; default=0                            
# -ff     fadefactor          fade factor for mirror fade; 0<=float<=1; 
#                             default=0.5
# -B      brightness          brightness change for output; 
#                             -100<=integer<=100; default=0
# -C      contrast            contrast change for output; 
#                             -100<=integer<=100; default=0
# 
###
#
# NAME: TEXTEFFECT2
# 
# PURPOSE: To convert large size text or PNG images with alpha channel to an 
# image with color, effects and styling.
# 
# DESCRIPTION: TEXTEFFECT2 converts large size text or PNG images with alpha 
# channel to an image with color, effects and styling. Effect choices include: 
# normal, bevel and chrome. Style choices include: plain, stroke, hardshadow, 
# shadow and glow.
# 
# 
# ARGUMENTS: 
# 
# -t "some text" ... The text to use. Be sure to enclose it in double quotes.
# -in input.png ... The input PNG file with alpha channel.
#
# -f font ... FONT is the desired font for the text. Recommend using a broad 
# (wide) font. The default=Ubuntu-Bold.
#
# -p pointsize ... POINTSIZE is the desired pointsize for the font. The output 
# image will be generated to the size consistent with this pointsize (apart 
# from any padding added). The default is 200.
# 
# -e effect ... EFFECT is the effect for the text or image. The choices are: 
# normal, bevel or chrome. The default=normal.
#  
# -c colors ... COLOR(S) to apply to the text or image. Any single or list of 
# colors may be used. If more than one color is provide, a gradient or rainbow 
# style will be applied to the text or image. Multiple colors take precedent 
# over a textfile. The default is skyblue. See http://imagemagick.org/script/color.php 
# for color definition.
#
# -s style ... STYLE is the style applied to the text or image. The choices are: 
# plain, stroke, hardshadow, shadow or glow. The default=plain.
#
# -m mirror ... MIRROR applies a mirror style to the text or image. The choices 
# are: yes or no. The default=no.
# 
# -mf mirrorfade ... MIRRORFADE fades the bottom of the mirror image. The 
# choices are yes or no. The default=no.
# 
# -sc strokecolor ... STROKECOLOR is the stroke color. The default=black.
# 			
# -gc glowcolor ... GLOWCOLOR is the glow color. The default=black.
# 
# -tf texturefile ... TEXTUREFILE is the path to a texture file that will be 
# applied to the text or image. The default is no texture file.  Multiple colors 
# take precedent over a texture file. A texture file take precedent over a 
# single color.
# 
# -lw linewidth ... LINEWIDTH is the outline stroke thickness in pixels. 
# Values are integers greater than 0. The default=3.
# 
# -hw hardshadowwidth ... HARDSHADOWWIDTH is the hardshadow thickness in pixels. 
# Values are integers greater than 0. The default=5. Hardshadow color is black.
# 
# -sw shadowwidth ... SHADOWWIDTH is the (soft) shadow thickness in pixels. 
# Values are integers greater than 0. The default=5. Shadow color is black.
# 
# -gw glowwidth ... GLOWWIDTH is the glow thickness in pixels. 
# Values are integers greater than 0. The default=5.
# 
# -i intensity ... INTENSITY is the intensity of the shadow or glow. Values 
# are 0<=integers<=100. The default=50
# 
# -h hardness ... HARDNESS is the hardness (darkness) of the shadow or glow. 
# Values are 0<=integesr<=100. The default=50.
# 
# -mg mirrorgap ... MIRRORGAP is the gap between the mirror top and bottom. 
# Values are integers>=0. The default=0
# 
# -pd pad PAD is the padding of the output. Values are integers>=0. The 
# default=0.
# 
# -bg bgcolor ... BGCOLOR is the background color. The default=none 
# (transparent).
# 
# -r rounding ... ROUNDING is the rounding applied for the bevel and chrome 
# effects. Values are integers>0. The default for bevel=8 and the default 
# for chrome=4.
# 
# -d direction ... DIRECTION is the direction for the multi-color gradient or 
# rainbow when colors is more than one color. The choices are: horizontal or 
# vertical. The default=horizontal.
# 
# -ct chrometype ... CHROMETYPE is the chrome type. The choices are: inner or 
# outer. The default=inner.
# 
# -rt resizetexture ... RESIZETEXTURE is the the chhoice to either resize the 
# texture to fit the text area or just crop the center of the texture at full 
# resolution. The choices are: yes (for resize) or no (for just crop). The 
# default=yes (resize texturefile). 
# 
# -fv fuzzvalue ... FUZZVALUE is the fuzz value expressed as percent value 
# (without the % symbol) for trimming of the output. Values are 
# 0<=integers<=100. The default=0.
# 
# -ff fadefactor ... FADEFACTOR is the fade factor for the mirror fade. 
# Values are 0<=floats<=1. The default=0.5. Smaller values make more of the 
# text transparent and so fade faster. A value of 1 produces a linear fade 
# from the top of the mirror section to its bottom.
# 
# -B brightness	... BRIGHTNESS is the brightness change for the output. 
# Values are -100<=integers<=100. The default=0.
# 
# -C contrast ... CONTRAST is the contrast change for the output. Values are 
# -100<=integers<=100. The default=0.
# 
# CAVEAT: No guarantee that this script will work on all platforms, 
# nor that trapping of inconsistent parameters is complete and 
# foolproof. Use At Your Own Risk. 
# 
######
#

# set default values
text=""
inputfile=""
effect="normal"
colors="red"
style="plain"
mirror="no"
mirrorfade="no"
strokecolor="black"
glowcolor="black"
texturefile=""
font="Ubuntu-Bold"
pointsize=200
linewidth=3
glowwidth=7
shadowwidth=5
hardshadowwidth=5
intensity=50
hardness=50
mirrorgap=0
pad=0
bgcolor="none"
rounding=""
direction="horizontal"
chrometype="inner"
resizetexture="yes"
fuzzvalue=0
fadefactor=0.5
brightness=0
contrast=0

# internal arguments
hardshadowcolor="black"
shadowcolor="black"
azimuth=135
elevation=30

# set directory for temporary files
dir="."    # suggestions are dir="." or dir="/tmp"

# set up functions to report Usage and Usage with Description
PROGNAME=`type $0 | awk '{print $3}'`  # search for executable on path
PROGDIR=`dirname $PROGNAME`            # extract directory of program
PROGNAME=`basename $PROGNAME`          # base name of program
usage1() 
	{
	echo >&2 ""
	echo >&2 "$PROGNAME:" "$@"
	sed >&2 -e '1,/^####/d;  /^###/g;  /^#/!q;  s/^#//;  s/^ //;  4,$p' "$PROGDIR/$PROGNAME"
	}
usage2() 
	{
	echo >&2 ""
	echo >&2 "$PROGNAME:" "$@"
	sed >&2 -e '1,/^####/d;  /^######/g;  /^#/!q;  s/^#*//;  s/^ //;  4,$p' "$PROGDIR/$PROGNAME"
	}


# function to report error messages
errMsg()
	{
	echo ""
	echo $1
	echo ""
	usage1
	exit 1
	}


# function to test for minus at start of value of second part of option 1 or 2
checkMinus()
	{
	test=`echo "$1" | grep -c '^-.*$'`   # returns 1 if match; 0 otherwise
    [ $test -eq 1 ] && errMsg "$errorMsg"
	}

# test for correct number of arguments and get values
if [ $# -eq 0 ]
	then
	# help information
   echo ""
   usage2
   exit 0
elif [ $# -gt 57 ]
	then
	errMsg "--- TOO MANY ARGUMENTS WERE PROVIDED ---"
else
	while [ $# -gt 0 ]
		do
			# get parameter values
			case "$1" in
		  	 -help)    # help information
					   echo ""
					   usage2
					   exit 0
					   ;;
				-t)    # get  text
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID TEXT SPECIFICATION ---"
					   #checkMinus "$1"
					   text="$1"
					   ;;
				-in)   # get input PNG file
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID INPUT FILE SPECIFICATION ---"
					   checkMinus "$1"
					   inputfile="$1"
					   ;;
				-f)    # get  font
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID FONT SPECIFICATION ---"
					   checkMinus "$1"
					   font="$1"
					   ;;
				-p)    # get pointsize
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID POINTSIZE SPECIFICATION ---"
					   checkMinus "$1"
					   point=`expr "$1" : '\([0-9]*\)'`
					   [ "$point" = "" ] && errMsg "--- POINTSIZE=$point MUST BE A NON-NEGATIVE INTEGER ---"
					   test=`echo "$point < 0" | bc`
					   [ $test -eq 1 ] && errMsg "--- POINTSIZE=$point MUST BE A POSITIVE INTEGER ---"
					   ;;
				-e)    # get  effect
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID EFFECT SPECIFICATION ---"
					   checkMinus "$1"
					   effect=`echo "$1" | tr "[:upper:]" "[:lower:]"`
					   case "$1" in 
					   		normal) ;;
					   		bevel) ;;
					   		chrome) ;;
					   		*) errMsg "--- EFFECT=$effect IS AN INVALID VALUE ---" 
					   	esac
					   ;;
				-c)    # get colors
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID COLOR(S) SPECIFICATION ---"
					   checkMinus "$1"
					   colors="$1"
					   ;;
				-s)    # get  style
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID STYLE SPECIFICATION ---"
					   checkMinus "$1"
					   style=`echo "$1" | tr "[:upper:]" "[:lower:]"`
					   case "$1" in 
					   		plain) ;;
					   		stroke) ;;
					   		hardshadow) ;;
					   		shadow) ;;
					   		glow) ;;
					   		*) errMsg "--- STYLE=$style IS AN INVALID VALUE ---" 
					   	esac
					   ;;
				-m)    # get  mirror
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID MIRROR SPECIFICATION ---"
					   checkMinus "$1"
					   mirror=`echo "$1" | tr "[:upper:]" "[:lower:]"`
					   case "$1" in 
					   		yes) ;;
					   		no) ;;
					   		*) errMsg "--- MIRROR=$mirror IS AN INVALID VALUE ---" 
					   	esac
					   ;;
				-mf)   # get  mirrorfade
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID MIRRORFADE SPECIFICATION ---"
					   checkMinus "$1"
					   mirrorfade=`echo "$1" | tr "[:upper:]" "[:lower:]"`
					   case "$1" in 
					   		yes) ;;
					   		no) ;;
					   		*) errMsg "--- MIRRORFADE=$mirrorfade IS AN INVALID VALUE ---" 
					   	esac
					   ;;
				-sc)   # get strokecolor
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID STROKECOLOR SPECIFICATION ---"
					   checkMinus "$1"
					   strokecolor="$1"
					   ;;
				-gc)   # get glowcolor
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID GLOWCOLOR SPECIFICATION ---"
					   checkMinus "$1"
					   glowcolor="$1"
					   ;;
				-tf)   # get texturefile
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID TEXTUREFILE SPECIFICATION ---"
					   checkMinus "$1"
					   texturefile="$1"
					   ;;
				-lw)   # get linewidth
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID LINEWIDTH SPECIFICATION ---"
					   checkMinus "$1"
					   linewidth=`expr "$1" : '\([0-9]*\)'`
					   [ "$linewidth" = "" ] && errMsg "--- LINEWIDTH=$linewidth MUST BE A NON-NEGATIVE INTEGER ---"
					   test=`echo "$linewidth <= 0" | bc`
					   [ $test -eq 1 ] && errMsg "--- LINEWIDTH=$linewidth MUST BE AN INTEGER GREATER THAN 0 ---"
					   ;;
				-hw)   # get hardshadowwidth
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID HARDSHADOWWIDTH SPECIFICATION ---"
					   checkMinus "$1"
					   hardshadowwidth=`expr "$1" : '\([0-9]*\)'`
					   [ "$hardshadowwidth" = "" ] && errMsg "--- HARDSHADOWWIDTH=$hardshadowwidth MUST BE A NON-NEGATIVE INTEGER ---"
					   test=`echo "$hardshadowwidth <= 0" | bc`
					   [ $test -eq 1 ] && errMsg "--- HARDSHADOWWIDTH=$hardshadowwidth MUST BE AN INTEGER GREATER THAN 0 ---"
					   ;;
				-sw)   # get shadowwidth
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID SHADOWWIDTH SPECIFICATION ---"
					   checkMinus "$1"
					   shadowwidth=`expr "$1" : '\([0-9]*\)'`
					   [ "$shadowwidth" = "" ] && errMsg "--- SHADOWWIDTH=$shadowwidth MUST BE A NON-NEGATIVE INTEGER ---"
					   test=`echo "$shadowwidth <= 0" | bc`
					   [ $test -eq 1 ] && errMsg "--- SHADOWWIDTH=$shadowwidth MUST BE AN INTEGER GREATER THAN 0 ---"
					   ;;
				-gw)   # get glowwidth
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID GLOWWIDTH SPECIFICATION ---"
					   checkMinus "$1"
					   glowwidth=`expr "$1" : '\([0-9]*\)'`
					   [ "$glowwidth" = "" ] && errMsg "--- GLOWWIDTH=$glowwidth MUST BE A NON-NEGATIVE INTEGER ---"
					   test=`echo "$glowwidth <= 0" | bc`
					   [ $test -eq 1 ] && errMsg "--- GLOWWIDTH=$glowwidth MUST BE AN INTEGER GREATER THAN 0 ---"
					   ;;
				-i)    # get intensity
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID INTENSITY SPECIFICATION ---"
					   checkMinus "$1"
					   intensity=`expr "$1" : '\([0-9]*\)'`
					   [ "$intensity" = "" ] && errMsg "--- INTENSITY=$intensity MUST BE A NUMBER ---"
					   testA=`echo "$intensity < 0" | bc`
					   testB=`echo "$intensity > 100" | bc`
					   [ $testA -eq 1 -o $testB -eq 1 ] && errMsg "--- INTENSITY=$intensity MUST BE AN INTEGER BETWEEN 0 AND 100 ---"
					   ;;
				-h)    # get hardness
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID HARDNESS SPECIFICATION ---"
					   checkMinus "$1"
					   hardness=`expr "$1" : '\([0-9]*\)'`
					   [ "$hardness" = "" ] && errMsg "--- HARDNESS=$hardness MUST BE A NUMBER ---"
					   testA=`echo "$hardness < 0" | bc`
					   testB=`echo "$hardness > 100" | bc`
					   [ $testA -eq 1 -o $testB -eq 1 ] && errMsg "--- HARDNESS=$hardness MUST BE AN INTEGER BETWEEN 0 AND 100 ---"
					   ;;
				-mg)   # get mirrorgap
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID MIRRORGAP SPECIFICATION ---"
					   checkMinus "$1"
					   mirrorgap=`expr "$1" : '\([0-9]*\)'`
					   [ "$mirrorgap" = "" ] && errMsg "--- MIRRORGAP=$mirrorgap MUST BE A NON-NEGATIVE NUMBER ---"
					   ;;
				-pd)   # get pad
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID PAD SPECIFICATION ---"
					   checkMinus "$1"
					   pad=`expr "$1" : '\([0-9]*\)'`
					   [ "$pad" = "" ] && errMsg "--- PAD=$mirrorgap MUST BE A NON-NEGATIVE NUMBER ---"
					   ;;
				-bg)   # get bgcolor
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID BGCOLOR SPECIFICATION ---"
					   checkMinus "$1"
					   bgcolor="$1"
					   ;;
				-r)    # get rounding
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID ROUNDING SPECIFICATION ---"
					   checkMinus "$1"
					   rounding=`expr "$1" : '\([0-9]*\)'`
					   [ "$rounding" = "" ] && errMsg "--- ROUNDING=$rounding MUST BE A NON-NEGATIVE INTEGER ---"
					   test=`echo "$rounding < 0" | bc`
					   [ $test -eq 1 ] && errMsg "--- ROUNDING=$rounding MUST BE A POSITIVE INTEGER ---"
					   ;;
				-d)   # get  direction
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID DIRECTION SPECIFICATION ---"
					   checkMinus "$1"
					   direction=`echo "$1" | tr "[:upper:]" "[:lower:]"`
					   case "$1" in 
					   		horizontal) ;;
					   		vertical) ;;
					   		*) errMsg "--- DIRECTION=$direction IS AN INVALID VALUE ---" 
					   	esac
					   ;;
				-ct)   # get  chrometype
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID CHROMETYPE SPECIFICATION ---"
					   checkMinus "$1"
					   chrometype=`echo "$1" | tr "[:upper:]" "[:lower:]"`
					   case "$1" in 
					   		inner) ;;
					   		outer) ;;
					   		*) errMsg "--- CHROMETYPE=$chrometype IS AN INVALID VALUE ---" 
					   	esac
					   ;;
				-rt)   # get  resizetexture
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID RESIZETEXTURE SPECIFICATION ---"
					   checkMinus "$1"
					   resizetexture=`echo "$1" | tr "[:upper:]" "[:lower:]"`
					   case "$1" in 
					   		yes) ;;
					   		no) ;;
					   		*) errMsg "--- RESIZETEXTURE=$resizetexture IS AN INVALID VALUE ---" 
					   	esac
					   ;;
				-fv)   # get fuzzvalue
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID FUZZVALUE SPECIFICATION ---"
					   checkMinus "$1"
					   fuzzvalue=`expr "$1" : '\([0-9]*\)'`
					   [ "$fuzzvalue" = "" ] && errMsg "--- FUZZVALUE=$fuzzvalue MUST BE AN INTEGER NUMBER ---"
					   testA=`echo "$fuzzvalue < 0" | bc`
					   testB=`echo "$fuzzvalue > 100" | bc`
					   [ $testA -eq 1 -o $testB -eq 1 ] && errMsg "--- FUZZVALUE=$fuzzvalue MUST BE AN INTEGER BETWEEN 0 AND 100 ---"
					   ;;
				-ff)   # get fadefactor
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID FADEFACTOR SPECIFICATION ---"
					   checkMinus "$1"
					   fadefactor=`expr "$1" : '\([.0-9]*\)'`
					   [ "$fadefactor" = "" ] && errMsg "--- FADEFACTOR=$fadefactor MUST BE A NUMBER ---"
					   testA=`echo "$fadefactor < 0" | bc`
					   testB=`echo "$fadefactor > 1" | bc`
					   [ $testA -eq 1 -o $testB -eq 1 ] && errMsg "--- FADEFACTOR=$fadefactor MUST BE A FLOAT BETWEEN 0 AND 1 ---"
					   ;;
				-B)    # get brightness
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID BRIGHTNESS SPECIFICATION ---"
					   checkMinus "$1"
					   brightness=`expr "$1" : '\([0-9]*\)'`
					   [ "$brightness" = "" ] && errMsg "--- BRIGHTNESS=$brightness MUST BE AN INTEGER NUMBER ---"
					   testA=`echo "$brightness < 0" | bc`
					   testB=`echo "$brightness > 100" | bc`
					   [ $testA -eq 1 -o $testB -eq 1 ] && errMsg "--- BRIGHTNESS=$brightness MUST BE AN INTEGER BETWEEN 0 AND 100 ---"
					   ;;
				-C)    # get contrast
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID CONTRAST SPECIFICATION ---"
					   checkMinus "$1"
					   contrast=`expr "$1" : '\([0-9]*\)'`
					   [ "$contrast" = "" ] && errMsg "--- CONTRAST=$contrast MUST BE AN INTEGER NUMBER ---"
					   testA=`echo "$contrast < 0" | bc`
					   testB=`echo "$contrast > 100" | bc`
					   [ $testA -eq 1 -o $testB -eq 1 ] && errMsg "--- CONTRAST=$contrast MUST BE AN INTEGER BETWEEN 0 AND 100 ---"
					   ;;
				 -)    # STDIN and end of arguments
					   break
					   ;;
				-*)    # any other - argument
					   errMsg "--- UNKNOWN OPTION ---"
					   ;;
		     	 *)    # end of arguments
					   break
					   ;;
			esac
			shift   # next option
	done
	#
	# get outfile
	outfile="$1"
fi

# test that text or input file supplied
[ "$text" = "" -a "$inputfile" = "" ] && errMsg "--- NO TEXT OR INPUT FILE SUPPLIED ---"

# test that outfile provided
[ "$outfile" = "" ] && errMsg "NO OUTPUT FILE SPECIFIED"

# NOTE: resulting images are a few pixels different in size from the examples 
# made earlier from test script, probably due to inconsistent fuzz default value.

tmpT1="$dir/texteffect2_T_$$.mpc"
tmpT2="$dir/texteffect2_T_$$.cache"
tmpL1="$dir/texteffect2_L_$$.mpc"
tmpL2="$dir/texteffect2_L_$$.cache"
tmpA1="$dir/texteffect2_A_$$.mpc"
tmpA2="$dir/texteffect2_A_$$.cache"
trap "rm -f $tmpT1 $tmpT2 $tmpL1 $tmpL2 $tmpA1 $tmpA2;" 0
trap "rm -f $tmpT1 $tmpT2 tmpL1 $tmpL2 $tmpA1 $tmpA2; exit 1" 1 2 3 15
trap "rm -f $tmpT1 $tmpT2 tmpL1 $tmpL2 $tmpA1 $tmpA2; exit 1" ERR


if [ "$texturefile" != "" ]; then
	#test to be sure it is valid
	convert -quiet "$texturefile" +repage "$tmpT1" ||
		errMsg "--- FILE $texturefile DOES NOT EXIST OR IS NOT AN ORDINARY FILE, NOT READABLE OR HAS ZERO size  ---"
fi

 
# set up style color and style width
if [ "$style" = "plain" ]; then
	ecolor="none"
	ewidth=""
elif [ "$style" = "stroke" ]; then
	ecolor="$strokecolor"
	ewidth="$linewidth"
elif [ "$style" = "glow" ]; then
	ecolor="$glowcolor"
	ewidth="$glowwidth"
elif [ "$style" = "hardshadow" ]; then
	ecolor="$hardshadowcolor"
	ewidth="$hardshadowwidth"
elif [ "$style" = "shadow" ]; then
	ecolor="$shadowcolor"
	ewidth="$shadowwidth"
fi

# set up default for rounding
if [ "$rounding" = "" -a "$effect" = "bevel" ]; then
	rounding=8
elif [ "$rounding" = "" -a "$effect" = "chrome" ]; then
	rounding=4
fi

# setup lut for direction image -- direction takes precedence over texture
colorArr=($colors)
cnum=${#colorArr[*]}
if [ $cnum -gt 1 ]; then
	colorvals=""
	for ((i=0; i<cnum; i++)); do
	colorvals="$colorvals xc:${colorArr[i]}"
	done
	convert -size 1x1 $colorvals +append $tmpL1
	colors="${colorArr[0]}"
fi

 
# trap for effect=chrome and cnum>1
if [ "$effect" = "chrome" -a $cnum -gt 1 ]; then
	errMsg "--- CHROME ONLY ALLOWS ONE COLOR ---"
fi

# trap for effect=chrome and cnum>1
if [ "$effect" = "chrome" -a "$texturefile" != "" ]; then
	errMsg "--- CHROME DOES NOT ALLOW TEXTURE ---"
fi


# setup glowcolor
if [ "$glowcolor" = "" ]; then
	glowcolor="${colorArr[0]}"
fi


# compute buffer
buff=`convert xc: -format "%[fx:round(3*($strokewidth+$glowamt+$shadowamt+$hardshadowamt)/2)]" info:`


# text size setup
if [ "$text" != "" ]; then
	size=`convert -background none -font "$font" -pointsize $pointsize -gravity west -fill $colors label:"$text" \
		-bordercolor none -border ${buff} -format "%wx%h" info:`
	ww=`echo "$size" | cut -d\x -f1`
	hh=`echo "$size" | cut -d\x -f2`
elif [ "$inputfile" != "" ]; then
	size=`convert -ping "$inputfile" -format "%wx%h" info:`
	ww=`echo "$size" | cut -d\x -f1`
	hh=`echo "$size" | cut -d\x -f2`
fi

# texture setup
if [ "$texturefile" = "" ]; then
	colors="${colorArr[0]}"
	backgroundcolor="none"
	textureproc1=""
	textureproc2=""
elif [ "$texturefile" != "" ]; then
	colors=white
	backgroundcolor=black
	if [ $cnum -eq 1 ]; then
		if [ "$resizetexture" = "no" ]; then
			convert $tmpT1 +repage -resize ${size}\<\^ $tmpT1
		elif [ "$resizetexture" = "yes" ]; then
			convert $tmpT1 +repage -resize ${size}\^ $tmpT1
		fi
	fi
	textureproc1="$tmpT1 -gravity center -crop $size+0+0 +repage"
	textureproc2="+swap -alpha off -compose copy_opacity -composite -compose over"
fi
if [ $cnum -gt 1 ]; then
	colors=white
	backgroundcolor=black
	if [ "$direction" = "vertical" ]; then
		size1=$size
		rotation=""
	elif [ "$direction" = "horizontal" ]; then
		size1="${hh}x${ww}"
		rotation="-rotate 90"
	fi
	textureproc1="-size $size1 gradient: $rotation $tmpL1 -interpolate spline -clut"
	textureproc2="+swap -alpha off -compose copy_opacity -composite -compose over"
fi


# effects setup
strokeproc1=""
strokeproc2=""
hardshadowproc1=""
hardshadowproc2=""
glowproc1=""
glowproc2=""
shadowproc1=""
shadowproc2=""

if [ "$style" = "plain" ]; then
	offsets="+0+0"
fi
if [ "$style" = "stroke" ]; then
	strokewidth=`convert xc: -format "%[fx:($linewidth+0.5)/3]" info:`
	strokewidth2=`convert xc: -format "%[fx:5*$strokewidth]" info:`
	strokeproc0="-channel A -level 50x100% +channel"
	strokeproc1="+clone -channel rgb -fill $strokecolor -colorize 100% +channel -channel A -morphology dilate disk:$strokewidth2 +channel"
	strokeproc2="+swap -background none -compose over -layers merge +repage -channel a -morphology erode diamond:1 -blur 0x1 -level 50x100% +channel "
	offsets=+0+0
fi
if [ "$style" = "hardshadow" ]; then
	hardshadowvals="100x0+${hardshadowwidth}+${hardshadowwidth}"
	hardshadowproc0="-channel A -level 50x100% +channel"
	hardshadowproc1="+clone -background $hardshadowcolor -shadow $hardshadowvals"
	hardshadowproc2="+swap -background none -compose over -layers merge +repage"
	offsets="+0+0"
fi
if [ "$style" = "glow" ]; then
	glowvals="${intensity}x${glowwidth}+0+0"
	hardness=$((100-hardness))
	glowproc0="-channel A -level 50x100% +channel"
	glowproc1="+clone -background $glowcolor -shadow $glowvals -channel A -level 0x$hardness% +channel"
	glowproc2="+swap -background none -compose over -layers merge +repage"
	offset=$((2*glowwidth))
	offsets="+${offset}+${offset}"
fi
if [ "$style" = "shadow" ]; then
	shadowvals="${intensity}x${shadowwidth}+${shadowwidth}+${shadowwidth}"
	hardness=$((100-hardness))
	shadowproc0="-channel A -level 50x100% +channel"
	shadowproc1="+clone -background $shadowcolor -shadow $shadowvals -channel A -level 0x$hardness% +channel"
	shadowproc2="+swap -background none -compose over -layers merge +repage"
	offsets="+${shadowwidth}+${shadowwidth}"
fi


# do processing
if [ "$text" != "" ]; then
	if [ "$effect" = "normal" ]; then 
		eval 'convert -background none -size $size -font "$font" \
			-pointsize $pointsize -fill $colors -gravity west label:"$text" \
			\( $textureproc1 \) $textureproc2 \
			-brightness-contrast $brightness,$contrast \
			\( $strokeproc1 \) $strokeproc2 \
			\( $hardshadowproc1 \) $hardshadowproc2 \
			\( $glowproc1 \) $glowproc2 \
			\( $shadowproc1 \) $shadowproc2 \
			-fuzz $fuzzvalue% -trim +repage \
			$tmpA1'
			
	elif [ "$effect" = "bevel" ]; then 
		eval 'convert -background none -size $size -font "$font" \
			-pointsize $pointsize -fill $colors -gravity west label:"$text" \
			\( $textureproc1 \) $textureproc2 \
			\( +clone -alpha Extract -write mpr:alpha -blur 0x$rounding -shade ${azimuth}x${elevation} \
				mpr:alpha -compose over -compose copy_opacity -composite \
				-alpha deactivate -auto-level -function polynomial 3.5,-5.05,2.05,0.25 -brightness-contrast $brightness,$contrast -alpha on \) \
			-compose Hardlight -composite -write mpr:bevel \
			\( $strokeproc1 \) $strokeproc2 \
			\( $hardshadowproc1 \) $hardshadowproc2 \
			\( $glowproc1 \) $glowproc2 \
			\( $shadowproc1 \) $shadowproc2 \
			\( mpr:bevel -set page $offsets \) -compose over -layers merge +repage \
			-fuzz $fuzzvalue% -trim +repage \
			$tmpA1'

	elif [ "$effect" = "chrome" ]; then
		# set up metallic lut
		if [ "$chrometype" = "inner" ]; then
			solarizing=""
		elif [ "$chrometype" = "outer" ]; then
			solarizing="-solarize 50% -level 0x50%"
		fi
		convert \( -size 1x256 gradient: $solarizing -function Sinusoid 2.25,0,0.5,0.5 \) \
		\( gradient:"$colors-black" \) +swap -compose Overlay -composite -rotate 90 $tmpL1

		# NOTE: used +duplicate and -compose copy_opacity, since -alpha copy had a bug before IM 6.9.2.1
		
		eval 'convert -background none -size $size -font "$font" \
			-pointsize $pointsize -fill $colors -gravity west label:"$text" \
			-channel A -level 40%,60% +channel -blur 0x$rounding \
			-alpha extract +duplicate -alpha off -compose copy_opacity -composite \
			-alpha deactivate -shade ${azimuth}x${elevation} -auto-level -alpha on \
			-channel A -level 0%x30% +channel \
			-alpha deactivate $tmpL1 -clut -brightness-contrast $brightness,$contrast -alpha on \
			$strokeproc0 \( $strokeproc1 \) $strokeproc2 \
			$hardshadowproc0 \( $hardshadowproc1 \) $hardshadowproc2 \
			$glowproc0 \( $glowproc1 \) $glowproc2 \
			$shadowproc0 \( $shadowproc1 \) $shadowproc2 \
			-compose over -layers merge +repage \
			-fuzz $fuzzvalue% -trim +repage \
			$tmpA1'
	fi
elif [ "$inputfile" != "" ]; then
	if [ "$effect" = "normal" ]; then 
		eval 'convert "$inputfile" \
			\( $textureproc1 \) $textureproc2 \
			-brightness-contrast $brightness,$contrast \
			\( $strokeproc1 \) $strokeproc2 \
			\( $hardshadowproc1 \) $hardshadowproc2 \
			\( $glowproc1 \) $glowproc2 \
			\( $shadowproc1 \) $shadowproc2 \
			-fuzz $fuzzvalue% -trim +repage \
			$tmpA1'
			
	elif [ "$effect" = "bevel" ]; then 
		eval 'convert "$inputfile" \
			\( $textureproc1 \) $textureproc2 \
			\( +clone -alpha Extract -write mpr:alpha -blur 0x$rounding -shade ${azimuth}x${elevation} \
				mpr:alpha -compose over -compose copy_opacity -composite \
				-alpha deactivate -auto-level -function polynomial 3.5,-5.05,2.05,0.25 -brightness-contrast $brightness,$contrast -alpha on \) \
			-compose Hardlight -composite -write mpr:bevel \
			\( $strokeproc1 \) $strokeproc2 \
			\( $hardshadowproc1 \) $hardshadowproc2 \
			\( $glowproc1 \) $glowproc2 \
			\( $shadowproc1 \) $shadowproc2 \
			\( mpr:bevel -set page $offsets \) -compose over -layers merge +repage \
			-fuzz $fuzzvalue% -trim +repage \
			$tmpA1'

	elif [ "$effect" = "chrome" ]; then
		# set up metallic lut
		if [ "$chrometype" = "inner" ]; then
			solarizing=""
		elif [ "$chrometype" = "outer" ]; then
			solarizing="-solarize 50% -level 0x50%"
		fi
		convert \( -size 1x256 gradient: $solarizing -function Sinusoid 2.25,0,0.5,0.5 \) \
		\( gradient:"$colors-black" \) +swap -compose Overlay -composite -rotate 90 $tmpL1

		# NOTE: used +duplicate and -compose copy_opacity, since -alpha copy had a bug before IM 6.9.2.1
		
		eval 'convert "$inputfile" \
			-channel A -level 40%,60% +channel -blur 0x$rounding \
			-alpha extract +duplicate -alpha off -compose copy_opacity -composite \
			-alpha deactivate -shade ${azimuth}x${elevation} -auto-level -alpha on \
			-channel A -level 0%x30% +channel \
			-alpha deactivate $tmpL1 -clut -brightness-contrast $brightness,$contrast -alpha on \
			$strokeproc0 \( $strokeproc1 \) $strokeproc2 \
			$hardshadowproc0 \( $hardshadowproc1 \) $hardshadowproc2 \
			$glowproc0 \( $glowproc1 \) $glowproc2 \
			$shadowproc0 \( $shadowproc1 \) $shadowproc2 \
			-compose over -layers merge +repage \
			-fuzz $fuzzvalue% -trim +repage \
			$tmpA1'
	fi
fi


if [ "$mirror" = "yes" ]; then
	if [ "$mirrorfade" = "yes" ]; then
		fadecolor="black"
	elif [ "$mirrorfade" = "no" ]; then
		fadecolor="white"
	fi
	if [ "$mirrorgap" = "0" ]; then
		gapproc1=""
		gapproc2=""
	else
		wd=`convert -ping $tmpA1 -format "%w" info:`
		gapcolor="none"
		gapproc1="-size ${wd}x${mirrorgap} xc:$gapcolor"
		gapproc2="+swap"
	fi
fi


if [ "$mirror" = "yes" ]; then
	convert $tmpA1 \
		\( -clone 0 -flip \) \
		\( -clone 1 -alpha extract \) \
		\( -clone 1 -alpha off -sparse-color Barycentric "0,0 white  0,%[fx:h-1] $fadecolor" -evaluate multiply $fadefactor \) \
		\( -clone 3 -clone 2 -compose multiply -composite \) \
		-delete 2,3 \
		\( -clone 1 -clone 2 -alpha off -compose over -compose copy_opacity -composite \) \
		-delete 1,2 \
		\( $gapproc1 \) $gapproc2 \
		-append \
		-background $bgcolor -compose over -flatten \
		-gravity center -bordercolor $bgcolor -border $pad \
		"$outfile"
else
	convert $tmpA1 \
	-background $bgcolor -flatten \
	-gravity center -bordercolor $bgcolor -border $pad \
	"$outfile"
fi

exit 0