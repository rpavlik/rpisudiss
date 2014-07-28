#!/bin/sh

export TESTDIR="$(cd $(dirname $0) && pwd)"
export SRCDIR="$(cd $(dirname $0) && cd .. && pwd)"
export TEXINPUTS="${SRCDIR}::"

testscriptbase=$(basename -s .sh "$0")
for possdriver in pdflatex xelatex lualatex; do
    if echo $testscriptbase | grep -q -e "-${possdriver}$"; then
        echo "${possdriver}!"
        export DRIVER="${possdriver}"
        export DOCNAME=$(echo $testscriptbase | sed -e "s/-${DRIVER}$//")
        break
    fi
done

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

if [ ! -f "$TESTDIR/$DOCNAME.tex" ]; then
    echo "in $0 - Could not find $TESTDIR/$DOCNAME.tex!"
    exit 2
fi

echo "---- Test file: $DOCNAME.tex  Driver: $DRIVER ----"

scratch=$(mktemp -d -t tmp.testdissertation.XXXXXXXXXX)
finish() {
  if [ -f "$TARGETNAME.pdf" ]; then
    cp "$TARGETNAME.pdf" "${RESULTSDIR}/${suite}.pdf"
  fi
  rm -rf "$scratch"
}
trap finish EXIT


. $TESTDIR/sh2ju.sh

export DIR="$scratch"
export BASICLOG="$scratch/basiclog.txt"
export LOG="$scratch/$DOCNAME.log"
export TARGETNAME="$scratch/$DOCNAME"
export RESULTSDIR="${juDIR}"

# Running a test means the merged results are invalid - delete them.
rm -f "${RESULTSDIR}/TESTS-TestSuites.xml"
# Same thing with the output PDF
rm -f "${RESULTSDIR}/${suite}.pdf"
# and for goodness sake, get rid of auxiliary files in the source directory.
# failing to do so causes weird unexpected errors.
for ext in aux log out toc bbl; do
    rm -f "${TESTDIR}/${DOCNAME}.${ext}"
done

_runbuild() {
    (
        cd "$scratch"

        # $OPTIONS is if we want to pass in things to use xelatex or something

        latexmk -norc -cd- -pdf -g $OPTIONS "$TESTDIR/$DOCNAME" 2>&1 | tee basiclog.txt
    )
}

_oppositegrep() {
    ! grep "$@" 2>&1 >/dev/null
}

should_build() {
    juLog -name="document should build - console log" -error="Latexmk: Errors, so I did not complete making targets" -error="Fatal error occurred" "_runbuild"
    juLog -name="Full log file" cat "$LOG"
}

should_fail_to_build() {
    juLog -name="document should fail to build - console log" -error="Latexmk: All targets.*are up-to-date" "_runbuild"
    juLog -name="Full log file" cat "$LOG"
}

pass_if_console_matches() {
    juLog -name="$2" "grep \"$1\" \"$BASICLOG\""
}

fail_if_console_matches() {
    juLog -name="$2" "_oppositegrep \"$1\" \"$BASICLOG\""
}

pass_if_log_matches() {
    juLog -name="$2" "grep \"$1\" \"$LOG\""
}

fail_if_log_matches() {
    juLog -name="$2" "_oppositegrep \"$1\" \"$LOG\""
}

pass_if_command_matches() {
    juLog -name="$3" "$1 | grep \"$2\""
}

fail_if_command_matches() {
    juLog -name="$3" "$1 | _oppositegrep \"$2\""
}

log_command_output() {
    juLog -name="Output only: $2" "$1"
}



