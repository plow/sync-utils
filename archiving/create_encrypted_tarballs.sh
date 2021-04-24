#!/bin/bash

echo "CREATE ENCRYPTED TAR BALLS:"
echo "Working directory: `pwd`"

tmp_encmedia=$(mktemp -d /tmp/enc_media.XXXXXX)
echo "Output directory:  $tmp_encmedia"

dirhash=""
array=$(find . -mindepth 1 -maxdepth 1 -type d)

for dir in */ ; do 
  # matches "yyymmdd-some text"
  regexp="^(19|20)[0-9]{2}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])-.*"  
  if [[ $dir =~ $regexp ]]; then 
    dirhash=$(echo -n $dir | md5sum | head -n1 | awk '{print $1;}')
    dirprefix=$(echo $dir | sed 's/^\(.*\)-.*$/\1/')
    #tar -cf $tmp_encmedia/$dirprefix-$dirhash.tar "$dir"
    #gpg -c -a --cipher-algo AES256 filename.txt
    tar -cv "$dir" | gpg -c --symmetric --passphrase-file enc-pw.txt --batch --quiet --yes -o $tmp_encmedia/$dirprefix-$dirhash.tar.gpg
  else
    echo "WARNING: Omitting directory $dir because of invalid name."
  fi
done

#rm "$tmp_encmedia"
