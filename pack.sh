#!/bin/bash
# Blockland Add-On packer
# Creates an archive as Add-On for Blockland in Unix
# Can use 7zip for both Windows and Unix with realpath

# Namecheck filename
NAMECHECK="namecheck.txt"

# Prepare exclude file
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null
EXCLUDE="${SCRIPTPATH}/exclude.txt"

# Get all paths
if [ "$#" -gt 0 ]
then
	SRC_PATHS="$@"
else
	SRC_PATHS="."
fi

# Get real path
# https://stackoverflow.com/a/12498485
# Slightly modified. Name is valid, to avoid overwriting
relpath()
{
	local source=$1
	local target=$2

	local common_part=$source # for now
	local result="" # for now

	while [[ "${target#$common_part}" == "${target}" ]]; do
	    # no match, means that candidate common part is not correct
	    # go up one level (reduce common part)
	    common_part="$(dirname $common_part)"
	    # and record that we went back, with correct / handling
	    if [[ -z $result ]]; then
	        result=".."
	    else
	        result="../$result"
	    fi
	done

	if [[ $common_part == "/" ]]; then
	    # special case for root (no common path)
	    result="$result/"
	fi

	# since we now have identified the common part,
	# compute the non-common part
	local forward_part="${target#$common_part}"

	# and now stick all parts together
	if [[ -n $result ]] && [[ -n $forward_part ]]; then
	    result="$result$forward_part"
	elif [[ -n $forward_part ]]; then
	    # extra slash removal
	    result="${forward_part:1}"
	fi

	echo $result
}

# Package it
package()
{
	# Sadly, 7zip have problem with absolute paths
	local EXCLUDEPATH=`relpath ${PWD} ${EXCLUDE}`

	if hash 7za 2>/dev/null
	then
		7za a -tzip -r "$1" ./* -xr@${EXCLUDEPATH}
	elif hash 7z 2>/dev/null
	then
		7z a -tzip -r "$1" ./* -xr@${EXCLUDEPATH}
	else
		echo "No supported archiver available"
		exit 1
	fi
}

# Create Add-On from path
create_addon()
{
	local SRC_PATH="$1"
	# Move to location
	local PREV=${PWD}
	cd "$SRC_PATH"

	# Handle the name of the Add-On
	if [ -f $NAMECHECK ]
	then
		local NAME=$(<${NAMECHECK})
	else
		local NAME=${PWD##*/}
		echo "$NAME" > "$NAMECHECK"
	fi

	# Prepare archive name
	local ARCHIVE="${NAME}.zip"

	# Remove previous archive
	if [ -f $ARCHIVE ]
	then
		rm $ARCHIVE
	fi

	# Package everything
	package $ARCHIVE

	# Move back
	cd "$PREV"
}

# Go through all paths
for SRC_PATH in $SRC_PATHS
do
	create_addon $SRC_PATH
done
