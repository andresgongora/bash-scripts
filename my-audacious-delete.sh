#!/bin/bash
#https://yalneb.blogspot.com
#Delete song currently playing on audacious and send it to trash



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

exitIfCommandsNotAvailable audtool trash



##==============================================================================
##	Main script
##==============================================================================

SONG="$(audtool current-song-filename)"
touch "$SONG"
trash "$SONG"

POSITION=$(audtool --playlist-position)
audtool --playlist-advance
audtool --playlist-delete $POSITION
