#!/bin/sh
# For the impatient or the many-cored.

# Ensure parallel is installed
if which parallel > /dev/null; then
    echo "-- parallel is installed"
else
    echo "ERROR: You must install 'parallel' before running this script." 1>&2
    exit 1
fi

TESTDIR="$(cd $(dirname $0) && pwd)"

runthetests() {
    find . -name "test-*.sh" -print0 | parallel -0 sh
}

(
cd $TESTDIR
echo "-- Cleaning old build products"
rm -rf results
rm -f report/*.html

if [ "x$1" = "x-v" ]; then
    echo "-- Running all tests in parallel, verbosely."
    runthetests
else
    echo "-- Running all tests in parallel silently. (Run '$0 -v' to be overwhelmed by verbosity)"
    runthetests > /dev/null 2>&1
fi

echo "-- Tests complete - '$(dirname $0)/generate-report.sh' recommended as your next step"
echo
)
