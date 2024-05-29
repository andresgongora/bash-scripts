#!/usr/bin/env bash

##==================================================================================================
##	Requirements
##==================================================================================================

requireCommand() { command -v $1 >/dev/null || { echo "Aborting: '$1' not found"; exit 1; }; }
requireCommand trash


##==================================================================================================
##	Helper functions
##==================================================================================================

search_and_move_to_trash() {
    local readonly file_extension="${1}"
    local readonly file_extension_lowercase=$(echo "${file_extension}" | tr '[:upper:]' '[:lower:]')
    local readonly file_extension_uppercase=$(echo "${file_extension}" | tr '[:lower:]' '[:upper:]')

    find . -type f -name "*${file_extension}" -exec trash {} \;
    find . -type f -name "*${file_extension_lowercase}" -exec trash {} \;
    find . -type f -name "*${file_extension_uppercase}" -exec trash {} \;

    find . -type d -empty -exec trash {} \;  # Remove empty directories
    find . -type d -empty -exec trash {} \;  # Remove empty directories
}


##==================================================================================================
##	Main script
##==================================================================================================

remove_array=(
    ".DS_Store"
    ".localized"
    "Thumbs.db"
    "desktop.ini"
    "._.DS_Store"
    "._.localized"
    "._Thumbs.db"
    "._desktop.ini"
    ".txt"
    ".m3u"
    ".m3u8"
    ".cue"
    ".log"
    ".sfv"
    ".nfo"
    ".md5"
    ".png"
    ".jpg"
    ".jpeg"
    ".gif"
    ".bmp"
    ".tif"
    ".tiff"
    ".webp"
    ".svg"
    ".ico"
)

for i in "${remove_array[@]}"; do
    search_and_move_to_trash "${i}"
done
