#!/bin/bash

TESTDIR="$(cd $(dirname $0) && pwd)"

(
cd $TESTDIR

for testscript in test-*.sh; do
    cd $TESTDIR
    bash $testscript
done
)
