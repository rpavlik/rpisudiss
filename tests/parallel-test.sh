#!/bin/sh

# For the impatient or the many-cored.

TESTDIR="$(cd $(dirname $0) && pwd)"

(
cd $TESTDIR
rm -rf results
rm -f report/*.html

find . -name "test-*.sh" -print0 | parallel -0 sh
)
