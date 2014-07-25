#!/bin/bash

export DOCNAME=test-spurious-output
export OPTIONS="-xelatex"
. ./testutils.sh

should_build

pass_if_console_matches "ISU Thesis" "correct document class"

fail_if_console_matches "Detected spurious output!" "One or more commands introduced spurious output"

