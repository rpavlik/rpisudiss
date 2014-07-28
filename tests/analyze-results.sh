#!/bin/sh
set -e
TESTDIR="$(cd $(dirname $0) && pwd)"

(
cd $TESTDIR
saxonb-xslt -s:results/TESTS-TestSuites.xml -xsl:junit-fail-only-greppable.xsl | (! grep "Failure")
)
