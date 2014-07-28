#!/bin/sh

TESTDIR="$(cd $(dirname $0) && pwd)"
(
cd $TESTDIR

ant format-tests analyze
)
