#!/bin/sh


. ./testutils.sh

should_build

pass_if_console_matches "ISU Thesis" "correct document class"

pass_if_console_matches "detected driver: pdftex" "expected pdftex driver in geometry"

fail_if_console_matches "Detected spurious output!" "One or more commands introduced spurious output"

