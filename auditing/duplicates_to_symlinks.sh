#!/bin/bash  

# List all duplicated files in hashdeep_out.txt

tmpfilelist_all=$(mktemp /tmp/all_files.XXXXXX)
tmpfilelist_all_sorted=$(mktemp /tmp/all_files_sorted.XXXXXX)

# list of all files
tail -n +6 hashdeep_out.txt                          `# ommit header in hashdeep_out` \
  | sed -e $'s/,/\t/g; s/\t/,/3g'                    `# replace the first two commas (column separators) with tabs (since file names might contain commas)` \
  | awk 'BEGIN {FS="\t"; OFS="\t"} {print $2,$1,$3}' `# rearrange columns to: hash, size, path. Output is tab-separated` \
  > $tmpfilelist_all

# order list of files by hash and size in order to make duplicates adjacent in the list
cat $tmpfilelist_all \
  | sort -k 1,1 -k 2,2n -k 3 -t $'\t' --stable  `# order by hash, then numerically by size and path, tab-separated. Stable by nature.` \
  > $tmpfilelist_all_sorted
  
#cat $tmpfilelist_all_sorted | head -n 20

awkcommand='
BEGIN{OFS=FS="\t"}
{
  if ($1 != refHash)
  {
    refHash = $1;
    refPath = $3;
    # print("\nUpdate reference to: " refHash);
  }
  if ($1 == prevHash)
  {
    # delete duplicate file and create a symlink to the original instead
    print("rm \"" $3 "\" && ln -rsv \"" refPath "\" \"" $3 "\"");
  }
  # print $1, (($1 == prevHash) ? ($3 " -> " refPath) : $3); 
  prevHash = $1;
}
'
awk "$awkcommand" $tmpfilelist_all_sorted | source /dev/stdin

rm "$tmpfilelist_all"
rm "$tmpfilelist_all_sorted"
