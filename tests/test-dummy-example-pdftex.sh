#!/bin/bash

export DOCNAME=test-dummy-example

. ./testutils.sh

shouldbuild
passiflogmatches "ISU Thesis" "correct document class"
passiflogmatches "detected driver: pdftex" "expected pdftex driver in geometry"
passiflogmatches "Generating title page" "full document, should have title page"
failiflogmatches "Package nag Warning" "Looking for complains by nag"
passiflogmatches "No complaints by nag." "Nag package prints 'no complaints' message"

