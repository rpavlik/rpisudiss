#!/bin/sh
set -e
TESTDIR="$(cd $(dirname $0) && pwd)"


runtransformsaxonb() {
	saxonb-xslt -s:results/TESTS-TestSuites.xml -xsl:junit-fail-only-greppable.xsl
}

runtransformsaxon() {
	saxon results/TESTS-TestSuites.xml junit-fail-only-greppable.xsl
}

if which saxonb-xslt > /dev/null; then
	xform=runtransformsaxonb
elif which saxon > /dev/null; then
	xform=runtransformsaxon
else
	echo "Can't find saxonb-xslt or saxon!" 1>&2
	exit 1
fi


(
cd $TESTDIR
eval $xform | (! grep "Failure")
)
