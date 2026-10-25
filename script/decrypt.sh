#!/usr/bin/env bash
#
# Usage: decrypt.sh <ENCRYPTED_PATH> <KEY_PATH>
#

set -e
set -u

MESSAGE() {
    DATE=$(date '+%Y/%m/%d %T')
    echo "$DATE : $1"
}

ENCRYPTED_PATH=$1
KEY_PATH=$2

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
ROOT_DIR=$(dirname "${SCRIPT_DIR}")
DECRYPTED_DIR=${ROOT_DIR}/decrypted

TMP_DIR=$(mktemp -d)
mkdir -p "${TMP_DIR}"

"${SCRIPT_DIR}"/splitaeskey "${ENCRYPTED_PATH}" "${TMP_DIR}"/AES "${TMP_DIR}"/KEY.encripted >"${TMP_DIR}"/IV
if [ ! -e "${TMP_DIR}"/KEY.encripted ]; then
    MESSAGE "ERROR: 復号化に失敗しました。KEY/IV を取得できません。"
    exit 1
fi
if [ ! -e "${TMP_DIR}"/IV ]; then
    MESSAGE "ERROR: 復号化に失敗しました。KEY/IV を取得できません。"
    exit 1
fi
if [ ! -e "${TMP_DIR}"/AES ]; then
    MESSAGE "ERROR: 復号化に失敗しました。AES 暗号化データを取得できません。"
    exit 1
fi

/usr/bin/openssl pkeyutl -inkey "${KEY_PATH}" -in "${TMP_DIR}"/KEY.encripted -decrypt |
od -tx1 |
awk '{if(NR==1){key=$2$3$4$5$6$7$8$9$10$11$12$13$14$15$16$17}if(NR==2){print key $2$3$4$5$6$7$8$9$10$11$12$13$14$15$16$17}}' |
cat >"${TMP_DIR}"/KEY
if [ ! -s "${TMP_DIR}"/KEY ]; then
    MESSAGE "ERROR: 復号化に失敗しました。AES KEY を復号化できません。"
    exit 1
fi

ENCRYPTED_FILE_NAME=$(basename "${ENCRYPTED_PATH}")
DECRYPTED_PATH=${DECRYPTED_DIR}/${ENCRYPTED_FILE_NAME%%.aes}

/usr/bin/openssl enc -aes-256-cbc -d -in "${TMP_DIR}"/AES -out "${DECRYPTED_PATH}" -K "$(cat "${TMP_DIR}"/KEY)" -iv "$(cat "${TMP_DIR}"/IV)" -nosalt -p >/dev/null
if [ ! -e "${DECRYPTED_PATH}" ]; then
    MESSAGE "ERROR: 復号化に失敗しました。AES 暗号化データを復号化できません。"
    exit 1
fi

rm -rf "${TMP_DIR}"
exit 0
