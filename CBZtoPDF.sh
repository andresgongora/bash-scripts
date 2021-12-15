#!/bin/bash

find . -name '*.cbz' | while read cbz; do
    echo "Processing '$cbz'"

	PARENT="$(dirname "$cbz")"
	BASENAME=$(basename -- "$cbz")
	FILENAME="${BASENAME%.*}"
	TMP_FOLDER="/tmp/$FILENAME/"
	TMP_ZIP="/tmp/$FILENAME.zip"
	CBZ="$PARENT/$FILENAME.cbz"

	unzip "$cbz" -d "$TMP_FOLDER"
	convert "${TMP_FOLDER}${FILENAME}/*" "./${FILENAME}.pdf" # Here I assume that everything inside the CBZ was an image and compatible with `convert`
	rm -rf "$TMP_FOLDER"
done
