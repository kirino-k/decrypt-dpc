#!/usr/bin/env bash
#
# main.sh

set -e
set -u

MESSAGE() {
    DATE=$(date '+%Y/%m/%d %T')
    echo "${DATE} : $1"
}

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
ROOT_DIR=$(dirname "${SCRIPT_DIR}")
ENCRYPTED_DIR=${ROOT_DIR}/encrypted
KEY_DIR=${ROOT_DIR}/key
DECRYPTED_DIR=${ROOT_DIR}/decrypted
EXPANDED_DIR=${ROOT_DIR}/expanded

TMP_DIR=$(mktemp -d)
mkdir -p "${TMP_DIR}"

# check encrypted files exist
if [ "$(find "${ENCRYPTED_DIR}" -type f | grep -c '.tar.aes$')" -eq 0 ]; then
    MESSAGE 'ERROR: No encrypted file found in ./encrypted directory.'
    exit 1
fi

# check a single key files exists
if [ "$(find "${KEY_DIR}" -type f | grep -c '.key$')" -eq 0 ]; then
    MESSAGE 'ERROR: No key file found in ./key directory'
    exit 1
elif [ "$(find "${KEY_DIR}" -type f | grep -c '.key$')" -ne 1 ]; then
    MESSAGE 'ERROR: Two or more key files found in ./key directory. Only one key file is allowed.'
    exit 1
fi

# get path of the key file
KEY_PATH=$(ls "${KEY_DIR}"/*.key)

# decrypt
mkdir -p "${DECRYPTED_DIR}"
find "${ENCRYPTED_DIR}" -type f -name '*.tar.aes' -print0 |
xargs -0 -I{} "${SCRIPT_DIR}"/decrypt.sh "{}" "${KEY_PATH}"

# expand
mkdir -p "${EXPANDED_DIR}"
find "${DECRYPTED_DIR}" -type f -name '*.tar' -print0 |
xargs -0 "${SCRIPT_DIR}"/expand.sh

exit 0
