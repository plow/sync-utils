#!/bin/bash

echo "CREATE ENCRYPTED TAR BALLS:"
dir_work=$(pwd)
dir_encmedia=$(mktemp -d -t enc_media.XXXXXX)
dir_script="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo "Working directory: $dir_work"
echo "Output directory:  $dir_encmedia"
echo "Script directory:  $dir_script"
echo "---------------------"

array=$(find . -mindepth 1 -maxdepth 1 -type d)

function create () {
  dirhash=$(echo -n $dir | md5sum | head -n1 | awk '{print $1;}')
  #tar -cf $dir_encmedia/$dirprefix-$dirhash.tar "$dir"
  #gpg -c -a --cipher-algo AES256 filename.txt
  outputfile="$dirprefix-$dirhash.tar.gpg"
  echo "Encrypting $dir -> $outputfile"
  tar -cvv "$dir" | gpg --symmetric --cipher-algo AES256 --passphrase-file $dir_script/enc-pw.txt --batch --quiet --yes -o $dir_encmedia/$outputfile
  echo -e "$dir\t$outputfile" >> $dir_encmedia/index.txt
}

for dir in */ ; do 
  # matches "yyymmdd-some text"
  regexp1="^(19|20)[0-9]{2}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])-.*"
  # matches "yyyy-mm-dd-some text"
  regexp2="^(19|20)[0-9]{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])-.*"
  if [[ $dir =~ $regexp1 ]]; then 
    dirprefix=$(echo $dir | sed 's/^\([0-9]*\)-.*$/\1/')
    create
  elif [[ $dir =~ $regexp2 ]]; then
    dirprefix=$(echo $dir | sed 's/^\([0-9]*\)-\([0-9]*\)-\([0-9]*\)-.*$/\1\2\3/')
    create
  else
    echo "WARNING: No date prefix detected for directory $dir. Prefix omitted."
    dirprefix='________'
    create
  fi
done

gpg --symmetric --cipher-algo AES256 --passphrase-file $dir_script/enc-pw.txt --batch --quiet --yes -o $dir_encmedia/hashdeep_out.txt.gpg $dir_work/hashdeep_out.txt
gpg --symmetric --cipher-algo AES256 --passphrase-file $dir_script/enc-pw.txt --batch --quiet --yes -o $dir_encmedia/index.txt.gpg $dir_encmedia/index.txt 
rm -f $dir_encmedia/index.txt

echo "---------------------"
echo "Output directory:  $dir_encmedia"

#rm "$dir_encmedia"
