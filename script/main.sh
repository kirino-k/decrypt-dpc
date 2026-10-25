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
DECRYPTED_DIR=${ROOT_DIR}/decrypted
EXPANDED_DIR=${ROOT_DIR}/expanded
KEY_PATH=${ROOT_DIR}/key/dpc_ncchd_private_2021.key

TMP_DIR=$(mktemp -d)
mkdir -p "${TMP_DIR}"

# decrypt
mkdir -p "${DECRYPTED_DIR}"
find "${ENCRYPTED_DIR}" -type f -name '*.tar.aes' -print0 |
xargs -0 -I{} "${SCRIPT_DIR}"/decrypt.sh "{}" "${KEY_PATH}"

# expand
mkdir -p "${EXPANDED_DIR}"
find "${DECRYPTED_DIR}" -type f -name '*.tar' -print0 |
xargs -0 "${SCRIPT_DIR}"/expand.sh

exit 0
