#!/bin/bash

for dir in */ ; do
    comic="${dir::-1}"
	rar a "$comic.cbr" "$comic/*"
done
