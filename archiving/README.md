# Archiving

These scripts are used to create encrypted backups which can be safely stored on a cheap public cloud archive storage as e.g. [AWS S3 Glacier Deep Archive](https://aws.amazon.com/s3/glacier/).

Execute `create_encrypted_tarballs.sh` to create a GPG encrypted tar ball of every subdirectory in the current directory. The script expects the subfolders to be named in the format `YYYYMMDD-some description text` or `YYYY-MM-DD-some description text`. The output files are written to a randomly named temporary folder which is stated in the output of the script. 

In order to hide potentially sensitive folder names, the output file names are obfuscated after the date part (e.g. `20200530-261b5cc3be1d86fac95b402f7243cbbe.tar.gpg`). The also ecrypted `index.txt.gpg` is an additional output of the script. It contains all the mappings from the original folder names to the obfuscated tar balls.

The encryption passphrase is stored in the file `enc-pw.txt` in the script directory (must be manually created before script is executed).

Decrypt an encrypted file using the following command: `gpg -d -o decrypted.tar encrypted.tar.gpg`
