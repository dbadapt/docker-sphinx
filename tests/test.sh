#!/bin/bash

TESTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

rm -rf "$TESTS_DIR/html/build" "$TESTS_DIR/pdf/build" \
&& docker run -it -v $TESTS_DIR/pdf:/doc  -p 8000:8000 ddidier/sphinx-doc make latexpdf \
&& docker run -it -v $TESTS_DIR/html:/doc -p 8000:8000 ddidier/sphinx-doc make livehtml
