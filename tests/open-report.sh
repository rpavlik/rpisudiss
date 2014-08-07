#!/bin/sh
#Use your default browser to open the HTML report.
TESTDIR="$(cd $(dirname $0) && pwd)"
REPORTFILE="${TESTDIR}/report/junit-noframes.html"

if which xdg-open > /dev/null; then
	opencmd="xdg-open"
elif which open > /dev/null; then
	opencmd="open"
else
	echo "No idea how to open a file with its default handler! (Need xdg-open on Linux)" 1>&2
	exit 1
fi


if [ -f "${REPORTFILE}" ]; then
	$opencmd "${REPORTFILE}" >/dev/null 2>/dev/null
else
	echo "Report file doesn't exist: couldn't find ${REPORTFILE}"
	echo "You must do something like '$(dirname $0)/generate-report.sh' or"
	echo "run 'ant format-tests' in the test directory to process the raw"
	echo "output into a pretty HTML report."
	exit 1
fi
