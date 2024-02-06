#!/bin/bash

##==================================================================================================
##	Requirements
##==================================================================================================

requireCommand() { command -v $1 >/dev/null || { echo "Aborting: '$1' not found"; exit 1; }; }
requireCommand trash
requireCommand lame
requireCommand ffmpeg


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

## Check if there is a .rename.sh script in the current directory, if so, run it
if [[ -f "${DIR}/.rename.sh" ]]; then
    echo "Running .rename.sh"
    command "${DIR}/.rename.sh" "${DIR}"
fi

find "${DIR}/" -type f -print0 | while IFS= read -r -d '' file; do

    if [[ $(basename "$file") == .*      ]]; then continue; fi ## Skip hidden files
    if [[ $(basename "$file") == *.PAC.* ]]; then continue; fi ## Skip already compressed files

    echo "--------------------------------------------------------------------------------"
    echo "${file}"
    echo "--------------------------------------------------------------------------------"
    echo ""
    compress "${file}" && trash "${file}"
    echo ""
    echo ""
    echo ""
done
