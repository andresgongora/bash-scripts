#!/bin/bash

##==================================================================================================
##	Requirements
##==================================================================================================

requireCommand() { command -v $1 >/dev/null || { echo "Aborting: '$1' not found"; exit 1; }; }
requireCommand unrar
requireCommand zip
requireCommand trash


##==================================================================================================
##	Main script
##==================================================================================================

find . -name '*.cbr' | while read cbr; do
    echo "Processing '$cbr'"

	PARENT="$(dirname "$cbr")"
	BASENAME=$(basename -- "$cbr")
	FILENAME="${BASENAME%.*}"
	TMP_FOLDER="/tmp/$FILENAME/"
	TMP_ZIP="/tmp/$FILENAME.zip"
	CBZ="$PARENT/$FILENAME.cbz"


	unrar e "$cbr" "$TMP_FOLDER"
	zip -mrj "$TMP_ZIP" "$TMP_FOLDER"/*
	mv "$TMP_ZIP" "$CBZ"


	rm -rf "$TMP_FOLDER"
	trash "$cbr"

done


#for dir in */ ; do
#    comic="${dir::-1}"
#	zip "$comic.zip" "$comic"/*
#	mv "$comic.zip" "$comic.cbz"
#	trash "$dir"
#done

#rm ./FolderToCBZ.sh
