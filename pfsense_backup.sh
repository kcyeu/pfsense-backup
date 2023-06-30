#!/usr/bin/env bash

set -e

# Read settings form file
. ~/.config/pfsense-backup/rc

UASENAME=${USERNAME:-admin}
# URL
TARGET_HOST=${TARGET_HOST:-192.168.1.1}
TARGET_PORT=${TARGET_PORT:-80}
TARGET_PROTOCOL=${TARGET_PROTOCOL:-http}
BASE_URL="${TARGET_PROTOCOL}://${TARGET_HOST}:${TARGET_PORT}/"

# CURL
CURL_BIN=$(which curl)
CURL_FLAGS=("--location" "--insecure" "--silent")

# File path
BASE_DIR=$(dirname $(readlink -f ${0}))
COOKIE_FILE=${BASE_DIR}/cookies.txt
CSRF_FILE=${BASE_DIR}/csrf.txt
BACKUP_DIR=${HOME}/backups/pfSense
BACKUP_FILE=${BACKUP_DIR}/config_${TARGET_HOST}_$(date +%Y-%m-%d_%H:%M:%S).xml

# Backup options
BACKUP_RETENTION_DAY=30

prepare() {
    mkdir -p "${BACKUP_DIR}"
}

backup() {
    # Save cookies and CSRF token
    ${CURL_BIN} "${CURL_FLAGS[@]}" \
        --cookie-jar "${COOKIE_FILE}" \
        "${BASE_URL}" \
        | grep "name='__csrf_magic'" \
        | sed 's/.*value="\(.*\)".*/\1/' > "${CSRF_FILE}"
    
    # Complete login procedure
    ${CURL_BIN} "${CURL_FLAGS[@]}" \
        --cookie "${COOKIE_FILE}" --cookie-jar "${COOKIE_FILE}" \
        --data-urlencode "login=Login" \
        --data-urlencode "usernamefld=admin" \
        --data-urlencode "passwordfld=${PASSWORD}" \
        --data-urlencode "__csrf_magic=$(cat ${CSRF_FILE})" \
        "${BASE_URL}" > /dev/null
    
    # Fetch the target page to obtain a new CSRF token
    ${CURL_BIN} "${CURL_FLAGS[@]}" \
        --cookie "${COOKIE_FILE}" --cookie-jar "${COOKIE_FILE}" \
        "${BASE_URL}/diag_backup.php"  \
        | grep "name='__csrf_magic'"   \
        | sed 's/.*value="\(.*\)".*/\1/' > "${CSRF_FILE}"
    
    # Download the backup
    ${CURL_BIN} "${CURL_FLAGS[@]}" \
        --cookie "${COOKIE_FILE}" --cookie-jar "${COOKIE_FILE}" \
        --data-urlencode "download=download" \
        --data-urlencode "backupdata=yes" \
        --data-urlencode "backupssh=yes" \
        --data-urlencode "__csrf_magic=$(head -n 1 ${CSRF_FILE})" \
        "${BASE_URL}/diag_backup.php" > "${BACKUP_FILE}"
}

cleanup() {
    # Clean up
    rm -f "${COOKIE_FILE}" "${CSRF_FILE}"
    
    # Compress
    gzip ${BACKUP_DIR}/*.xml
    
    # Remove old backup
    find ${BACKUP_DIR} -mtime +${BACKUP_RETENTION_DAY} -delete
}

prepare
backup
cleanup
