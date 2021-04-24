# Archiving

These scripts are used to create encrypted backups which can be safely stored on a cheap public cloud archive storage as e.g. [AWS S3 Glacier](https://aws.amazon.com/glacier/) Deep Archive.

Execute `create_encrypted_tarballs.sh` to create a GPG encrypted tar ball of every subdirectory in the current directory. The script expects the subfolders to be named in the format `YYMMDD-some description text`. The output files are currently written to a temporary folder. In order to hide potentially sensitive folder names the output file names contain a hash after the date part (e.g. `20200530-261b5cc3be1d86fac95b402f7243cbbe.tar.gpg`). 

The encryption passphrase is stored in the file `enc-pw.txt`

Decrypt an encrypted file using the following command: `gpg -d -o decrypted.tar encrypted.tar.gpg`
