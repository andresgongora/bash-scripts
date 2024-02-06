#!/bin/bash

##==================================================================================================
##	Requirements
##==================================================================================================

requireCommand() { command -v $1 >/dev/null || { echo "Aborting: '$1' not found"; exit 1; }; }
requireCommand trash
requireCommand zip
requireCommand mogrify
requireCommand mat2


##==================================================================================================
##	Helper function
##==================================================================================================

convertDirToCBZ() {
	local dir=$1
	local comic="${dir::-1}"
	cd "$dir"; zip -r -X "../${comic}.zip" *; cd ..
	mv "$comic.zip" "$comic.cbz"
}


stripDirMetadata() {

	listAllImagesInDir() {
		find "$1" -type f -exec file --mime-type {} \+ | awk -F: '{if ($2 ~/image\//) print $1}' | sed 's/\ /\\ /g'
	}

	local dir=$1

	## Remove hiden files and folders
	find "$dir" -name ".*" -type f -exec rm {} \; -print

	## Remove metadata from images
	#listAllImagesInDir "$dir" | xargs mogrify -strip

	## Further remove other metadata
	mat2 --inplace --lightweight "$dir"
}

processDir() {
	echo "$1"
	stripDirMetadata "$1"
    convertDirToCBZ "$1"
	trash "$1"
}


##==================================================================================================
##	Main script
##==================================================================================================

for dir in */ ; do
	if [ -d "$dir" ]; then
		processDir "$dir" &
	fi
done
wait

#rm ./FolderToCBZ.sh
