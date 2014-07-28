#!/bin/sh

. ./testutils.sh

should_build

pass_if_console_matches "ISU Thesis" "correct document class"

fail_if_console_matches "Package nag Warning" "Looking for complains by nag"
pass_if_console_matches "No complaints by nag." "Nag package prints 'no complaints' message"

# Check ToC
pass_if_command_matches "pdftotext -f 1 -l 1 -layout ${TARGETNAME}.pdf -" "APPENDIX[ ]*A.*1" "ToC Multiple appendices: first is A."
pass_if_command_matches "pdftotext -f 1 -l 1 -layout ${TARGETNAME}.pdf -" "APPENDIX[ ]*B.*2" "ToC Multiple appendices: second is B."
fail_if_command_matches "pdftotext -f 1 -l 1 -layout ${TARGETNAME}.pdf -" "APPENDIX[ ]*MY" "ToC Multiple appendices: none should have a missing number."

# Check chapter titles
pass_if_command_matches "pdftotext -f 2 -l 2 -layout ${TARGETNAME}.pdf -" "APPENDIX[ ]*A[.]" "Chapter heading multiple appendices: first is A."
pass_if_command_matches "pdftotext -f 3 -l 3 -layout ${TARGETNAME}.pdf -" "APPENDIX[ ]*B[.]" "Chapter heading multiple appendices: second is B."

fail_if_command_matches "pdftotext -f 2 -l 3 -layout ${TARGETNAME}.pdf -" "APPENDIX[.][ ]*MY" "Chapter heading multiple appendices: no unnumbered appendices!"
