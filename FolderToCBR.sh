#!/usr/bin/env bash

##==================================================================================================
##	Requirements
##==================================================================================================

requireCommand() { command -v $1 >/dev/null || { echo "Aborting: '$1' not found"; exit 1; }; }
requireCommand rar


##==================================================================================================
##	Main script
##==================================================================================================

for dir in */ ; do
    comic="${dir::-1}"
	rar a "$comic.cbr" "$comic/*"
done
