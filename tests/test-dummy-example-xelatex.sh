#!/bin/sh

. ./testutils.sh

should_build

pass_if_console_matches "ISU Thesis" "correct document class"

fail_if_console_matches "detected driver: pdftex" "this isn't pdftex"

pass_if_log_matches "Generating title page" "full document, should have title page"

fail_if_console_matches "Package nag Warning" "Looking for complains by nag"
pass_if_console_matches "No complaints by nag." "Nag package prints 'no complaints' message"


# Checking behavior of abstract environment in front matter
pass_if_command_matches "text_of_page 2" "ABSTRACT.*v" "Should have a front-matter abstract listed in TOC"
pass_if_command_matches "text_of_page 5" "ABSTRACT" "Front-matter abstract where promised, titled in all caps."
