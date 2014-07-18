#!/bin/bash

export DOCNAME=test-dummy-example
export OPTIONS="-xelatex"
. ./testutils.sh

shouldbuild
passiflogmatches "ISU Thesis" "correct document class"
failiflogmatches "detected driver: pdftex" "this isn't pdftex"
passiflogmatches "Generating title page" "full document, should have title page"
passiflogmatches "No complaints by nag." "Nag package at zero warnings"

