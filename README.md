# Wrappers for backup file encrypt/decrypt
## gpg setup
### gpg configuration
Recommended configuration for gpg (Add to ~/.gnupg/gpg.conf)

> personal-digest-preferences SHA256

> cert-digest-algo SHA256

> default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2  ZIP Uncompressed

> personal-cipher-preferences AES256 TWOFISH CAMELLIA256 3DES

> s2k-digest-algo SHA256

### Create a new keypair
Backup encryption will need a gpg keypair - this needs to happen before any 
encryption happens. To generate a new keypair:

> gpg --full-gen-key
 
Set: 
- Name: Alexandria File Backup
- Email: blank
- Comment: blank
- Expiry: 0

### Clean up
TODO
- backup private key (and subkeys) and remove
- procedure to import a private key (and subkeys)

## Setup
Simply run:

> ./setup-backup-encryption.sh
 
This saves the key name in ~/.config/alexandria/backup/encryption

## Usage

Encrypt: 

> ./encrypt-backup.sh filename
 
Encrypts a file; output saved as filename.gpg

Decrypt:

> ./decrypt-backup.sh filename.gpg
 
Decrypts filename.gpg into filename

# Resources

- http://www.dewinter.com/gnupg_howto/english/GPGMiniHowto-3.html#ss3.1
- https://wiki.archlinux.org/index.php/GnuPG
- https://keyring.debian.org/creating-key.html
- https://wiki.debian.org/Subkeys
- http://security.stackexchange.com/questions/31594/what-is-a-good-general-purpose-gnupg-key-setup

# Random notes
gpg --ful-gen-key

- If we don't use full-gen-key, gpg does not ask for expiry and we have to
change expiry using edit-key
- Since we are not going to use this to sign anything, we'll skip creating a
signing subkey.

# Clean this up please


Exporting the secret key and subkeys for backup:
gpg  --output ~/secure/alexandria-file-backup-key/private-key --export-secret-keys "Alexandria File Backup"
gpg  --output ~/secure/alexandria-file-backup-key/subkey --export-secret-subkeys "Alexandria File Backup"
I hope this covers all my bases. Things I'll have to test:

On a "blank" machine, I should be able to import keys from backup and decrypt a file.

We can now delete the secret key (I'm hoping this does not delete the secret subkeys)
Sigh.. I wish gpg was just slightly easier to understand.
According to the debian wiki about subkeys, all I have to do now is delete the private key "keygrip" file.
Even after doing that though, the key shows up in list-secret-keys. Maybe the agent has to reload or
something like that??

useful settings for symmetric encryption: 
https://github.com/SixArm/gpg-encrypt/blob/master/gpg-encrypt
Using gpg: 

gpg --symmetric \
    --cipher-algo aes256 \
    --digest-algo sha256 \
    --cert-digest-algo sha256 \
    --compress-algo none -z 0 \
    --s2k-mode 3 \
    --s2k-digest-algo sha512 \
    --s2k-count 65011712 \
    --force-mdc \
    --quiet --no-greeting \
"$@"

About the options:
To get our settings, we use these gpg options:
 
    --symmetric                   Encrypt with symmetric cipher only This command asks for a passphrase.
    --cipher-algo aes256          Use AES256 as the cipher algorithm
    --digest-algo sha256          Use SHA256 as the digest algorithm.
    --cert-digest-algo sha256     Use SHA256 as the message digest algorithm used when signing a key.
    --compress-algo none -z 0     Do not compress the file.
    --s2k-mode 3                  Use passphrase mangling iteration mode.
    --s2k-digest-algo sha256      Use SHA256 as the passphrase iteration algorithm.
    --s2k-count 65011712          Use the maximum number of passphrase iterations.
    --force-mdc                   Use modification detection code.
    --quiet                       Try to be as quiet as possible.
    --no-greeting                 Suppress the initial copyright message but do not enter batch mode.


