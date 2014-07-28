#!/bin/sh

TESTDIR="$(cd $(dirname $0) && pwd)"

(
cd $TESTDIR
rm -rf results
rm -f report/*.html

find . -name "test-*.sh" -print0 | xargs -n1 -0 sh
)
