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

exitIfCommandsNotAvailable git




##==============================================================================
##	Helper function
##==============================================================================

getGitDirs() {
	find $1 -type d -name .git -not -path "*.local*" | sed 's/\/.git$//g'
}


housekeepGirDir() {
    local dir=$1
    if [ -d "${dir}" -a -d "${dir}/.git" ]; then
        echo "Git housekeeping: ${dir}"

        ## Fetch from remote, twice in case something goes wrong
	    git -C "$dir" fetch; git -C "$dir" fetch

        ## Delete local branches that have been merged
        git -C "$dir" branch --merged | egrep -v "(^\*|HEAD|master|main|dev|release)" | xargs -r git branch -d

        ## Prune origin: stop tracking branches that do not exist in origin
        git -C "$dir" remote prune origin

        ## Optimize, if needed
        git -C "$dir" gc --auto --aggressive
    fi
}




##==============================================================================
##	Main script
##==============================================================================

for dir in $(getGitDirs $1) ; do
    housekeepGirDir $dir
done
wait
