#!/bin/bash

for f in *.jpg; do
    dir=`echo "$f"| awk -F '[_.]' '{print $2}'`
    # echo $dir

    #name=`echo "$f"|sed 's/ -.*//'`
    #letter=`echo "$name"|cut -c1`
    #dir="DestinationDirectory/$letter/$name"
    
    mkdir -p "$dir"
    mv "$f" "$dir"
done
