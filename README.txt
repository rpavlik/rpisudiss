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
`xelatex` and the dependencies of this class itself, plus the Java build
tool `ant` (stay with me here) if you want a nice readable HTML report.

The script-driven test results are logged into (reasonably-standard)
jUnit-style XML files which end up in `tests/results/`. Using the
built-in `junitreport` task in `ant` seems to be the most common way of
merging results files and getting readable reports from those XML files.
The generated HTML report ends up in `tests/report/` alongside some
static assets used to make browsing test results not entirely
unpleasant.

### Running tests and generating reports
The easiest thing to do is just `cd` into the `tests` directory and run
`ant`. The default target is `full-test` which cleans test results, runs
all tests, then combines and formats the results into HTML. A partial
list of `ant` targets is:

- `clean` - Removes the generated HTML report and the test result XML
  files.
- `test` - Runs all the tests
- `format-tests` - combines the test result XML files into one big file,
  then generates a nice HTML report by transforming with the `.xsl` file. 
- `full-test` - default, runs `clean`, `test`, and `format-tests`


### Advanced details
Individual test scripts `test-*.sh` can be executed with `sh` to re-run
just a single test suite. You must be in the `tests` directory to do
this - no protection since the typical use case is running all tests
because it's so fast. This is probably only useful if you're tweaking a
particular test suite. You can re-generate the HTML report after doing
this by running `ant format-tests`.

Running `tests/run-all-tests.sh` will, logically, run all tests,
generating xUnit-style results files in `tests/results`. Doing it this
way is deprecated but might be useful for use with CI systems that have
their own jUnit parsers, but that don't have ant.

Shell-to-jUnit output is courtesy of a patched version of
<https://github.com/manolo/shell2junit> - see that page for how to hook
up your Jenkins to this, too. No, I haven't yet upstreamed my patches,
it's a TODO.

License
-------

- For the example/template files `*.tex`:
  - CC0/public domain <http://creativecommons.org/publicdomain/zero/1.0/>

- For the other files (such as class `*.cls` and style `*.sty` files):
  - MIT license <http://opensource.org/licenses/MIT>
  - Initially, at least, Copyright 2014 Ryan Pavlik but see files for full details.
