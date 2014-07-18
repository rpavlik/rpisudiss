#!/bin/bash

export DOCNAME=test-nomainmatter-error

. ./testutils.sh

shouldfailtobuild
passiflogmatches "ISU Thesis" "correct document class"
passiflogmatches "Missing [\]mainmatter" "correct error message"


