#!/bin/sh

###
# BEGIN SETUP CODE

export TESTDIR="$(cd $(dirname $0) && pwd)"

# Load sh2ju innards
. $TESTDIR/sh2ju.sh

# Prepare temporary directory
scratch=$(mktemp -d -t tmp.testdissertation.XXXXXXXXXX)
# Function to tear down test: copy pdf and delete temp directory.
finish() {
  if [ -f "$TARGETNAME.pdf" ]; then
    cp "$TARGETNAME.pdf" "${RESULTSDIR}/${suite}.pdf"
  fi
  rm -rf "$scratch"
}
trap finish EXIT


# Determine document and driver name
testscriptbase=$(basename "$0" .sh)
for possdriver in pdflatex xelatex lualatex; do
    if echo $testscriptbase | grep -q -e "-${possdriver}$"; then
        echo "${possdriver}!"
        DRIVER="${possdriver}"
        export DOCNAME=$(echo $testscriptbase | sed -e "s/-${DRIVER}$//")
        break
    fi
done

if [ -z "$DRIVER" ]; then
    DRIVER=pdflatex
    echo "--- No driver detected! Defaulting to $DRIVER"
fi

if [ -z "$DOCNAME" ]; then
    export DOCNAME=$(echo $testscriptbase) # make sure to get rid of whitespace this way
    echo "--- Doc name not detected during driver detection - assuming it matches script name: $DOCNAME"
fi

# per-driver compilation options
case $DRIVER in
pdflatex)
    export OPTIONS="-interaction=nonstopmode -halt-on-error"
    ;;
xelatex)
    export OPTIONS="-interaction=nonstopmode -halt-on-error -xelatex"
    ;;
lualatex)
    export OPTIONS="-interaction=nonstopmode -halt-on-error -lualatex"
    ;;
*)
    echo "Unknown or unspecified DRIVER='$DRIVER' for $0 - can't test!"
    exit 1
    ;;
esac

# Set up variables for use by either the build or test scripts.
export DIR="$scratch"
export BASICLOG="$scratch/basiclog.txt"
export LOG="$scratch/$DOCNAME.log"
export PDF="$scratch/$DOCNAME.pdf"
export TARGETNAME="$scratch/$DOCNAME"
export RESULTSDIR="${juDIR}"

export SRCDIR="$(cd $(dirname $0) && cd .. && pwd)"
export TEXINPUTS="${SRCDIR}::"

# Basic feasibility check
if [ ! -f "$TESTDIR/$DOCNAME.tex" ]; then
    echo "in $0 - Could not find $TESTDIR/$DOCNAME.tex!"
    exit 2
fi


# Clean before build

rm -f "${RESULTSDIR}/TESTS-TestSuites.xml" # Running a test means the merged results are invalid - delete them.
# Same thing with the output PDF
rm -f "${RESULTSDIR}/${suite}.pdf" # We'll replace this PDF, ditch the old one

# Get rid of auxiliary files in the source directory.
# Failing to do so causes weird unexpected errors.
for ext in aux log out toc bbl; do
    rm -f "${TESTDIR}/${DOCNAME}.${ext}"
done

# Info message before build
echo "---- Test file: $DOCNAME.tex  Driver: $DRIVER ----"

# END SETUP CODE
###

# Internal function - not for test script use
# Perform the actual build of the document
_runbuild() {
    (
        cd "$scratch"

        latexmk -norc -cd- -pdf -g $OPTIONS "$TESTDIR/$DOCNAME" 2>&1 | tee basiclog.txt
    )
}

# Internal function - not for test script use
# A wrapper for grep that inverts its exit code: error if it finds something, success if it doesn't
_oppositegrep() {
    ! grep "$@" 2>&1 >/dev/null
}

# Checks that PDF bookmark appears on specified page.
# Arguments: PDF bookmark name, page number
# Returns: 0 if bookmark is on specified page, 1 if bookmark is on different page, 2 if bookmark doesn't exist
_check_pdfbookmark_page() {
    pdftk "$PDF" dump_data | \
        sed -e '/^Bookmark\(Title\|PageNumber\)/ !{d}' \
            -e 's/^Bookmark\(Title\|PageNumber\): //' | (
        read BOOKMARK_NAME
        read BOOKMARK_PAGE
        while [ -n "$BOOKMARK_NAME" ]; do
            if [ "x$BOOKMARK_NAME" = "x$1" ]; then
                if [ $BOOKMARK_PAGE -eq $2 ]; then
                    # Bookmark is on expected page
                    exit 0
                else
                    # Bookmark is on unexpected page
                    exit 1
                fi
            fi
            read BOOKMARK_NAME
            read BOOKMARK_PAGE
        done
    )

    EXIT_CODE=$?
    return $EXIT_CODE
}

# Checks that PDF bookmark is a specified level
# Arguments: PDF bookmark name, level number
# Returns: 0 if bookmark is specified level, 1 if bookmark is a different level, 2 if bookmark doesn't exist
_check_pdfbookmark_level() {
    pdftk "$PDF" dump_data | \
        sed -e '/^Bookmark\(Title\|Level\)/ !{d}' \
            -e 's/^Bookmark\(Title\|Level\): //' | (
        read BOOKMARK_NAME
        read BOOKMARK_LEVEL
        while [ -n "$BOOKMARK_NAME" ]; do
            if [ "x$BOOKMARK_NAME" = "x$1" ]; then
                if [ $BOOKMARK_LEVEL -eq $2 ]; then
                    # Bookmark is expected level
                    exit 0
                else
                    # Bookmark is unexpected level
                    exit 1
                fi
            fi
            read BOOKMARK_NAME
            read BOOKMARK_LEVEL
        done
    )

    EXIT_CODE=$?
    return $EXIT_CODE
}

###
# Build commands and assertions - one of these should be the first assertion in a test script
# These take no arguments. In addition to the explicit assertion, they also append the contents
# of the .log file as system output for a second, dummy "test"
should_build() {
    juLog -name="document should build - console log" -error="Latexmk: Errors, so I did not complete making targets" -error="Fatal error occurred" "_runbuild"
    juLog -name="Full log file" cat "$LOG"
}

should_fail_to_build() {
    juLog -name="document should fail to build - console log" -error="Latexmk: All targets.*are up-to-date" "_runbuild"
    juLog -name="Full log file" cat "$LOG"
}
###

###
# Assertions about information printed to the console during build.
# They take two arguments: the pattern to grep for, and a test name/description
pass_if_console_matches() {
    juLog -name="$2" "grep \"$1\" \"$BASICLOG\""
}

fail_if_console_matches() {
    juLog -name="$2" "_oppositegrep \"$1\" \"$BASICLOG\""
}
###

###
# Assertions about information written to the .log file during build.
# They take two arguments: the pattern to grep for, and a test name/description
pass_if_log_matches() {
    juLog -name="$2" "grep \"$1\" \"$LOG\""
}

fail_if_log_matches() {
    juLog -name="$2" "_oppositegrep \"$1\" \"$LOG\""
}
###

###
# Assertions about the output of arbitrary commands
# They take three arguments: a (quoted) command to execute, the pattern to grep for, and a test name/description
pass_if_command_matches() {
    juLog -name="$3" "$1 | grep \"$2\""
}

fail_if_command_matches() {
    juLog -name="$3" "$1 | _oppositegrep \"$2\""
}
###

###
# Assertions about PDF bookmarks appearing on specific pages
# Arguments: title, page number, test name/description
pass_if_bookmark_on_page() {
    juLog -name="$3" "_check_pdfbookmark_page \"$1\" $2"
}

# Assertions about PDF bookmark levels
# They take x arguments: title, level number, test name/description
pass_if_bookmark_is_level() {
    juLog -name="$3" "_check_pdfbookmark_level \"$1\" $2"
}



###
# "Assertion" that simply records a successful test and includes command output
# in the testing log.
# It takes two arguments: a (quoted) command to execute, and a name/description
log_command_output() {
    juLog -name="Output only: $2" "$1"
}
###

###
# Convenience wrapper functions.
# Primarily for use within things like XXX_if_command_matches or log_command_output

# Gets the text of a given page in the PDF (numbered from the first as 1)
# Can take one argument (a single page) or two (a range).  Page breaks (form feeds)
# are removed since they aren't legal in XML CDATA so they break junit.
text_of_page() {
    firstpage=$1
    lastpage=$1
    if [ $# -eq 2 ]; then
        lastpage=$2
    fi
    if [ -f "${TARGETNAME}.pdf" ]; then
        pdftotext -f $firstpage -l $lastpage -layout -nopgbrk "${TARGETNAME}.pdf" -
    else
        echo "Missing output PDF '${TARGETNAME}.pdf'!" 1>&2
    fi
}


