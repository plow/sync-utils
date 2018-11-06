# sync-utils
Scripts to ensure file synchronization across multiple sources with different directory structures and file names

## Base Commands

Mounting the NAS volumes:
```
sudo su
mount -t nfs 192.168.0.10:/volume1/photos-tmp /mnt/photos-tmp/
```

Create hashes recursively:
```
hashdeep -c md5 -v -r -l -W hashdeep_out.txt .
```

Auditing:
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

