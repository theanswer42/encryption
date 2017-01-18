#!/bin/bash

set -eu
set -o pipefail

# This is a wrapper around gpg to decrypt a backup
# usage:
# decrypt-backup.sh <encrypted-filename>
#
# If encrypted-filename does not have a .gpg extension, we will exit
#
# The output file will be the encrypted-filename with .gpg removed. If
# This file exists, we will exit
#
# To decrypt, the host must have access to the backup key
# ("Alexandria File Backup")
#
# TODO: The user-id to decrypt for should come from config
recipient_key_name="Alexandria File Backup"

encrypted_filename=$1


if ! echo "$encrypted_filename" | grep "\.gpg$" > /dev/null
then
    echo "Encrypted file must be a '.gpg' file"
    exit 1
fi

if [ ! -f "$encrypted_filename" ]
then
    echo "Encrypted file '$encrypted_filename' does not exist"
    exit 1
fi

filename=`echo "$encrypted_filename" | sed -n -e 's/\(.*\)\.gpg$/\1/gp'`

if [ -f "$filename" ]
then
    echo "File '$filename' exists. Cannot decrypt."
    exit 1
fi
gpg -r "$recipient_key_name" --output "$filename" --decrypt "$encrypted_filename"
