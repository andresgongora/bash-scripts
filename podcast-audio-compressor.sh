#!/usr/bin/env bash

##==================================================================================================
##	Imports
##==================================================================================================

readonly SCRIPT_PATH=$(dirname "$(readlink -f "$0")")
source "${SCRIPT_PATH}/rename_downloads.sh"  # Import renameFile function


##==================================================================================================
##	Requirements
##==================================================================================================

requireCommand() { command -v $1 >/dev/null || { echo "Aborting: '$1' not found"; exit 1; }; }
requireCommand trash
requireCommand lame
requireCommand ffmpeg
requireCommand renameFile


##==================================================================================================
##	Helper functions
##==================================================================================================

compress() {
    local readonly INPUT="$1"
    local readonly extension="${INPUT##*.}"
    local readonly OUTPUT_DIR="$(dirname "{INPUT}")/$(date +%Y.%m.%d)"
    local readonly OUTPUT="${OUTPUT_DIR}/$(basename "${INPUT}" ".$extension").PAC.mp3" # to MP3

    ## Filters
    local readonly FILTER="\
        compand=0|0:1|1:-90/-900|-70/-70|-30/-9|0/-3:6:0:0:0, \
        lowpass=7000, \
        highpass=250, \
        loudnorm=I=-16:LRA=7:tp=-2.0:print_format=none"
        ## Disabled
        #        adeclip, \
        #        adeclick, \

    [[ ! -d "${OUTPUT_DIR}" ]] && mkdir -p "${OUTPUT_DIR}" # Create output dir
    ffmpeg -y -i "$INPUT" -af "${FILTER}" -codec:a libmp3lame -qscale:a 1 "$OUTPUT" </dev/null
}


##==================================================================================================
##	Main script
##==================================================================================================

readonly DIR=${1:-"."}
find "${DIR}/" -type f -print0 | while IFS= read -r -d '' file; do

    if [[ $(basename "$file") == .*      ]]; then continue; fi ## Skip hidden files
    if [[ $(basename "$file") == *.PAC.* ]]; then continue; fi ## Skip already compressed files
    if [[ $(basename "$file") == *.mp3   ]]; then continue; fi ## Skip mp3, likely already compressed

    echo "--------------------------------------------------------------------------------"
    echo "${file}"
    echo "--------------------------------------------------------------------------------"
    echo ""
    renameFile "${file}" && compress "${file}" && trash "${file}"
    echo ""
    echo ""
    echo ""
done
