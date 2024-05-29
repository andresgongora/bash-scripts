#!/bin/bash

##==================================================================================================
##	Helper functions
##==================================================================================================

renameFile() {
    local readonly file="$1"
    local readonly file_name=$(basename -- "$file")
	local readonly dir_name=$(dirname -- "$file")


    if [[ "$file_name" == .* ]]; then continue; fi # Skip hidden files


	## sed
    ## Not alphanumeric, punctuation, or spaces -> remove
    ## ?; -> remove
    ## (bitrate_kbits) -> remove
    ## hls -> remove
    ## multiple "." -> one "."
    ## _ -> space | multiple spaces -> one space | trailing spaces -> remove | leading spaces
	new_file_name=$(echo "$file_name" | sed -r \
			-e 's|[^[:alnum:][:punct:][:space:]]||g' \
			-e 's|1080p||g; s|720p||g; s|hls_1||g; s|hls||g;' \
			-e 's|\( ?[0-9]{2,}fps ?[^\)]*\w\)||g;' \
			-e 's|\( ?[0-9]{3,}p ?[^\)]*\w\)||g;' \
			-e 's|_[0-9]\.|.|g' \
			-e 's|[|¿\?\;\¡\!]||g' \
			-e 's|\ ?\([0-9]\w*_\w*\)\.|\.|g' \
            -e 's|\.+|\.|g' \
			-e 's|_| |g; s|\ +|\ |g; s|\ \.|\.|g; s|^\ ||g;')

    if [[ -z "$new_file_name" ]]; then continue; fi

	if [[ "$new_file_name" != "$file_name" ]]; then
		new_name="${dir_name}/${new_file_name}"
        if [[ ! -e "$new_name" ]]; then
            echo -e "Rename: $file_name\t$new_file_name"
		    mv "$file" "$new_name"
        fi
	fi
}


##==================================================================================================
##	Main script
##==================================================================================================

readonly DIR=${1:-"."}
find "${DIR}/" -type f -print0 | while IFS= read -r -d '' file; do
    renameFile "$file"
done
