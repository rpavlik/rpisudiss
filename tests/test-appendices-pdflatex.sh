#!/bin/sh

. ./testutils.sh

should_build

# Log the PDFTOTEXT output
log_command_output "text_of_page 1" "pdftotext page 1"
log_command_output "text_of_page 2" "pdftotext page 2"
log_command_output "text_of_page 3" "pdftotext page 3"

pass_if_console_matches "ISU Thesis" "correct document class"

fail_if_console_matches "Package nag Warning" "Looking for complains by nag"
pass_if_console_matches "No complaints by nag." "Nag package prints 'no complaints' message"

# Check ToC
pass_if_command_matches "text_of_page 1" "APPENDIX\s\+A.*2" "ToC Multiple appendices: first is A."
pass_if_command_matches "text_of_page 1" "APPENDIX\s\+B.*3" "ToC Multiple appendices: second is B."
fail_if_command_matches "text_of_page 1" "APPENDIX\s\+MY" "ToC Multiple appendices: none should have a missing number."

# Check appendix headings
pass_if_command_matches "text_of_page 3" "APPENDIX\s\+A." "Chapter heading multiple appendices: first is A."
pass_if_command_matches "text_of_page 4" "APPENDIX\s\+B." "Chapter heading multiple appendices: second is B."

fail_if_command_matches "ext_of_page 3 4" "APPENDIX\.\s\+MY" "Chapter heading multiple appendices: no unnumbered appendices!"

# Check appendix count
pass_if_log_matches "The number of appendices in the tex file: 2\." "There are two appendices in the .tex file."
pass_if_log_matches "The number of appendices in the aux file: 2\." "There are two appendices in the .aux file."
