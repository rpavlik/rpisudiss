#!/bin/sh


. ./testutils.sh

should_build

pass_if_console_matches "ISU Thesis" "correct document class"

fail_if_command_matches "text_of_page 1" "Copyright" "Copyright notice should not be displayed."
