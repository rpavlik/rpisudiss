%% Ryan Pavlik's custom, from-scratch ISU thesis class.
%
%    The MIT License (MIT)
%
%    Copyright (c) 2014 Ryan Pavlik
%
%    Permission is hereby granted, free of charge, to any person obtaining a copy
%    of this software and associated documentation files (the "Software"), to deal
%    in the Software without restriction, including without limitation the rights
%    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%    copies of the Software, and to permit persons to whom the Software is
%    furnished to do so, subject to the following conditions:
%
%    The above copyright notice and this permission notice shall be included in
%    all copies or substantial portions of the Software.
%
%    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
%    THE SOFTWARE.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rpisudiss}[2014/07/06 Ryan Pavlik's ISU Thesis]

% For nicer, word-wrapped error, warning, and info messages
\RequirePackage{hardwrap}
\GenerateLogMacros{class}[isu]{rpisudiss}


% For parsing key-value pairs and class options
\RequirePackage{xkeyval}
\newcommand\isuset[1]{%
  \setkeys{isu}{#1}%
}

% For extended conditionals
\RequirePackage{xifthen}


%%%
% Additional options not listed below, and why you'd want to pass them:
%
% - hyperfootnotes=false - if you're using the journal paper style which abuses footnotes.
% - subfigure - if you will use the subfigure package. The 'subfig' package requires no such option.

%%%
% Major formatting options - along with what the rules say.

% option doublespacing: Double-space where we would have preferred the look of 1.5 spaced.
%
% Technically required: `Text should be double-spaced and, consistent throughout thesis'
% 2014-07-11 http://www.grad-college.iastate.edu/current/thesis/checklist/ under Line Spacing
\DeclareOptionX{doublespacing}{%
  \def\isu@spacing{\doublespacing}%
  \def\isu@space{doublespace}%
}
\DeclareOptionX{onehalfspacing}{%
  \def\isu@spacing{\onehalfspacing}%
  \def\isu@space{onehalfspace}%
}


% option capstoc: Capitalize chapters in the table of contents
%
% Technically required if you go by the text of the grad college site,
% but rule inconsistently applied and results painful to read.
%
% Implied by `Titles have all the same capitalization, size, and same font'
% 2014-07-11 http://www.grad-college.iastate.edu/current/thesis/organizing_thesis/table_of_contents.php
\newif\ifisu@capstoc
\isu@capstocfalse
\DeclareOptionX{capstoc}{\isu@capstoctrue}

% option capschap: Capitalize chapters in their headings.
%
% Technically required if you go by the text of the grad college site,
% but rule inconsistently applied and results painful to read.
%
% `All Top Level (Preliminary Pages, Chapter Title, Reference/Bibliography,
% and Appendix) headings must be in all caps, the same size font, and
% location at the top of the page' and `Chapter titles should include
% chapter and number centered in ALL CAPS (ex. CHAPTER 1. INTRODUCTION)'
% 2014-07-11 http://www.grad-college.iastate.edu/current/thesis/organizing_thesis/body_of_manuscript.php
\newif\ifisu@capschap
\isu@capschapfalse
\DeclareOptionX{capschap}{\isu@capschaptrue}

% option tocnumbersections: Number sections in the ToC.
%
% Technically not allowed: `However, neither ... nor reference numbers appearing with text headings are placed in the Table of Contents listing.'
% 2014-07-11 http://www.grad-college.iastate.edu/current/thesis/organizing_thesis/table_of_contents.php
\newif\ifisu@tocnumbersections
\isu@tocnumbersectionsfalse
\DeclareOptionX{tocnumbersections}{\isu@tocnumbersectionstrue}

% option tocnumbersubsections: Number subsections in the ToC. Implies tocnumbersections.
%
% Technically not allowed: `However, neither ... nor reference numbers appearing with text headings are placed in the Table of Contents listing.'
% 2014-07-11 http://www.grad-college.iastate.edu/current/thesis/organizing_thesis/table_of_contents.php
\newif\ifisu@tocnumbersubsections
\isu@tocnumbersubsectionsfalse
\DeclareOptionX{tocnumbersubsections}{\isu@tocnumbersubsectionstrue\isu@tocnumbersectionstrue}

%%%
% Minor formatting options, composition aids, etc.

% option copyrightnotice/nocopyrightnotice: indicate if you want a copyright notice on the title page. Defaults to on.
\newif\ifisu@copyright
\DeclareOptionX{copyrightnotice}{\isu@copyrighttrue}
\DeclareOptionX{nocopyrightnotice}{\isu@copyrightfalse}


% option draftcls: adds "DRAFT" and a date/time stamp on the footer.
\newif\ifisu@draftcls
\isu@draftclsfalse
\DeclareOptionX{draftcls}{\isu@draftclstrue}

% option draft: draftcls plus whatever anyone else thinks about draft.
\DeclareOptionX{draft}{%
  \isu@draftclstrue
  \PassOptionsToClass{draft}{book}%
}

% option print: Optimize for print rather than on-screen (turns links black instead of blue)
\newif\ifisu@print
\isu@printfalse
\DeclareOptionX{print}{\isu@printtrue}

% option ignoremissingmainmatter: Don't error if we've seen a titlepage but no \mainmatter by the end of the document.
\newif\ifisu@errormissingmainmatter
\isu@errormissingmainmattertrue
\DeclareOptionX{ignoremissingmainmatter}{\isu@errormissingmainmatterfalse}

% preamble command \extradraftfooter{} - some text to add to the footer in draftcls mode. Automatically delimited by --- before appending.
\newcommand{\extradraftfooter}[1]{}

% Forward everything not recognized
\DeclareOptionX*{%
  \isu@info@noline{Passing \CurrentOption\space to the `book' class.}
  \PassOptionsToClass{\CurrentOption}{book}
}

% Default options
\ExecuteOptionsX{onehalfspacing}
\ExecuteOptionsX{copyrightnotice}
\PassOptionsToClass{12pt}{book}
\PassOptionsToClass{openany}{book}
\PassOptionsToClass{oneside}{book}

% Process options
\ProcessOptionsX*\relax

% Based on book
\LoadClass{book}

% Indent first paragraph after sectioning things.
\RequirePackage{indentfirst}

% Setup page layout
% TODO optional ``leftbound'' layout - is not twosided though!
\RequirePackage{geometry}
\geometry{margin=1in,headheight=0.25in, headsep=0.5in, includehead=false}


% Handle draftcls option placing timestamp in footer and watermarking first page.
\ifisu@draftcls
  \RequirePackage[firstpage]{draftwatermark}
  \RequirePackage{datetime}

  % Actually make \extradraftfooter{} have an effect.
  \newcommand{\isu@extradraftfooter}{}
  \renewcommand{\extradraftfooter}[1]{\renewcommand\isu@extradraftfooter{\space---\space#1}}

  \newcommand{\isu@draftfooter}{DRAFT --- rendered \today\ at \currenttime\isu@extradraftfooter}
  \newcommand{\isu@drafttitlefooter}{Draft rendered \today\ at \currenttime\isu@extradraftfooter}
\else
  \newcommand{\isu@draftfooter}{}
  \newcommand{\isu@drafttitlefooter}{}
\fi

%%%
% Setup headers/footers
\RequirePackage{fancyhdr}

% override the plain page style.
\fancypagestyle{plain}{%
  \fancyhf{}% clear all header and footer fields
  \fancyhead[C]{\thepage}% Always put the page in the center header
  \fancyfoot[C]{\isu@draftfooter}% In draft mode, put stuff in the center footer.
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
}

% create a "titlepage" page style
\fancypagestyle{titlepage}{%
  \fancyhf{}% clear all header and footer fields
  \fancyfoot[C]{\isu@drafttitlefooter}% In draft mode, put stuff in the center footer.
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
}

\pagestyle{plain} % default page style

\RequirePackage{textcase}% provides \MakeTextUppercase and \MakeTextLowercase

\RequirePackage{etoolbox}% for list processing

%%%
% Set up sectioning
\RequirePackage{titlesec}
% \titleformat{command}[shape]{format}{label}{sep}{before}[after]

% Chapter titles:
% - Caps (optional)
% - large
% - bold
% - center
\ifisu@capschap
  \newcommand{\isu@chapformat}{\MakeTextUppercase}
\else
  \newcommand{\isu@chapformat}{}
\fi

% Keep track of the number of appendices we have so we only number appendices
% if there are more than one.
\newcounter{isu@appendix@count}

\titleformat{\chapter}[block]
  {\normalfont\large\bfseries\centering}
  {\if@mainmatter \isu@chapformat \chaptertitlename\space\thechapter.\quad\fi}
  {0pt}
  {\isu@chapformat}{}

% Section:
% - bold
% - center
\titleformat{\section}[block]
  {\normalfont\normalsize\bfseries\centering}
  {\thesection.}{1em}{}{}

% Subsection:
% - bold
% - left-justified
\titleformat{\subsection}[block]
  {\normalfont\normalsize\bfseries}
  {\thesubsection.}{1em}{}{}

% Subsubsection:
% - bold
% - left-justified with indent
\titleformat{\subsubsection}[block]
  {\normalfont\normalsize\bfseries}
  {\quad\thesubsubsection.}{1em}{}{}

% Apply default spacing
\RequirePackage{setspace}
\isu@spacing

%%%
% Table of Contents (toc)/List of Figures (lof)/List of Tables (lot)

% Put lot, lof, and bibliography (but not the contents itself) in the ToC
\RequirePackage[nottoc]{tocbibind}

% Needed for ToC renaming, enforcing lot/lof titles as chapter title type,
% and formatting
\RequirePackage[titles]{tocloft}

% - Remove parskips from toc (and lof/lot)
\setlength{\cftparskip}{0pt}

% Needed for toc/lof/lot spacing and headfoot tweaking
\RequirePackage{xpatch}

%%%
% ToC:

% - Rename the ToC
\renewcommand{\contentsname}{Table of Contents}

% - Single space
% - Add PDF bookmark
% - Page break after
\xpretocmd{\tableofcontents}{%
  \begin{singlespace}%
  \pdfbookmark[0]{\contentsname}{pdfbookmark:contents}%
}{}{}

\xapptocmd{\tableofcontents}{%
  \end{singlespace}%
  \pagestyle{plain}%
  \clearpage}{%
}{}

% - Add dot leader for chapter levels
\renewcommand\cftchapdotsep{\cftdotsep}

% - Prefix "Chapter " to chapter number
% - Adjust indentation of levels
% - Capitalize title entries, if requested
\ifisu@capstoc
  \renewcommand\cftchappresnum{\MakeTextUppercase{\chaptertitlename}\space}
  \cftsetindents{chapter}{0em}{9em}
  \cftsetindents{section}{2em}{0em}
  \cftsetindents{subsection}{3em}{0em}
  \renewcommand{\cftchapfont}{\bfseries\MakeTextUppercase}
\else
  \renewcommand\cftchappresnum{\protect\chaptertitlename\space}
  \cftsetindents{chapter}{0em}{7em}
  \cftsetindents{section}{1em}{0em}
  \cftsetindents{subsection}{2em}{0em}
  \renewcommand{\cftchapfont}{\bfseries }
\fi

% - Remove section/subsection numbers from ToC by capturing
%   see idea at  http://tex.stackexchange.com/questions/71123/remove-section-number-toc-entries-with-tocloft
\ifisu@tocnumbersections\else
  \renewcommand{\cftsecpresnum}{\begin{lrbox}{\@tempboxa}}
  \renewcommand{\cftsecaftersnum}{\end{lrbox}}
\fi

\ifisu@tocnumbersubsections\else
  \renewcommand{\cftsubsecpresnum}{\begin{lrbox}{\@tempboxa}}
  \renewcommand{\cftsubsecaftersnum}{\end{lrbox}}
\fi

%%%
% List of Figures:
% - Single space
% - Page break after
\xpretocmd{\listoffigures}{%
  \begin{singlespace}%
}{}{}

\xapptocmd{\listoffigures}{%
  \end{singlespace}\clearpage
}{}{}

% - Prepend the word "Figure" to the number
\renewcommand\cftfigpresnum{Figure }
\cftsetindents{figure}{0em}{6em}

%%%
% List of Tables:
% - Single space
% - Page break after
\xpretocmd{\listoftables}{%
  \begin{singlespace}%
}{}{}
\xapptocmd{\listoftables}{%
    \end{singlespace}\clearpage
}{}{}

% - Prepend the word "Table" to the number
\renewcommand\cfttabpresnum{Table }
\cftsetindents{table}{0em}{6em}

% Disable section numbering and backs up the current secnumdepth value
\newcounter{isu@secnumdepth@backup}
\newcommand{\isu@disable@secnum}{%
  \expandafter\isu@info\expandafter{Backing up secnumdepth (was \the\value{secnumdepth}).}%
  \setcounter{isu@secnumdepth@backup}{\value{secnumdepth}}%
  \setcounter{secnumdepth}{-1}%
}

% Restore original secnumdepth value
\newcommand{\isu@restore@secnum}{%
  \expandafter\isu@info\expandafter{Restoring secnumdepth to \the\value{isu@secnumdepth@backup} (was \the\value{secnumdepth}).}%
  \setcounter{secnumdepth}{\value{isu@secnumdepth@backup}}%
}

%%%
% Document division commands

\newif\if@frontmatter
\@frontmatterfalse
\renewcommand\frontmatter{%
  \cleardoublepage
  \@mainmatterfalse
  \@frontmattertrue
  \pagenumbering{roman}%
  \isu@info{In \string\frontmatter, backing up secnumdepth.}%
  \isu@disable@secnum
}

% Command to indicate when we're done
% with preface content - must be called!
% (If we're actually typesetting a full thesis...)
\renewcommand{\mainmatter}{%
  \clearpage
  \pagenumbering{arabic}% also resets page number to 1
  \pagestyle{plain}%
  \@frontmatterfalse
  \@mainmattertrue
  \newcommand{\isu@gotmainmatter}{}%
  \setcounter{chapter}{0}%
  % restore secnumdepth: OK to number chapters from here on out.
  \isu@restore@secnum
}

% Start of appendices
\providecommand{\isu@number@appendices}{0}% if this is our first pass
\renewcommand\appendix{%
  \par
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  \gdef\@chapapp{\appendixname}%
  \gdef\thechapter{\@Alph\c@chapter}%
  % Change the chapter name to 'Appendix' for the table of contents
  \ifisu@capstoc
    \addtocontents{toc}{%
      \protect\renewcommand{\protect\cftchappresnum}{\MakeTextUppercase{\appendixname}\space}%
    }%
  \else
    \addtocontents{toc}{%
      \protect\renewcommand{\protect\cftchappresnum}{\appendixname\space}%
    }%
  \fi
  % Count the number of appendices
  \setcounter{isu@appendix@count}{0}%
  \titleformat{\chapter}[block]%
    {\normalfont\large\bfseries\centering\stepcounter{isu@appendix@count}}%
    {\if@mainmatter \isu@chapformat \chaptertitlename\space\thechapter.\quad\fi}%
    {0pt}%
    {\isu@chapformat}%
    {}%
  \ifthenelse{\isu@number@appendices < 2}{%
    % Leave appendix heading unnumbered
    \titleformat{\chapter}[block]%
      {\normalfont\large\bfseries\centering\stepcounter{isu@appendix@count}}%
      {\if@mainmatter \isu@chapformat \chaptertitlename.\quad\fi}%
      {0pt}%
      {\isu@chapformat}%
      {}%
    % Remove appendix number from table of contents
    \addtocontents{toc}{\protect\renewcommand\protect\numberline[1]{\hb@xt@\@tempdima{\appendixname\hfil}\@cftasnumb}}%
  }{}%
}

% Command to indicate we're done with main content
\renewcommand{\backmatter}{%
  \isu@info{In \string\backmatter, backing up secnumdepth.}%
  \isu@disable@secnum
  \@frontmatterfalse
  \@mainmatterfalse
  % Stop counting appendices
  \titleformat{\chapter}[block]%
    {\normalfont\large\bfseries\centering}%
    {\if@mainmatter \isu@chapformat \chaptertitlename\space\thechapter.\quad\fi}%
    {0pt}%
    {\isu@chapformat}%
    {}%
}

% Verify that we actually got some main matter
\AtEndDocument{
  \ifisu@errormissingmainmatter
    \ifdefined\isu@gottitle
      \isu@info{Full dissertation mode}
      \unless\ifdefined\isu@gotmainmatter
          \isu@error{Missing \protect\mainmatter}{Missing \protect\mainmatter\space before your first and real chapter!}
%           \isu@error{%
%               \protect\mainmatter\space not called in your document expected before your first real chapter}{%
%               You need to put \protect\mainmatter\space before your first real numbered chapter, typically your introduction.}
      \fi
    \fi
  \fi
}

% Record the number of appendices in this document
\AtEndDocument{%
  \immediate\write\@mainaux{\gdef\noexpand\isu@number@appendices{\the\value{isu@appendix@count}}}%
  \immediate\write\@mainaux{\noexpand\isu@info{The number of appendices in the tex file: \the\value{isu@appendix@count}.}}%
  \immediate\write\@mainaux{\noexpand\isu@info{The number of appendices in the aux file: \noexpand\isu@number@appendices.}}%
  \ifnum\value{isu@appendix@count} = \isu@number@appendices%
    \isu@info@noline{Appendix counts match: I'm confident that our decision to number or not number is correct.}%
  \else%
    \isu@warning@noline{The number of appendices seems to have changed. Rerun LaTeX to ensure they are numbered properly.}%
  \fi%
}

%%%
% Basic PDF hyperref

% note that backreferences are incompatible with bibtopic (for per-chapter bibliographies)
\RequirePackage[pdfusetitle,hypertexnames=false,linktocpage=true]{hyperref}
\hypersetup{bookmarksnumbered=true,bookmarksopen=true,pdfpagemode=UseOutlines,pdfview=FitB}

\ifisu@print
  % Hide (don't color) links for print
  \hypersetup{hidelinks, colorlinks=false}
\else
  % Nice blue links.
  \hypersetup{colorlinks=true,linkcolor=blue,anchorcolor=blue,citecolor=blue,filecolor=blue,urlcolor=blue}
\fi


%%%
% Title Page

% The degree may be one of: ma, ms, mfa, phd.
\newcommand\isudegree[1]{\isuset{degree=#1}}
\define@choicekey*+{isu}{degree}[\val\nr]{ma,ms,msc,mfa,phd,dphil}{%
  \ifcase\nr\relax
    \gdef\isu@degree{Master of Arts}%
  \or
    \gdef\isu@degree{Master of Science}%
  \or
    \gdef\isu@degree{Master of Science}%
  \or
    \gdef\isu@degree{Master of Fine Arts}%
  \or
    \gdef\isu@degree{Doctor of Philosophy}%
  \or
    \gdef\isu@degree{Doctor of Philosophy}%
  \fi
}{%
  \isu@error{Missing \protect\isudegree!}{You must specify an \protect\isudegree{type} where `type' may be one of: MA, MS, MFA, PhD.}%
}
\def\isu@degree{\NoCaseChange{\isu@error{You must set the degree type!}{You must specify an \protect\isudegree{type} where `type' may be one of: MA, MS, MFA, PhD.}}}

% Graduation year. Defaults to current year.
\newcommand\isugradyear[1]{\isuset{gradyear=#1}}
\define@key{isu}{gradyear}[\the\year]{%
  \gdef\isu@gradyear{#1}%
}
\isugradyear{\the\year}

% Submission type must be one of: dissertation, thesis, proposal, prelim.
\newcommand\isusubmissiontype[1]{\isuset{submissiontype=#1}}
\define@choicekey*+{isu}{submissiontype}[\val\nr]{dissertation,thesis,proposal,prelim}{%
  \ifcase\nr\relax
    \gdef\isu@submissiontype{dissertation}
  \or
    \gdef\isu@submissiontype{thesis}
  \or
    \gdef\isu@submissiontype{research proposal}
  \or
    \gdef\isu@submissiontype{research proposal}
  \fi
}{%
  \isu@error{Missing \protect\isusubmissiontype!}{You must specify an \protect\isusubmissiontype{type} where `type' may be one of: dissertation, thesis, proposal.}%
}
\def\isu@submissiontype{\NoCaseChange{\isu@error{Missing \protect\isusubmissiontype!}{You must specify an \protect\isusubmissiontype{type} where `type' may be one of: dissertation, thesis, proposal.}}}

% Majors

\newcounter{isu@majors@counter}
\setcounter{isu@majors@counter}{0}
\def\isu@majors@list{}% contains list of majors
\newcommand\isumajor[1]{%
  \renewcommand*{\do}[1]{%
    \listgadd{\isu@majors@list}{##1}%
    \stepcounter{isu@majors@counter}%
    \isu@info{Adding major `##1' as major number \theisu@majors@counter.}%
  }%
  \docsvlist{#1}%
}
\let\isumajors\isumajor
\define@key{isu}{major}{\isumajor{#1}}
\define@key{isu}{majors}{\isumajor{#1}}

\newcommand\isu@majorline{%
  \ifcase\value{isu@majors@counter}%
    \isu@error{Missing \protect\isumajor!}{%
      You must specify one or more majors using the \string\isumajor{...} macro.
      Separate each major in the list with a comma.\\
      \\
      Examples:\\
      \@spaces\string\isumajors{Computer Science,Computer Engineering}\\
      \@spaces\string\isumajor{Human Computer Interaction}
    }%
  \or
    \isu@info{There is only 1 major.}%
    \renewcommand*{\do}[1]{##1}%
    Major: \dolistloop{\isu@majors@list}%
  \else
    \isu@info{There are \theisu@majors@counter\ majors.}%
    \def\dosep{}% no separator before first element
    \renewcommand*{\do}[1]{\dosep ##1\def\dosep{; }}%
    Co-majors: \dolistloop{\isu@majors@list}%
  \fi
}

% Program of study committee
\newcounter{isu@majorprofs@counter}
\newcounter{isu@profs@counter}
\def\isu@majorprofs@list{}% major professors list
\def\isu@profs@list{}% non-major professors list
\def\isuprofessor{\@ifstar\isu@professor@star\isu@professor}
\let\isuprofessors\isuprofessor
\newcommand\isu@professor@star[1]{% major professor
  \renewcommand*{\do}[1]{%
    \listgadd{\isu@majorprofs@list}{##1}%
    \stepcounter{isu@majorprofs@counter}%
  }%
  \docsvlist{#1}%
}
\newcommand\isu@professor[1]{% non-major professor
  \renewcommand*{\do}[1]{%
    \listgadd{\isu@profs@list}{##1}%
    \stepcounter{isu@profs@counter}%
  }%
  \docsvlist{#1}%
}
\define@key{isu}{major professor}{\isuprofessor*{#1}}
\define@key{isu}{major professors}{\isuprofessor*{#1}}
\define@key{isu}{professor}{\isuprofessor{#1}}
\define@key{isu}{professors}{\isuprofessor{#1}}

\newcommand\isu@committee{%
  % List the major professors first
  \ifcase\value{isu@majorprofs@counter}%
    \isu@error{Missing major professor(s)!}{%
      You must specify one or more major professors using the \string\isuprofessor*{...} macro.
      Separate each major professor in the list with a comma. Don't forget the \string*!
    }%
  \or
    \isu@info{There is only 1 major professor.}%
    \renewcommand*{\do}[1]{##1, Major Professor\\}%
    \dolistloop{\isu@majorprofs@list}%
  \else
    \isu@info{There are \theisu@majorprofs@counter\ major professors.}%
    \renewcommand*{\do}[1]{##1, Co-major Professor\\}%
    \dolistloop{\isu@majorprofs@list}%
  \fi

  % Now list the non-major professors
  \ifcase\value{isu@profs@counter}%
    \isu@error{Missing non-major professor(s)!}{%
      You must specify one or more professors using the \string\isuprofessor{...} macro.
      Separate each professor in the list with a comma.
      Don't use a \string* for non-major professors.
    }%
  \or
    \isu@info{There is only 1 non-major professor.}%
    \renewcommand*{\do}[1]{##1\\}%
    \dolistloop{\isu@profs@list}%
  \else
    \isu@info{There are \theisu@profs@counter\ non-major professors.}%
    \renewcommand*{\do}[1]{##1\\}%
    \dolistloop{\isu@profs@list}%
  \fi
}

\ifisu@copyright
  \newcommand\isu@copyrightnotice{\\       % Unclear what the spacing between notice and the text above should be.
  Copyright \copyright\ \@author, \isu@gradyear.
  All rights reserved.
  }
\else
  \newcommand\isu@copyrightnotice{}
\fi

% Abstract environment - it's a chapter in frontmatter, but a section* in
% mainmatter or standalone chapters.
\newenvironment{abstract}{%
  \if@frontmatter
    \chapter{Abstract}%
    \isu@spacing
  \else
    \section*{Abstract}
  \fi
}{}

% Basically wipe out this environment so it doesn't monkey with page numbering.
\renewenvironment{titlepage}{}{}

% Spacing tools
% - used for what the thesis office calls "two blank lines"
\newcommand{\isu@twoblanklines}{20pt}
\newcommand{\isu@maketwoblanklines}{\vspace{\isu@twoblanklines}}


% The actual title page layout.
% Note that portions that appear double-spaced in the sample/annotated PDF
% are given the same spacing as the body of the document (1.5 or 2)
\renewcommand{\maketitle}{%
  \if@frontmatter\else
    \frontmatter% just in case the author forgot
  \fi
  \newcommand{\isu@gottitle}{} % Assume that \maketitle implies typesetting a full thesis, not just a chapter.
  \isu@info{Generating title page -- assuming we are typesetting a full dissertation.}

  \begin{titlepage}
    \thispagestyle{titlepage}

    % - gets a PDF bookmark, just because we can.
    \pdfbookmark[0]{\@title}{toc}
    \@mainmatterfalse

    \setlength{\parindent}{0pt} % Don't you dare try to indent!
    \begin{minipage}[c][\textheight][s]{\linewidth} % Full-page box to contain everything and stretch everything.
      \begin{center}                      % Center this whole page
        \vspace*{12pt}                      % Designated blank line at the top of the page.

        \begin{singlespace}                 % Single-space this section, we manually add spacing.
          \textbf{\@title}\\                  % Title in bold
          \isu@maketwoblanklines             % "two blank lines"
          by\\                                % the word 'by', not in bold
          \isu@maketwoblanklines             % "two blank lines"
          \textbf{\@author}                   % Author in bold
        \end{singlespace}

        \vfill{}                            % let LaTeX decide what "4-6 blank lines" should be.

        \begin{\isu@space}                 % Normal document spacing here.
          A \isu@submissiontype\ submitted to the graduate faculty\\
          in partial fulfillment of the requirements of the degree of\\
          \MakeTextUppercase{\isu@degree}        % Doctor of Philosophy, etc. We enforce caps so they don't have to.
        \end{\isu@space}

        \isu@maketwoblanklines             % "two blank lines"

        \begin{singlespace}                 % Committee is single-spaced, looks like really long majors would be too.
          \isu@majorline\\                   % "Major: MAJ (CONC)" or "Co-majors: MAJ; MAJ;
          \medskip                            % Unspecified space here, looks like just "one blank line" on sample
          Program of Study Committee:\\
          \isu@committee                     % Committee, user-delimited with \\ and user-annoted with ", Major Professor" or "Co-major Professor"
        \end{singlespace}

        \vfill{}                            % let LaTeX decide what "7-8 blank lines" should be.
        \isu@maketwoblanklines             % Suggest it's a little longer than the other vfill.

        \begin{\isu@space}                 % Normal document spacing here
          Iowa State University\\
          Ames, Iowa\\
          \isu@gradyear                       % Newline after here, if needed, is in the copyright notice macro.
          \isu@copyrightnotice                % Copyright line optional if copyright not formally filed.
        \end{\isu@space}

      \end{center}
    \end{minipage}
    \clearpage
  \end{titlepage}
}

\endinput

