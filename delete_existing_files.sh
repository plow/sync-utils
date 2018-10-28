#!/bin/bash

find | wc -l

# grep "^`pwd`"  --> only lines starting with current directory, i.e. hash lines and no comments
# grep -v ": No match$"  --> only lines that do not end ': No match', i.e. all files that could be matched by hash
# cut -d':' -f1  --> only the file path, i.e. the part before the first occurrence of ':'
# xargs -d '\n' -I % mv "%" ../removed_known/  --> move all known files to folder ../removed_known
cat hashdeep_audit.txt | grep "^`pwd`" | grep -v ": No match$" | cut -d':' -f1 | xargs -d '\n' -I % mv "%" ../removed_known/

find | wc -l

# delete all empty directories
find -type d -empty -delete

find | wc -l


# delete all empty files
find . -size 0 | xargs -I % mv "%" ./size-zero/

find | wc -l
