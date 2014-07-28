#!/bin/sh

TESTDIR="$(cd $(dirname $0) && pwd)"

(
cd $TESTDIR

find . -name "test-*.sh" -print0 | xargs -n1 -0 bash
)
