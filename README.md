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

Validate a hash file without re-hashing. It just checks whether the list of files in the current directory is equivalent with the file list in the hash file. It lists the files with are unique either to file system or the hash file (only file names and relative paths considered).
```
./hashing/hash_file_validation.sh
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

