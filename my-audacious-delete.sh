#!/usr/bin/env bash

##==================================================================================================
##	Requirements
##==================================================================================================

requireCommand() { command -v $1 >/dev/null || { echo "Aborting: '$1' not found"; exit 1; }; }
requireCommand audtool
requireCommand trash


##==================================================================================================
##	Main script
##==================================================================================================

SONG="$(audtool current-song-filename)"
touch "$SONG"
trash "$SONG"

POSITION=$(audtool --playlist-position)
audtool --playlist-advance
audtool --playlist-delete $POSITION
