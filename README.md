# sync-utils
Scripts to ensure file synchronization across multiple sources with different directory structures and file names

## Base Commands

### Mounting

Mounting the NAS volumes:
```
sudo su
mount -t nfs 192.168.0.10:/volume1/photos-tmp /mnt/photos-tmp/
```


### Hashing

Verify that all files are readable before hashing (`chmod` if not):
```
find . ! -readable
```

Create hashes recursively:
```
hashdeep -c md5 -v -r -l -W hashdeep_out.txt .
```

Validate a hash file without re-hashing. It just checks whether the list of files in the current directory is equivalent with the file list in the hash file. 
Input: Expects a `hashdeep_out.txt` in the current directory.
Output: It lists the files which are unique either to file system or to the hash file (only file names and relative paths considered).
```
./hashing/hash_file_validation.sh
```

Merge all `hashdeep_out.txt` files in the subdirectories of the current working directory (one level only, not recursively). The output is printed to `stdout` and contains a hashdeep-alike header.
```
./hashing/merge_hash_files.sh > hashdeep_out.txt
```

### Auditing

Run an audit of the files in the current directory against the files listed in the hashes file provided:
```
hashdeep -vvv -a -r -k /mnt/photos-tmp/2017/photos_new/hashdeep_out.txt . > hashdeep_audit.txt 2>&1
```

Regex search audit file:
```
/2017/.*No\smatch
```

Rename image files according to their creation date:
```
exiftool '-filename<CreateDate' -d IMG_%Y%m%d_%H%M%S%%-c.%%le -r -ext JPG -ext jpg .
```

Find file duplicates within a particular directory. Out of a set of identical files the first one listed in the input is kept and all the others are listed as duplicates.
Input: Expects a `hashdeep_out.txt` in the current directory.
Output: List of duplicates (file path only)
```
find_duplicates_in_hash_file.sh
```

Move duplicates to a separate folder. Directory structure will not be preserved in the destination folder `../photos_duplicates/`. However, existing destination files are backuped (numbered) and not overwritten. Hint: If some files are already moved (hence, moving them will fail) append `2>&1 >/dev/null | grep -v 'No such file or directory'` to the command in order to ignore non-existing files.
```
find_duplicates_in_hash_file.sh | xargs -d '\n' mv --backup=t -t ../photos_duplicates/
```

