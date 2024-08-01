#!/bin/sh

result=true

checktool() {
	tool="$1"
	desc="$1 ($2)"
	if [ -z "$2" ]; then
		desc="$1"
	fi
	if which $tool > /dev/null; then
		echo "Got $tool"
	else
		echo "Could not find tool $desc' ($1)!" 1>&2
		result=false # Don't exit now, wait until all tests are run.
	fi
}

# Use in an if statement to guard stuff like version checking.
toolexists() {
	which $1 >/dev/null
}

VER_LT=9
VER_EQ=10
VER_GT=11

# get first component, like CAR
_ver_head() {
	echo "$1" | cut -d "." -f 1
}

# get tail, like CDR
_ver_tail() {
	echo "$1" | sed -n "s/[^.]*[.]\(.*\)/\1/p"
}

_ver_tail_or_zero() {
	vertail=$(_ver_tail "$1")
	if [ -z "$vertail" ]; then
		echo "0"
	else
		echo "$vertail"
	fi
}

_versioncmphelper() {
	a=$1
	b=$2

	a_head="$(_ver_head $a)"
	b_head="$(_ver_head $b)"
	echo "_versioncmphelper:	'$a'	'$b'	'$a_head'	'$b_head'"
	if [ "$a" = "$b" ]; then
		return $VER_EQ
	elif [ $a_head -gt $b_head ]; then
		return $VER_GT
	elif [ $a_head -lt $b_head ]; then
		return $VER_LT
	else
		# 1.1 is greater than 1
		_versioncmphelper $(_ver_tail_or_zero $a) $(_ver_tail_or_zero $b)
		return $?
	fi
}

isatleastversion() {
	tool=$1
	required=$2
	has=$3
	_versioncmphelper $required $has
	case $? in
		$VER_EQ|$VER_LT)
			echo "Got $tool $has (required at least $required)"
			;;
		$VER_GT)
			echo "Don't have $tool version >= $required (have $has)" 1>&2
			result=false
			;;
	esac
}

checktool pdftohtml "pdftohtml (from Poppler)"
checktool pdftk "pdftk"
checktool bc "GNU bc command-line calculator"
checktool latexmk "Latexmk (version 4.31 or newer)"
if toolexists latexmk; then
	isatleastversion latexmk 4.31 $(latexmk -v | sed -n 's/.*Version \(.*\)/\1/p')
fi

$result || exit 1
