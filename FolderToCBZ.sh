#!/bin/bash



##==============================================================================
##	Check for dependencies
##==============================================================================

exitIfCommandsNotAvailable() {
	local num_missing=0

	## Iterate over all commands to check
	for maybe_command in "$@"; do
		if [ -z $(command -v ${maybe_command}) ]; then
			echo "'${maybe_command}' not found."
			num_missing=$((num_missing+1))
		fi
	done

	## Abort if any package was missing
	if [ $num_missing -gt 0 ]; then
		echo "Aborting: $num_missing commands were missing. Please install needed packages."
		exit 1
	fi
}

exitIfCommandsNotAvailable trash zip mogrify mat2



##==============================================================================
##	Helper function
##==============================================================================

convertDirToCBZ() {
	local dir=$1
	local comic="${dir::-1}"
	zip "$comic.zip" "$comic"/*
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



##==============================================================================
##	Main script
##==============================================================================

for dir in */ ; do
	if [ -d "$dir" ]; then
		stripDirMetadata "$dir"
    	convertDirToCBZ "$dir"
		#trash "$dir"
	fi
done

#rm ./FolderToCBZ.sh
