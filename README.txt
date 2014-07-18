Unofficial Iowa State University LaTeX files by Ryan Pavlik
===========================================================

Completely unaffiliated with the `isuthesis` package/class: made from
scratch.

This is a stub of a readme file.

For reference, these are the guidelines we are trying to comply with:
[Iowa State University - Organizing Your Thesis/Dissertation][organizing]
and [Iowa State University - Thesis Checklist][checklist]

[organizing]:http://www.grad-college.iastate.edu/current/thesis/organizing_thesis/
[checklist]:http://www.grad-college.iastate.edu/current/thesis/checklist/

Testing
-------

These regression tests are by no means complete, but they're at least a
smoketest. You'll need `latexmk` installed, as well as `pdflatex` and
`xelatex` and the dependencies of this class itself.

Running `tests/run-all-tests.sh` will, logically, run all tests,
generating xUnit-style results files in `tests/results` (courtesy of
<https://github.com/manolo/shell2junit> - see that page for how to hook
up your Jenkins to this, too).

License
-------

- For the example/template files `*.tex`:
  - CC0/public domain <http://creativecommons.org/publicdomain/zero/1.0/>

- For the other files (such as class `*.cls` and style `*.sty` files):
  - MIT license <http://opensource.org/licenses/MIT>
  - Initially, at least, Copyright 2014 Ryan Pavlik but see files for full details.
