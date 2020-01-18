#!/bin/bash

# Merges all hashdeep_out.txt files under /mnt/photos-arch/ into a global 
# hash file created on root level.

echo "MERGING HASH FILES:"
for i in {2001..2017}
do
  cd /mnt/photos-arch/$i
  pwd
  cat hashdeep_out.txt >> ../hashdeep_out_global.txt
done

