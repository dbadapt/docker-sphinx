#!/bin/bash

TESTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $TESTS_DIR/../files/usr/share/ddidier/bash_colours

function test() {
    local option="${1:-notarget}"

    case $option in
        --all)     test_all  ;;
        --html)    test_html ;;
        --pdf)     test_pdf  ;;
        -h|--help) test_help ; exit 0 ;;
        *)         test_help ; exit 1 ;;
    esac
}

function test_help() {
    echo "Usage: ./test.sh <option>"
    echo "  --all      Test HTML and PDF outputs"
    echo "  --html     Test HTML output"
    echo "  --pdf      Test PDF output"
    echo "  -h|--help  Print this message"
}

function test_html() {
    echo -e "Deleting directory '$TESTS_DIR/build'"
    rm -rf "$TESTS_DIR/build"

    echo -e "Generating documentation in '$TESTS_DIR/build'"
    echo -e "${BOLD_YELLOW}Output redirected to '$TESTS_DIR/logs/html.log' ${TXT_RESET}"
    docker run -it --rm -v $TESTS_DIR:/doc -e USER_ID=`id -u $USER` ddidier/sphinx-doc make html > $TESTS_DIR/logs/html.log


    if [ -d "$TESTS_DIR/build/html" ]; then
        local delta=$(diff -r --exclude "_images" $TESTS_DIR/build/html $TESTS_DIR/expected/html)

        if [ "$delta" == "" ]; then
            local image_error=0

            # actdiag includes some hash in the image
            local file_name_prefix=actdiag
            local actual_image=$(find $TESTS_DIR/build/html/_images/ -name "${file_name_prefix}-*.png")
            local expected_image=$(find $TESTS_DIR/expected/html/_images/ -name "${file_name_prefix}-*.png")
            local image_delta=$(compare -metric AE "$actual_image" "$expected_image" /tmp/${file_name_prefix}-diff.png 2>&1)
            local image_delta=$(expr $image_delta + 0)

            # 460 pixels = 0.5%
            if [ $image_delta -gt 460 ]; then
                echo -en "$BOLD_RED"
                echo -en "Number of different pixels for '$file_name_prefix' images: $image_delta"
                echo -e  "$TXT_RESET"
                image_error=1
            else
                echo -e "Number of different pixels for '$file_name_prefix' images: $image_delta"
            fi

            # blockdiag, nwdiag, rackdiag and seqdiag filenames include hashes that change every time
            # but there is only one of each type
            for file_name_prefix in blockdiag nwdiag rackdiag seqdiag; do
                local actual_image=$(find $TESTS_DIR/build/html/_images/ -name "${file_name_prefix}-*.png")
                local expected_image=$(find $TESTS_DIR/expected/html/_images/ -name "${file_name_prefix}-*.png")
                local image_delta=$(compare -metric AE "$actual_image" "$expected_image" /tmp/${file_name_prefix}-diff.png 2>&1)
                local image_delta=$(expr $image_delta + 0)

                if [ $image_delta -gt 0 ]; then
                    echo -en "$BOLD_RED"
                    echo -en "Number of different pixels for '$file_name_prefix' images: $image_delta"
                    echo -e  "$TXT_RESET"
                    image_error=1
                else
                    echo -e "Number of different pixels for '$file_name_prefix' images: $image_delta"
                fi
            done

            # plantuml filename include a hash representing the content
            for file_path in $(find $TESTS_DIR/expected/html/_images/ -name "plantuml-*.png"); do
                local file_name=$(basename $file_path)
                if [ -f $TESTS_DIR/build/html/_images/$file_name ]; then
                    echo "Found matching file for '$file_name'"
                else
                    echo -en "$BOLD_RED"
                    echo -en "No matching file found for '$file_name'"
                    echo -e  "$TXT_RESET"
                    image_error=1
                fi
            done

            if [ $image_error -eq 0 ]; then
                echo -e $BOLD_GREEN
                echo -e " ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
                echo -e " ┃ HTML Test: Success                                                        ┃"
                echo -e " ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
                echo -e $TXT_RESET
            else
                echo -e $BOLD_RED
                echo -e " ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo -e " ┃ HTML Test: Failed                                                          "
                echo -e " ┃ At least one image was different (see above)                               "
                echo -e " ┃ Logs were generated in '$TESTS_DIR/logs/html.log'                          "
                echo -e " ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo -e $TXT_RESET
                exit 1
            fi
        else
            echo -e $BOLD_RED
            echo -e " ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo -e " ┃ HTML Test: Failed                                                          "
            echo -e " ┃ Some useful commands:                                                      "
            echo -e " ┃   diff -r $TESTS_DIR/build/html $TESTS_DIR/expected/html                   "
            echo -e " ┃   meld $TESTS_DIR/build/html $TESTS_DIR/expected/html &                    "
            echo -e " ┃ Logs were generated in '$TESTS_DIR/logs/html.log'                          "
            echo -e " ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo -e $TXT_RESET
            exit 1
        fi
    else
        echo -e $BOLD_RED
        echo -e " ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo -e " ┃ HTML Test: Failed                                                          "
        echo -e " ┃ Directory '$TESTS_DIR/build/html' does not exist                           "
        echo -e " ┃ Logs were generated in '$TESTS_DIR/logs/html.log'                          "
        echo -e " ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo -e $TXT_RESET
        exit 1
    fi
}

function test_pdf() {
    echo "TODO"
}

function test_all() {
    test_html
    test_pdf
}

test $*
