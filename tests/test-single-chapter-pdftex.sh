#!/bin/bash

export DOCNAME=test-single-chapter

. ./testutils.sh

shouldbuild
passiflogmatches "ISU Thesis" "correct document class"
passiflogmatches "detected driver: pdftex" "expected pdftex driver in geometry"
failiflogmatches "Generating title page" "no title page for single chapter"
passiflogmatches "No complaints by nag." "Nag package at zero warnings"

