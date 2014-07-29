#!/bin/sh


. ./testutils.sh

should_build

pass_if_console_matches "ISU Thesis" "correct document class"

pass_if_console_matches "detected driver: pdftex" "expected pdftex driver in geometry"

fail_if_log_matches "Generating title page" "no title page for single chapter"

fail_if_console_matches "Package nag Warning" "Looking for complains by nag"
pass_if_console_matches "No complaints by nag." "Nag package prints 'no complaints' message"

# Checking behavior of abstract environment in a chapter (main matter)
pass_if_command_matches "text_of_page 1" "Abstract" "Main-matter abstract should be here and not all caps (since it's just a section)"
