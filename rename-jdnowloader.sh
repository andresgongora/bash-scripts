#!/bin/bash

readonly DIR=${1:-"."}
readonly SED_VERSION=$(sed --version | head -n 1 | sed 's|[^0-9\.]||g')

find "${DIR}/" -type f -print0 | while IFS= read -r -d '' file; do
    #echo "$file"
	file_name=$(basename -- "$file")
	dir_name=$(dirname -- "$file")

	## sed
    ## Not alphanumeric, punctuation, or spaces -> remove
    ## ?; -> remove
    ## (bitrate_kbits) -> remove
    ## hls -> remove
    ## _ -> space | multiple spaces -> one space | trailing spaces -> remove | leading spaces
	new_file_name=$(echo "$file_name" | sed -r \
			-e 's|[^[:alnum:][:punct:][:space:]]||g' \
			-e 's|1080p||g; s|720p||g; s|hls_1||g; s|hls||g;' \
			-e 's|\( ?[0-9]{2,}fps ?[^\)]*\w\)||g;' \
			-e 's|\( ?[0-9]{3,}p ?[^\)]*\w\)||g;' \
			-e 's|_[0-9]\.|.|g' \
			-e 's|[|¿\?\;\¡\!]||g' \
			-e 's|\ ?\([0-9]\w*_\w*\)\.|\.|g' \
			-e 's|_| |g; s|\ +|\ |g; s|\ \.|\.|g; s|^\ ||g;')

	if [[ "$new_file_name" != "$file_name" ]]; then
		new_name="${dir_name}/${new_file_name}"
        if [[ ! -e "$new_name" ]]; then
            echo -e "Rename: $file_name\t$new_file_name"
		    mv "$file" "$new_name"
        fi
	fi
done
