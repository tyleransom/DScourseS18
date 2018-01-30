#!/bin/sh

# This shell script extracts lines 14:end from Chris Albon's markdown files
# Note that you will need to fork his repository and also change any local file paths

cd /local/path/to/chrisalbon/mlai/fork
for f in *.md; do
	sed -n 14,500p $f>>/local/path/to/DScourseS18/DatabaseMgmt/SQLoverview.md
done

