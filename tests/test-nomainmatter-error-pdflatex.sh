#!/bin/sh


. ./testutils.sh

should_fail_to_build

pass_if_console_matches "ISU Thesis" "correct document class"

pass_if_console_matches "Missing [\]mainmatter" "correct error message"

