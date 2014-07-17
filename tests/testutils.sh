#!/bin/sh

TESTDIR="$(cd $(dirname $0) && pwd)"

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
    SRCDIR="$(cd $(dirname $0) && cd .. && pwd)"
    export TEXINPUTS="${SRCDIR}:${TESTDIR}::"



    (
        cd $scratch

        # $OPTIONS is if we want to pass in things to use xelatex or something

        latexmk -norc -cd- -pdf -g -interaction=nonstopmode -halt-on-error $OPTIONS "$TESTDIR/$DOCNAME" 2>&1 | tee basiclog.txt
    )
}

_oppositegrep() {
    if grep "$@" 2>&1 >/dev/null; then
        false
    else
        true
    fi
}

_oppositebuild() {
    if _runbuild; then
        false
    else
        true
    fi
}

shouldbuild() {
    juLog -name="document should build" "_runbuild"
}

shouldfailtobuild() {
    juLog -name="document should fail to build" "_oppositebuild"
}

passiflogmatches() {
    juLog -name="$2" "grep \"$1\" \"$BASICLOG\""
}

failiflogmatches() {
    juLog -name="$2" "_oppositegrep \"$1\" \"$BASICLOG\""
}


. $TESTDIR/sh2ju.sh

