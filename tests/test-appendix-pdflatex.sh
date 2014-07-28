#!/bin/sh


. ./testutils.sh

should_build

pass_if_console_matches "ISU Thesis" "correct document class"

fail_if_console_matches "Package nag Warning" "Looking for complains by nag"
pass_if_console_matches "No complaints by nag." "Nag package prints 'no complaints' message"

# Check ToC
fail_if_command_matches "text_of_page 1" "APPENDIX\s\+A" "Single appendix shouldn't have a number in ToC."
pass_if_command_matches "text_of_page 1" "APPENDIX\s\+MY APPENDIX.*3" "Single appendix is unnumbered in ToC, and correctly pointed to."

# Check appendix heading
fail_if_command_matches "text_of_page 4" "APPENDIX\s\+A" "Single appendix shouldn't have a number in chapter heading."
pass_if_command_matches "text_of_page 4" "APPENDIX.\s\+MY APPENDIX" "Single appendix is unnumbered in chapter heading"

# Check appendix count
pass_if_log_matches "The number of appendices in the tex file: 1\." "There is only one appendix in the .tex file."
pass_if_log_matches "The number of appendices in the aux file: 1\." "There is only one appendix in the .aux file."

