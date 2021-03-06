#!/bin/sh


. ./testutils.sh

should_build

pass_if_console_matches "ISU Thesis" "correct document class"

pass_if_console_matches "detected driver: pdftex" "expected pdftex driver in geometry"

fail_if_log_matches "Bad .contentsname definition" "The contents name macro has been redefined"
pass_if_log_matches "TOC name is .Table of Contents" "The contents name macro is set properly to 'Table of Contents'"

