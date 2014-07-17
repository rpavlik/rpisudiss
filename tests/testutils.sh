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

export DIR=$scratch
export BASICLOG=$scratch/basiclog.txt
export LOG=$scratch/$DOCNAME.log

_runbuild() {
    (
        cd $scratch

        # $OPTIONS is if we want to pass in things to use xelatex or something

        latexmk -norc -cd- -pdf -g -interaction=nonstopmode -halt-on-error $OPTIONS "$TESTDIR/$DOCNAME" 2>&1 | tee basiclog.txt
    )
}

_oppositegrep() {
    ! grep "$@" 2>&1 >/dev/null
}

shouldbuild() {
    juLog -name="document should build" -error="^Latexmk: Errors" "_runbuild"
}

shouldfailtobuild() {
    juLog -name="document should fail to build" -error="^Latexmk: All targets.*are up-to-date" "_runbuild"
}

passiflogmatches() {
    juLog -name="$2" "grep \"$1\" \"$BASICLOG\""
}

failiflogmatches() {
    juLog -name="$2" "_oppositegrep \"$1\" \"$BASICLOG\""
}


. $TESTDIR/sh2ju.sh

