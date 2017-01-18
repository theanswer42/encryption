#!/bin/bash

set -e
set -u
set -o pipefail

# There are two things to be done here:
# 1. For the first time, we need to generate a new keypair for the backup user
# 2. For setting up a client to encrypt files for backup, we need to import
# an existing public key
# Since the keypair will only be generated ONCE, this script will only handle
# importing an existing public key.
#
# Creating a new keypair
# http://www.dewinter.com/gnupg_howto/english/GPGMiniHowto-3.html#ss3.1
# https://wiki.archlinux.org/index.php/GnuPG
# https://keyring.debian.org/creating-key.html
# https://wiki.debian.org/Subkeys
#
# I'll go with the Debian procedure (A lot of text copied from the link above)
# 1. Update gpg config
# Update ~/.gnupg/gpg.conf
# We need to update GnuPG to use SHA2 in preference to SHA1. So add at the end of the file:
# personal-digest-preferences SHA256
# cert-digest-algo SHA256
# default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed
# personal-cipher-preferences AES256 TWOFISH CAMELLIA256 3DES
# s2k-digest-algo SHA256

# 2. generate the key
#  gpg --full-gen-key
# Name: Alexandria File Backup
# Email: blank
# Comment: blank
# Expiry: 0
#
# If we don't use full-gen-key, gpg does not ask for expiry and we have to
# change expiry using edit-key
#
# Since we are not going to use this to sign anything, we'll skip creating a
# signing subkey.
#
# Exporting the secret key and subkeys for backup:
# gpg  --output ~/secure/alexandria-file-backup-key/private-key --export-secret-keys "Alexandria File Backup"
# gpg  --output ~/secure/alexandria-file-backup-key/subkey --export-secret-subkeys "Alexandria File Backup"
# I hope this covers all my bases. Things I'll have to test:
# 
# On a "blank" machine, I should be able to import keys from backup and decrypt a file.

# We can now delete the secret key (I'm hoping this does not delete the secret subkeys)
# Sigh.. I wish gpg was just slightly easier to understand.
# According to the debian wiki about subkeys, all I have to do now is delete the private key "keygrip" file.
# Even after doing that though, the key shows up in list-secret-keys. Maybe the agent has to reload or
# something like that??

# TODO: This has become documentation and not code. Lets move this to a readme
# 
# Next topics: 
# * encrypt/decrypt
# * on a machine with no keys, import public key and be able to encrypt. test decrypt on a machine with keys.
# * on a machine with no keys, import all keys (including the private subkeys), test decrypt.

# To read:
# http://security.stackexchange.com/questions/31594/what-is-a-good-general-purpose-gnupg-key-setup
# 

# gpg -er Key --s2k-cipher-algo AES256 --s2k-digest-algo SHA512 --cert-digest-algo SHA512 File
# To encrypt a file, use:
#	gpg -r NAME --output OUTFILE.gpg --encrypt INFILE

# lets try the default encryption...
# With the cipher algo preferences set above, no need to specify cipher algo again. just encrypt
# will work. so:
# gpg -r "Alexandria File Backup" --output ${output-filename} --encrypt ${filename}
