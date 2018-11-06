#!/bin/bash

# This script expects all JPGs file names in the current folder 
# to follow the pattern IMG_YYYYMMDD_HHMMSS.jpg 

for f in *.jpg; do
    dir=`echo "$f"| awk -F '[_.]' '{print $2}'`
    # echo $dir

    #name=`echo "$f"|sed 's/ -.*//'`
    #letter=`echo "$name"|cut -c1`
    #dir="DestinationDirectory/$letter/$name"
    
    mkdir -p "$dir"
    mv "$f" "$dir"
done
