#!/bin/bash

function require(){
    if ! command -v $1 &> /dev/null; then
        echo "Missing dependency '$1'"
        exit 1
    fi
}


require 'trash'
require 'lame'
require 'ffmpeg'


function compress(){
    local readonly INPUT="$1"
    local readonly extension="${INPUT##*.}"
    local readonly OUTPUT="$(basename "${INPUT}" ".$extension").PAC.mp3"

    local readonly FILTER="\
        compand=0|0:1|1:-90/-900|-70/-70|-30/-9|0/-3:6:0:0:0, \
        adeclip, \
        adeclick, \
        lowpass=7000, \
        highpass=150, \
        loudnorm=I=-16:LRA=7:tp=-2.0:print_format=none"

    ffmpeg -y -i "$INPUT" -af "${FILTER}" -codec:a libmp3lame -qscale:a 1 "$OUTPUT" </dev/null
}


readonly DIR=${1:-"."}
find "${DIR}/" -type f -print0 | while IFS= read -r -d '' file; do
    #echo "$file"
    extension=${file##*.}
	file_name=$(basename -- "$file" ".$extension")
	dir_name=$(dirname -- "$file")

	if [[ "$file_name" != *.PAC ]]; then
            echo "--------------------------------------------------"
            echo "Dynamic-Range Compressing and normalizing ${INPUT}"
            echo "--------------------------------------------------"
            echo ""
	        compress "${file}" # && trash "$file"
            trash "${file}"
            echo "\n\n\n"
	fi
done
