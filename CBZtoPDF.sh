#!/bin/bash

find . -name '*.cbz' | while read cbz; do
    echo "Processing '$cbz'"

	PARENT="$(dirname "$cbz")"
	BASENAME=$(basename -- "$cbz")
	FILENAME="${BASENAME%.*}"
	TMP_FOLDER="/tmp/$FILENAME/"
	TMP_ZIP="/tmp/$FILENAME.zip"
	PDF="$PARENT/$FILENAME.pdf"

	#echo "DEBUG:"
	#echo $PARENT
	#echo $BASENAME
	#echo $FILENAME
	#echo $TMP_FOLDER
	#echo $TMP_ZIP
	#echo $PDF

	cp "${cbz}" "${TMP_ZIP}"
	unzip "${TMP_ZIP}" -d "${TMP_FOLDER}"
	convert "${TMP_FOLDER}/*" "${PDF}" # Here I assume that everything inside the CBZ was an image and compatible with `convert`

	rm -rf "${TMP_FOLDER}"
	rm -rf "${TMP_ZIP}"
done
