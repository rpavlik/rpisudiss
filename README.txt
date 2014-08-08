Unofficial Iowa State University LaTeX files by Ryan Pavlik
===========================================================

[![Build Status](https://travis-ci.org/rpavlik/rpisudiss.svg)](https://travis-ci.org/rpavlik/rpisudiss)

Completely unaffiliated with the `isuthesis` package/class: made from
scratch.

This is a stub of a readme file.

For reference, these are the guidelines we are trying to comply with:
[Iowa State University - Organizing Your Thesis/Dissertation][organizing]
and [Iowa State University - Thesis Checklist][checklist]

[organizing]:http://www.grad-college.iastate.edu/current/thesis/organizing_thesis/
[checklist]:http://www.grad-college.iastate.edu/current/thesis/checklist/

Dependencies
------------

The following LaTeX packages are required. In parentheses after each is
the Debian/Ubuntu package that contains it.

- hardwrap (`texlive-latex-extra`, or get it from CTAN if you're still
  using 12.04)
- xkeyval (`texlive-latex-recommended`)
- indentfirst (`texlive-latex-base`)
- geometry (`texlive-latex-base`)
- fancyhdr (`texlive-latex-base`)
- textcase (`texlive-latex-extra` in 12.04 or
  `texlive-latex-recommended` in Debian)
- etoolbox (`texlive-latex-extra` recommended, though it also appears to
  be in `etoolbox`?)
- titlesec (`texlive-latex-extra`)
- setspace (`texlive-latex-recommended`)
- tocbibind (`texlive-latex-extra`)
- tocloft (`texlive-latex-extra`)
- xpatch (`texlive-latex-extra`, or get it from CTAN if you're still
  using 12.04)
- hyperref (`texlive-latex-base`)
- xifthen (`texlive-latex-extra`)
- In draft/draftcls mode only:
  - draftwatermark (`texlive-latex-extra`)
  - datetime (`texlive-latex-extra`)

The sample document and tests also use the following, though they're not
required in general for use of the class:

- nag (`texlive-latex-extra`)
- inputenc (`texlive-latex-base`)
- mathpazo (`texlive-latex-base` and `texlive-fonts-recommended`)
- tgpagella (`tex-gyre`)
- microtype (`texlive-latex-recommended`)
- textcomp (`texlive-latex-base`)
- graphicx (`texlive-latex-base`)
- url (`texlive-latex-base`)
- prettyref (`texlive-latex-extra`)
- cmap (`texlive-latex-recommended`)
- glyphtounicode.tex (`texlive-base`)
- bibtex (`texlive-binaries`)

The regression test suite requires the above packages, plus the
following

- blindtext (in `texlive-latex-extra`)
- pdfLaTeX (in `texlive-latex-base`)
- XeLaTeX (in `texlive-xetex`)
- pdftotext (in `poppler-utils`)
- latexmk version 4.31 or newer (in `latexmk` - outdated on 12.04)
- a `sh`-compatible shell (you probably have one like `bash` or `dash`)
- ant and its junit support (requires both `ant` and `ant-optional`)
- the bc command-line calculator (`bc`)
- the `saxonb-xslt` command line tool (in `libsaxonb-java`) (technically
  only required by the `analyze` ant target, but...)
- `find` and `xargs` (in `findutils`, which you probably have already)
- pdftotext (in `poppler-utils`)
- pdftk (in `pdftk`)
- For optional use of `tests/parallel-test.sh`:
  - GNU Parallel (package `parallel`)
- For optional use of `tests/open-report.sh`:
  - on Linux, the `xdg-open` utility (in `xdg-utils`) with your default browser
    set to something useful.
  - on Mac OS X, the standard tool `open` is used.
  - on other platforms, if you can't get or fake `xdg-open` you're out of luck.

### Full dev setup - Debian or Ubuntu

    sudo apt-get install texlive-base texlive-binaries \
    texlive-latex-base texlive-latex-recommended \
    texlive-latex-extra texlive-fonts-recommended \
    texlive-xetex tex-gyre bc ant ant-optional libsaxonb-java \
    findutils parallel latexmk poppler-utils

Supplement with CTAN as above if you have an old release
(TeXLive 2013 or older, IIRC)

### Full dev setup - Mac OS X

MacTeX 2014 required. Plus, via Mac Homebrew:

    brew install ant parallel poppler saxon

Testing
-------

These regression tests are by no means complete, but they're at least a
smoketest. Contributions to make them more complete are certainly
welcome. In particular, tests to verify that documents conform to
Graduate College requirements would be swell.

The script-driven test results are logged into (reasonably-standard)
jUnit-style XML files which end up in `tests/results/` along with the
generated PDF file for each test (if applicable). Using the built-in
`junitreport` task in `ant` seems to be the most common way of merging
results files and getting readable reports from those XML files. The
generated HTML report ends up in `tests/report/` alongside some static
assets used to make browsing test results not entirely unpleasant.

### Running tests and generating reports
The easiest thing to do is just `cd` into the `tests` directory and run
`ant`. The default target is `full-test` which cleans test results, runs
all tests, then combines and formats the results into HTML and shows you
a brief summary of failing tests. A partial list of `ant` targets is:

- `clean` - Removes the generated HTML report, the test result XML
  files, and the PDF outputs.

- `test` - Runs all the tests. (Always succeeds!)

- `format-tests` - combines the test result XML files into one big file,
  then generates a nice HTML report by transforming with the `.xsl`
  file.

- `clean-and-run-tests` - runs `clean`, `test`, and `format-tests` - but
  doesn't really show you useful output data on the console, and always
  exits successfully.

- `analyze` - Effectively the same as running the `analyze-results.sh`
  script: runs an XSLT transform on the results to just show simple
  failure notices for each failing test, and exit with a "failed build"
  if any such failed tests exist. Requires that you've already run least
  `format-tests` to perform the merging of the XML files.

- `full-test` - default, runs `clean-and-run-tests` then `analyze`


### Advanced details
**Individual test scripts `test-*.sh`** can be executed with `bash` to
re-run just a single test suite. You must be in the `tests` directory to
do this - no protection since the typical use case is running all tests
because it's so fast. This is probably only useful if you're tweaking a
particular test suite. You can re-generate the HTML report after doing
this by running `ant format-tests`, or get a nice summary by running
`generate-report.sh` which builds the report (with `format-tests`) then
displays something useful to the console (and gives you an error code)
if you have a failed test.

**`tests/generate-report.sh`** is just a shell-y way to build the
ant targets `format-tests` and `analyze`, to give you a nice HTML
report, a nice console summary of test failures (courtesy of some XSLT),
and an error code. It uses ant internally, it's just a convenience.

**`tests/run-all-tests.sh`** will, logically, run all tests, generating
xUnit-style results files in `tests/results` along with output PDF
files. Doing it this way instead of `ant test` is theoretically
deprecated but might be useful for use with CI systems that have their
own jUnit parsers, but that might not have ant. As such, if you want
pretty results after calling this, you'll have to call
`tests/generate-report.sh`.

**`tests/parallel-test.sh`** will run all tests using GNU Parallel
to execute multiple at a time. This goes really fast. It is otherwise
completely identical to `run-all-tests.sh`, and similarly requires a
`tests/generate-report.sh` call for nice output. As such, a parallel
powered workflow probably includes a command like

    ./parallel-test.sh && ./generate-report.sh

**`tests/open-report.sh`** offers maximum command-line happiness to
Linux users. It will have their desktop environment pick an HTML viewer
(probably your default web browser) and open the report with it.
Obviously this requires the report to already exist.

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
  - Initially, at least, Copyright 2014 Ryan Pavlik but see files for
    full details.
