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
pass_if_command_matches "text_of_page 1 -" "APPENDIX[ ]*A.*1" "ToC Multiple appendices: first is A."
pass_if_command_matches "text_of_page 1" "APPENDIX[ ]*B.*2" "ToC Multiple appendices: second is B."
fail_if_command_matches "text_of_page 1" "APPENDIX[ ]*MY" "ToC Multiple appendices: none should have a missing number."

# Check chapter titles
pass_if_command_matches "text_of_page 2" "APPENDIX[ ]*A[.]" "Chapter heading multiple appendices: first is A."
pass_if_command_matches "text_of_page 3" "APPENDIX[ ]*B[.]" "Chapter heading multiple appendices: second is B."

fail_if_command_matches "text_of_page 2 3" "APPENDIX[.][ ]*MY" "Chapter heading multiple appendices: no unnumbered appendices!"
