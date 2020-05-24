#!/bin/bash  

if [ $# -eq 0 ]
  then
    echo "No reference hash file path supplied"
    exit 1
fi

hashes_ref=$1

if test ! -f "$hashes_ref"; then
    echo "$hashes_ref does not exist"
    exit 1
fi

#echo "Using reference hash file: $1"

tmpfilelist_this_sorted=$(mktemp /tmp/files_this_sorted.XXXXXX)
tmpfilelist_ref_sorted=$(mktemp /tmp/files_ref_sorted.XXXXXX)
tmpfilelist_this_sorted_cut=$(mktemp /tmp/files_this_sorted_cut.XXXXXX)
tmpfilelist_ref_sorted_cut=$(mktemp /tmp/files_ref_sorted_cut.XXXXXX)

prepHashes() {
  # list of all files
  tail -n +6 $1                                        `# ommit header in hashdeep_out` \
    | sed -e $'s/,/\t/g; s/\t/,/3g'                    `# replace the first two commas (column separators) with tabs (since file names might contain commas)` \
    | awk 'BEGIN {FS="\t"; OFS="\t"} {print $2,$1,$3}' `# rearrange columns to: hash, size, path. Output is tab-separated` \
    | sort -k 1,1 -k 2,2n -k 3 -t $'\t' --stable       `# order by hash, then numerically by size and path, tab-separated. Stable by nature.` \
    > $2
}

prepHashes 'hashdeep_out.txt' "$tmpfilelist_this_sorted"
prepHashes "$hashes_ref" "$tmpfilelist_ref_sorted"
  
# create versions of the sorted list which only contain hash and size column (which can be compared later on)
cat "$tmpfilelist_this_sorted" | cut -d $'\t' -f 1,2 > "$tmpfilelist_this_sorted_cut"
cat "$tmpfilelist_ref_sorted" | cut -d $'\t' -f 1,2 > "$tmpfilelist_ref_sorted_cut"


comm -13 $tmpfilelist_ref_sorted_cut $tmpfilelist_this_sorted_cut `# list all elements which are unique to FILE2, i.e files that are not yet available in the reference directory` \
  | awk '{FS="\t";OFS=""} {print "^", $1, "\\s", $2;}' `# list all elements which are not in the uniqe file list, i.e. duplicates (which can later be deleted)` \
  | grep -f - $tmpfilelist_this_sorted `# lookup full path using the regex passed via stdin` \
  | cut -d $'\t' -f 3-  `# omit hash and size, just use path, i.e columns 3` \
  | sort

rm "$tmpfilelist_this_sorted"
rm "$tmpfilelist_ref_sorted"
rm "$tmpfilelist_this_sorted_cut"
rm "$tmpfilelist_ref_sorted_cut"
