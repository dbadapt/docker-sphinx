#!/bin/bash

DOC_DIR="/doc"
DOC_MAKEFILE="$DOC_DIR/Makefile"



# This is a general-purpose function to ask Yes/No questions in Bash, either
# with or without a default answer. It keeps repeating the question until it
# gets a valid answer. https://gist.github.com/davejamesmiller/1965569
function ask() {
    while true; do

        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the question - use /dev/tty in case stdin is redirected from somewhere else
        read -p "$1 [$prompt] " REPLY </dev/tty

        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi

        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}



# The Makefile exists
function start_with-makefile() {
    if ask "Do you want to watch the documentation directory?" Y; then
        make livehtml
    fi
}



# The Makefile doesn't exist
function start_without-makefile() {
    sphinx-quickstart --makefile --no-batchfile

    echo
    echo    "Adding 'livehtml' target to '$DOC_MAKEFILE'"
    echo

    echo    ""                                                               >> "$DOC_MAKEFILE"
    echo    "livehtml:"                                                      >> "$DOC_MAKEFILE"
    echo -e "\tsphinx-autobuild -b html \$(ALLSPHINXOPTS) \$(BUILDDIR)/html" >> "$DOC_MAKEFILE"
}



function start() {
    if [ -f "$DOC_MAKEFILE" ]; then
        start_with-makefile
    else
        start_without-makefile
    fi
}



start "$@"
