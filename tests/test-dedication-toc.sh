#!/bin/sh


. ./testutils.sh

should_build

pass_if_console_matches "ISU Thesis" "correct document class"
fail_if_console_matches "Package nag Warning" "Looking for complains by nag"
pass_if_console_matches "No complaints by nag." "Nag package prints 'no complaints' message"

# Title page should have the title as the first line, not a page number.
pass_if_command_matches "text_of_page 1 | head -n 1" "This is the title" "Topmost item on title page is title, not page number"

# Dedication should be the second page, numbered "ii" at the top of the page.
pass_if_command_matches "text_of_page 2 | head -n 1" "\s*ii\s*" "First text on the second page is the page number ii"
pass_if_command_matches "text_of_page 2" "Dedication" "Dedication on page ii"


# ToC should be the third page, numbered "iii" at the top of the page.
pass_if_command_matches "text_of_page 3 | head -n 1" "\s*iii\s*" "First text on the third page is the page number iii"
pass_if_command_matches "text_of_page 3" "Table of Contents" "ToC on page iii"

# Check the PDF bookmarks to ensure that the dedication and table of contents are on different pages.
pass_if_bookmark_on_page "Dedication" 2 "Dedication bookmark on page 2"
pass_if_bookmark_on_page "Table of Contents" 3 "TOC bookmark on page 3"

pass_if_bookmark_is_level "Dedication" 1 "Dedication bookmark is level 1"
pass_if_bookmark_is_level "Table of Contents" 1 "TOC bookmark is level 1"

