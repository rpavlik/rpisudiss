\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rpisudiss}[2014/07/06 Ryan Pavlik's ISU Thesis]

% option draftcls: adds "DRAFT" and a date/time stamp on the footer.
\RequirePackage{datetime}
\newcommand{\isu@draftfooter}{}
\DeclareOption{draftcls}{%
	\renewcommand{\isu@draftfooter}{DRAFT - rendered \today\ at \currenttime}%
}

% Forward everything not recognized
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}

% Process options
\ProcessOptions \relax

% Based on report
\LoadClass[12pt]{report}

% had to choose to put this here for tocloft
\RequirePackage{subfigure}

% Put lot, lof, and bibliography in the ToC
\RequirePackage[nottoc]{tocbibind}

% Basic hyperref
\RequirePackage[pdftex,hypertexnames=false,linktocpage=true]{hyperref}
\hypersetup{colorlinks=true,linkcolor=blue,anchorcolor=blue,citecolor=blue,filecolor=blue,urlcolor=blue,bookmarksnumbered=true,pdfview=FitB}

% Choose font encoding
\usepackage[T1]{fontenc}

% Indent first paragraph after sectioning things.
\RequirePackage{indentfirst}

% Setup page layout
\RequirePackage{geometry}
\geometry{left=1in, top=1in, headheight=0.25in, headsep=0.5in, right=1in, bottom=1in, includehead=false}

% Setup headers
\RequirePackage{fancyhdr}
\fancypagestyle{plain}{%
\fancyhf{} % clear all header and footer fields
\fancyhead[C]{\thepage} % Always put the page in the center header
\fancyfoot[C]{\isu@draftfooter} % In draft mode, put stuff in the center footer.
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}}

\newif\if@mainmatter \@mainmatterfalse

% Title page:
% - empty style (no numbering shown)
% - starts the preface/roman numerals
% - gets a PDF bookmark, just because we can.
\renewcommand{\titlepage}
	{\thispagestyle{empty}
	\pagenumbering{roman}
	\pdfbookmark[0]{\@title}{toc}
	% backup and set secnumdepth
	\newcounter{isu@secnumdepth}
	\setcounter{isu@secnumdepth}{\value{secnumdepth}}
	\setcounter{secnumdepth}{-1}
	\@mainmatterfalse}
\renewcommand{\endtitlepage}
	{\newpage}

% Set up sectioning
\RequirePackage{titlesec}

% Caps, bold, large, and center for chapter titles.
\titleformat{\chapter}[block]
	{\normalfont\large\bfseries\centering}
	{\if@mainmatter\MakeUppercase{\chaptertitlename} \thechapter.\quad\fi}
	{0pt}
	{\MakeUppercase}{}

% Double-space overall
\RequirePackage[doublespacing]{setspace}

% Rename the ToC
\RequirePackage[subfigure,titles]{tocloft}
\renewcommand{\contentsname}{Table of Contents}

% Remove parskips from toc/lof/lot
\setlength{\cftparskip}{0pt}


\RequirePackage{xpatch}

% ToC:
% - Single space
% - Added to PDF ToC
% - Page break after
\xpretocmd{\tableofcontents}{%
	\begin{singlespace}}{}{}
\xapptocmd{\tableofcontents}{%
	\end{singlespace}%
	\pdfbookmark[0]{\contentsname}{toc}%
	\clearpage}{}{}

% List of Figures:
% - Single space
% - Page break after
\xpretocmd{\listoffigures}{%
	\begin{singlespace}}{}{}
\xapptocmd{\listoffigures}{%
	\end{singlespace}\clearpage}{}{}

% List of Tables:
% - Single space
% - Page break after
\xpretocmd{\listoftables}{%
	\begin{singlespace}}{}{}
\xapptocmd{\listoftables}{%
	\end{singlespace}\clearpage}{}{}

% Command to indicate when we're done
% with preface content
\newcommand{\mainmatter}{%
	\clearpage
	\pagenumbering{arabic}
	\pagestyle{plain}
	\@mainmattertrue
	\setcounter{chapter}{0}
	% restore secnumdepth
	\setcounter{secnumdepth}{\value{isu@secnumdepth}}
}

\endinput

