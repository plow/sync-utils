#!/bin/bash  

# Audit based on file names and paths only (no hashes considered)

echo "HASH FILE VALIDATION"

sizes_fs=$( \
  find . -type f -exec du -ab {} +  `# print byte (-b) size of all (-a) files` \
  | grep -v hashdeep_out.txt        `# consider all files BUT hashdeep_out.txt, which must not be part of the comparison` \
  | awk '{print $1}'                `# only first colum containing the file size` \
  | paste -sd+ - | bc               `# sum up the file sizes` \
  )
echo "Sum of file sizes according to file system:      $sizes_fs"

sizes_file=$( \
  tail -n+6 hashdeep_out.txt   `# ommit header in hashdeep_out` \
  | grep -v hashdeep_out.txt   `# consider all files BUT hashdeep_out.txt, which must not be part of the comparison` \
  | awk -F ',' '{print $1}'    `# only first colum containing the file size` \
  | paste -sd+ - | bc          `# sum up the file sizes` \
  )
echo "Sum of file sizes according to hashdeep_out.txt: $sizes_file"
echo "Difference: $(($sizes_fs - $sizes_file))"
echo ""

tmpfilelist_actual=$(mktemp /tmp/filelist_actual.XXXXXX)
tmpfilelist_hashed=$(mktemp /tmp/filelist_hashed.XXXXXX)

# list of sorted file names in current directory
find . -type f | sort > $tmpfilelist_actual

# list of sorted file names in hashes file
tail -n +6 hashdeep_out.txt                     `# ommit header in hashdeep_out` \
  | sed -e $'s/,/\t/g; s/\t/,/3g'               `# replace the first two commas (column separators) with tabs (since file names might contain commas)` \
  | awk 'BEGIN {FS="\t"; OFS="\t"} {print $3}'  `# only use third column, i.e. file path` \
  | sort > $tmpfilelist_hashed

# compare sorted file lists with comm
echo "| <-- Column 1: Files appearing only on file system but not in the hashes file (unique to file system)"
echo -e "\t| <-- Column 2: Files appearing only in the hashes file but not on file system (unique to hashes file)"
echo ""
comm -3 $tmpfilelist_actual $tmpfilelist_hashed `# list lines unique to either FILE1 or FILE2. Ommit common lines (-3)`

rm "$tmpfilelist_actual"
rm "$tmpfilelist_hashed"


