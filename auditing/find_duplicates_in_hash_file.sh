#!/bin/bash  

# List all duplicated files in hashdeep_out.txt

tmpfilelist_all=$(mktemp /tmp/all_files.XXXXXX)
tmpfilelist_all_sorted=$(mktemp /tmp/all_files_sorted.XXXXXX)
tmpfilelist_uniq=$(mktemp /tmp/uniq_file_hashes.XXXXXX)


# list of all files
tail -n +6 hashdeep_out.txt                          `# ommit header in hashdeep_out` \
  | sed -e $'s/,/\t/g; s/\t/,/3g'                    `# replace the first two commas (column separators) with tabs (since file names might contain commas)` \
  | awk 'BEGIN {FS="\t"; OFS="\t"} {print $2,$1,$3}' `# rearrange columns to: hash, size, path. Output is tab-separated` \
  > $tmpfilelist_all

# order list of files by hash and size in order to make duplicates adjacent in the list
cat $tmpfilelist_all \
  | sort -k 1,1 -k 2,2n -k 3 -t $'\t' --stable  `# order by hash, then numerically by size and path, tab-separated. Stable by nature.` \
  > $tmpfilelist_all_sorted

# list of unique files (first file out of the identical files listed)
cat $tmpfilelist_all_sorted \
  | sort -k 1,1 -k 2,2n -t $'\t' --stable --unique  `# just keep first instance of identical files` \
  > $tmpfilelist_uniq

## show which files are duplicates in the graphical diff editor (meld)
#all=$(mktemp /tmp/tmp1.XXXXXX)
#uni=$(mktemp /tmp/tmp2.XXXXXX)
#cat $tmpfilelist_all_sorted | sort -k 3 -t $'\t' | cut -d $'\t' -f 3- > $all
#cat $tmpfilelist_uniq | sort -k 3 -t $'\t' | cut -d $'\t' -f 3- > $uni
#meld $all $uni
#rm "$all"
#rm "$uni"

# list all elements which are not in the uniqe file list, i.e. duplicates (which can later be deleted)
comm -23 $tmpfilelist_all_sorted $tmpfilelist_uniq  `# list lines unique to FILE1, i.e. the duplicates. Ommit lines unique to FILE2 (-2) and common lines (-3)` \
  | cut -d $'\t' -f 3-                              `# just use the path column, ommit hash and size. Show column 3 till end of line` \
  | sort                                            `# sort paths`

rm "$tmpfilelist_all"
rm "$tmpfilelist_all_sorted"
rm "$tmpfilelist_uniq"
