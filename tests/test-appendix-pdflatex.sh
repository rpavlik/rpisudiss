#!/bin/sh


. ./testutils.sh

should_build

pass_if_console_matches "ISU Thesis" "correct document class"

fail_if_console_matches "Package nag Warning" "Looking for complains by nag"
pass_if_console_matches "No complaints by nag." "Nag package prints 'no complaints' message"

text_of_page() {
    if [ -f "${TARGETNAME}.pdf" ]; then
        pdftotext -f $1 -l $1 -layout -nopgbrk "${TARGETNAME}.pdf" -
    else
        echo "Missing output PDF '${TARGETNAME}.pdf'!" >2
    fi
}

# Check ToC
fail_if_command_matches "text_of_page 1" "APPENDIX[ ]*A" "Single appendix shouldn't have a number in ToC."
pass_if_command_matches "text_of_page 1" "APPENDIX[ ]*MY APPENDIX" "Single appendix is unnumbered in ToC."

# Check chapter title
fail_if_command_matches "text_of_page 2" "APPENDIX[ ]*A" "Single appendix shouldn't have a number in chapter heading."
pass_if_command_matches "text_of_page 2" "APPENDIX[.][ ]*MY APPENDIX" "Single appendix is unnumbered in chapter heading"
