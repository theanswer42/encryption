#!/bin/bash

set -eu
set -o pipefail

# This is a wrapper around gpg to encrypt a backup
# usage:
# encrypt-backup.sh <filename>
# encrypted file will be in the same directory, and will be called <filename>.gpg
# If this file already exists, we will exit.
#
# Encryption options added in config:
# --cipher-algo AES256

. ~/.config/alexandria/backup/encryption

filename=$1

if [ ! -f "$filename" ]
then
    echo "File '${filename}' does not exist"
    exit 1
fi

output_filename="${filename}.gpg"
if [ -f "$output_filename" ]
then
    echo "Output File '${output_filename}' already exists"
    exit 0
fi

gpg -r "${recipient_key_name}" --output "$output_filename" --encrypt "$filename"
