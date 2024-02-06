#!/bin/bash

##==================================================================================================
##	Requirements
##==================================================================================================

requireCommand() { command -v $1 >/dev/null || { echo "Aborting: '$1' not found"; exit 1; }; }
requireCommand trash


##==================================================================================================
##	Main script
##==================================================================================================

set -o pipefail
cd $1

find . -type f -name "*.mp3" -print0 | while IFS= read -r -d '' file; do
    BITRATE=$(exiftool -AudioBitrate "$file" | grep -Eo '[0-9]+ kbps' | sed 's/ kbps//')
    if [[ $? -eq 0 ]] && [[ $BITRATE -lt 190 ]]; then
        echo $BITRATE "$file"
		trash "$file"
    fi
done
