#!/bin/bash

# This tool will highlight multiple search terms using different colors.

# Set the colors
GREP_COLORS=('03;31' '03;32' '03;33' '03;34' '03;35' '03;36' '03;37' '03;38' '03;39' '03;40')

# start the counter
ARG_NUM=0

# Iterate throught the search terms in the arguments
for NUM_ARGS in $*
do
    # Build the egrep "pipe train"
    EGREP="$EGREP GREP_COLOR=\"${GREP_COLORS[$ARG_NUM]}\" egrep -E --color=always "
    # Increment
    ARG_NUM=$(($ARG_NUM + 1))
    # This will replace the search term if it's a keyword
    case $NUM_ARGS in
	ALLIP)
	    REGEX="'(([0-9]|[1-9[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])'\|$ -"
	;;
	ALLEMAIL)
	    REGEX="'[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+'\|$ -"
	;;
	ALLURL)
	    REGEX="'https?://[^[:space:]]+'\|$ -"
	;;
	ALLHTML)
	    REGEX="'</?[a-z].*?>'\|$ -"
	;;
	# The default is whatever was on the command line
	*)
	    REGEX="$NUM_ARGS\|$ -"
    esac

    # add the search term to the end of the "pipe train"
    EGREP="$EGREP $REGEX"

    # If this is not the last search term, add a "|" to keep the pipe train chugging
    if (($ARG_NUM < $#))
    then
	EGREP="$EGREP |"
    fi
done

# Evaluate the whole thing
eval "$EGREP"
echo $EGREP
