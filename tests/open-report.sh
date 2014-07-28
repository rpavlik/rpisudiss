#!/bin/sh
#Use your default browser to open the HTML report.
TESTDIR="$(cd $(dirname $0) && pwd)"
REPORTFILE="${TESTDIR}/report/junit-noframes.html"

if [ -f "${REPORTFILE}" ]; then
	xdg-open "${REPORTFILE}" >/dev/null 2>/dev/null
else
	echo "Report file doesn't exist: couldn't find ${REPORTFILE}"
	echo "You must do something like '$(dirname $0)/generate-report.sh' or"
	echo "run 'ant format-tests' in the test directory to process the raw"
	echo "output into a pretty HTML report."
	exit 1
fi
