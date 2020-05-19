#!/bin/bash

if [ "$#" != "4" ]
then
    echo "usage: $(basename "$0") <stars> <mapper> <mapname> <type>"
    exit 1
fi

function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

STARS="$1"
MAPPER="$(urldecode "$2")"
MAPNAME="$(urldecode "$3")"
TYPE="$4"
STARS="$((STARS+1))"
cfgpath="$TYPE.cfg"
s1='★'
s2='✰'
STARSSTR=''
for((i=5;i>0;i--))
do
    if [ "$i" -gt "$STARS" ]
    then
        STARSSTR+="$s1"
    else
        STARSSTR+="$s2"
    fi
done

if [ ! -f "$cfgpath" ]
then
    echo "Error: file not found '$(pwd)/$cfgpath'"
    exit 1
fi

dos2unix "$cfgpath"
read -rd '' selectcode << EOF
\\x23 maps\\nadd_vote "$MAPNAME by $MAPPER | $STARSSTR |" change_map "$MAPNAME"
EOF
cmd="sed 's/^. maps$/$selectcode/' $cfgpath"
echo "$MAPPER - $MAPNAME - $STARSSTR"
echo "$cmd"
eval "$cmd" > tmp.cfg
mv tmp.cfg "$cfgpath"

