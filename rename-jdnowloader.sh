#!/bin/sh

readonly DIR=${1:-"."}

find "${DIR}/" -type f -print0 | while IFS= read -r -d '' file; do
	file_name=$(basename -- "$file")
	dir_name=$(dirname -- "$file")

	#sed -r 's|\ ?\([0-9]\w*_\w*\)\.|\.|g'; 's|||g' <<< "$file_name"
	new_file_name=$(echo "$file_name" | sed -r \
		-e 's|[\?\;\,]||g' \
		-e 's|\ ?\([0-9]\w*_\w*\)\.|\.|g' \
		-e 's|_| |g; s|\ \.|\.|g; s|\ +|\ |g')

	new_name="${dir_name}/${new_file_name}"
	mv "$file" "$new_name"
done
