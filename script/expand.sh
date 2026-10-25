#!/usr/bin/env bash
#
# Usage: expand.sh <DECRYPTED_PATH>
#

set -e
set -u

DECRYPTED_PATH=$1

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
ROOT_DIR=$(dirname "${SCRIPT_DIR}")

TMP_DIR=$(mktemp -d)
mkdir -p "${TMP_DIR}"

DECRYPTED_FILE_NAME=$(basename "${DECRYPTED_PATH}")
INSTITUTION_ID=$(echo "${DECRYPTED_FILE_NAME}" | awk -F'_' '{print $1}')
TIMESTAMP=$(echo "${DECRYPTED_FILE_NAME}" | awk -F'_' '{print $2}')

DEST_DIR="${ROOT_DIR}"/expanded/"${INSTITUTION_ID}"/"${TIMESTAMP}"
mkdir -p "${DEST_DIR}"

tar --directory "${TMP_DIR}" -xf "${DECRYPTED_PATH}"
cp "${TMP_DIR}"/確認用ファイル/匿名化レジストリデータファイル.csv.gz "${DEST_DIR}"
cp -r "${TMP_DIR}"/確認用ファイル/DPCデータ "${DEST_DIR}"

rm -rf "${TMP_DIR}"
exit 0
