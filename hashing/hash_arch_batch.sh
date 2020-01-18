#!/bin/bash

echo "HASHING:"
for i in {2001..2017}
do
  cd /mnt/photos-arch/$i
  pwd
  hashdeep -c md5 -v -r -l -W hashdeep_out.txt .
done

echo "AUDITING:"
for i in {2010..2017}
do
  cd /mnt/photos-arch/photos_check_existence/$i
  pwd
  hashdeep -vvv -a -r -k /mnt/photos-arch/$i/hashdeep_out.txt . > hashdeep_audit.txt 2>&1
done
