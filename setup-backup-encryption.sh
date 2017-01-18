#!/bin/bash

set -eu
set -o pipefail

# This will create the required config for encrypt-backup and decrypt-backup
# to work.
# This is interactive!

config_dir=~/.config/alexandria/backup
mkdir -p "$config_dir"

echo "What is the name for the gpg backup key?"
read recipient_key_name

if ! gpg --list-keys "$recipient_key_name" > /dev/null 2>&1
then
    echo "Warning: The key '${recipient_key_name}' does not exist!"
fi

cat > "$config_dir/encryption"  <<end_of_config
# This is the recipient key name for backup
recipient_key_name="$recipient_key_name"
end_of_config



