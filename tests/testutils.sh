#!/bin/sh

export TESTDIR="$(cd $(dirname $0) && pwd)"
export SRCDIR="$(cd $(dirname $0) && cd .. && pwd)"
export TEXINPUTS="${SRCDIR}:${TESTDIR}::"

if [ ! -f "$TESTDIR/$DOCNAME.tex" ]; then
    echo "in $0 - Could not find $TESTDIR/$DOCNAME.tex!"
    exit 2
fi


scratch=$(mktemp -d -t tmp.testdissertation.XXXXXXXXXX)
finish() {
  rm -rf "$scratch"
}
trap finish EXIT


. $TESTDIR/sh2ju.sh

export DIR="$scratch"
export BASICLOG="$scratch/basiclog.txt"
export LOG="$scratch/$DOCNAME.log"
export TARGETNAME="$scratch/$DOCNAME"
export RESULTSDIR="${juDIR}"

_runbuild() {
    (
        cd "$scratch"

        # $OPTIONS is if we want to pass in things to use xelatex or something

        latexmk -norc -cd- -pdf -g -interaction=nonstopmode -halt-on-error $OPTIONS "$TESTDIR/$DOCNAME" 2>&1 | tee basiclog.txt
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



