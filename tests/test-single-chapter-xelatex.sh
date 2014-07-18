#!/bin/bash

export DOCNAME=test-single-chapter
export OPTIONS="-xelatex"
. ./testutils.sh

shouldbuild
passiflogmatches "ISU Thesis" "correct document class"
failiflogmatches "detected driver: pdftex" "expected pdftex driver in geometry"
failiflogmatches "Generating title page" "no title page for single chapter"
passiflogmatches "No complaints by nag." "Nag package at zero warnings"

