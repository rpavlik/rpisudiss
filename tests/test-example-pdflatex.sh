#!/bin/sh


. ./testutils.sh

should_build

# Log the PDFTOTEXT output of the title page, ToC, and first mainmatter page.
log_command_output "text_of_page 1" "pdftotext title page"
log_command_output "text_of_page 2" "pdftotext table of contents"
log_command_output "text_of_page 7" "pdftotext first mainmatter page"

pass_if_console_matches "ISU Thesis" "correct document class"

pass_if_console_matches "detected driver: pdftex" "expected pdftex driver in geometry"

pass_if_log_matches "Generating title page" "full document, should have title page"

fail_if_console_matches "Package nag Warning" "Looking for complains by nag"
pass_if_console_matches "No complaints by nag." "Nag package prints 'no complaints' message"

# Title page should have the title as the first line, not a page number.
pass_if_command_matches "text_of_page 1 | head -n 1" "This is the title" "Topmost item on title page is title, not page number"

# Table of contents should be the second page, numbered "ii" at the top of the page.
pass_if_command_matches "text_of_page 2 | head -n 1" "\s*ii\s*" "First text on the second page is the page number ii"
pass_if_command_matches "text_of_page 2" "TABLE OF CONTENTS" "ToC on page ii"

# Checking behavior of abstract environment in front matter
pass_if_command_matches "text_of_page 2" "ABSTRACT.*v" "Should have a front-matter abstract listed in TOC"
pass_if_command_matches "text_of_page 5" "ABSTRACT" "Front-matter abstract where promised, titled in all caps."

# First mainmatter chapter should be numbered "1", on a page numbered "1"
pass_if_command_matches "text_of_page 2" "CHAPTER 1.*1$" "Chapter 1 listed in ToC as starting on page 1"
pass_if_command_matches "text_of_page 7" "CHAPTER 1.*INTRO" "Chapter 1 is the chapter we expect it to be."
pass_if_command_matches "text_of_page 7 | head -n 1" "1" "Chapter 1 starts on a page numbered 1."
