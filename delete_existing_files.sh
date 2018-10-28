#!/bin/bash

# After an audit, this script moves all known files under the current directory to the ../removed_known directory.
# Thus, only unknown files remain unter the current directory.
# The removed_known directory must be created manually before running the script.

echo "Number of files at the beginning:"
find | wc -l

# grep "^`pwd`"  --> only lines starting with current directory, i.e. hash lines and no comments
# grep -v ": No match$"  --> only lines that do not end ': No match', i.e. all files that could be matched by hash
# cut -d':' -f1  --> only the file path, i.e. the part before the first occurrence of ':'
# xargs -d '\n' -I % mv "%" ../removed_known/  --> move all known files to folder ../removed_known
cat hashdeep_audit.txt | grep "^`pwd`" | grep -v ": No match$" | cut -d':' -f1 | xargs -d '\n' -I % mv "%" ../removed_known/

echo "Number of files remaining after separating the known files:"
find | wc -l

# delete all empty directories
find -type d -empty -delete

echo "Number of files after deleting empty directories:"
find | wc -l


# delete all empty files
find . -size 0 | xargs -I % mv "%" ./size-zero/

echo "Number of files after deleting all empty files:"
find | wc -l
