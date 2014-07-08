\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rpisudiss}[2014/07/06 Ryan Pavlik's ISU Thesis]

\RequirePackage{setspace}

% option doublespacing: Double-space where we would have 1.5 spaced.
\newcommand\isu@spacing{\onehalfspacing}
\newcommand\isu@space{onehalfspace}
\DeclareOption{doublespacing}{%
	\renewcommand\isu@spacing{\doublespacing}
	\renewcommand\isu@space{doublespace}
}
\RequirePackage{datetime}

% option capstoc: Capitalize chapters in the table of contents
\newif\if@isu@capstoc	\@isu@capstocfalse
\DeclareOption{capstoc}{%
	\@isu@capstoctrue%
}

% option capschap: Capitalize chapters everywhere else
\newif\if@isu@capschap	\@isu@capschapfalse
\DeclareOption{capschap}{%
	\@isu@capschaptrue%
}

% option print: Optimize for print rather than on-screen (hide links, etc.)
% Apparently doesn't work right now. Sad.
\newif\if@isu@print	\@isu@printfalse
\DeclareOption{print}{%
	\@isu@printtrue%
}

% option tocnumbersections: Number sections in the ToC.
\newif\if@isu@tocnumbersections@	\@isu@tocnumbersections@false
\DeclareOption{tocnumbersections}{%
	\@isu@tocnumbersections@true%
}

% option tocnumbersubsections: Number subsections in the ToC. Implies tocnumbersections.
\newif\if@isu@tocnumbersubsections@	\@isu@tocnumbersubsections@false
\DeclareOption{tocnumbersubsections}{%
	\@isu@tocnumbersections@true%
	\@isu@tocnumbersubsections@true%
}

% option draftcls: adds "DRAFT" and a date/time stamp on the footer.
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
\RequirePackage{subfig}

% Put lot, lof, and bibliography in the ToC
\RequirePackage[nottoc]{tocbibind}

% Basic hyperref - note that backreferences are incompatible with bibtopic (for per-chapter bibliographies)
\RequirePackage[pdftex,pdfusetitle,hypertexnames=false,linktocpage=true]{hyperref}
\hypersetup{bookmarksnumbered=true,bookmarksopen=true,pdfpagemode=UseOutlines,pdfview=FitB}

\if@isu@print
	% Hide links for print
	% Apparently doesn't work right now. Sad.
	\hypersetup{hidelinks}
\else
	% Nice blue links.
	\hypersetup{colorlinks=true,linkcolor=blue,anchorcolor=blue,citecolor=blue,filecolor=blue,urlcolor=blue}
\fi

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

% Set up a bool for mainmatter or not.
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

%%%
% Set up sectioning
\RequirePackage{titlesec}
% \titleformat{hcommandi}[hshapei]{hformati}{hlabeli}{hsepi}{hbeforei}[hafteri]

% Chapter titles:
% - Caps (optional)
% - large
% - bold
% - center
\titleformat{\chapter}[block]
	{\normalfont\large\bfseries\centering}
	{\if@mainmatter%
		\if@isu@capschap\MakeUppercase{\chaptertitlename}%
		\else\chaptertitlename\fi\
		\thechapter.\quad\fi}
	{0pt}
	{\if@isu@capschap\MakeUppercase\fi}{}

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
\isu@spacing

% Rename the ToC
\RequirePackage[subfigure,titles]{tocloft}
\renewcommand{\contentsname}{Table of Contents}

% Remove parskips from toc/lof/lot
\setlength{\cftparskip}{0pt}

\RequirePackage{xpatch}

%%%
% ToC:
% - Single space
% - Added to PDF ToC - not presently working
% - Page break after
\xpretocmd{\tableofcontents}{%
	\begin{singlespace}}{}{}
\xapptocmd{\tableofcontents}{%
	\end{singlespace}%
	\pagestyle{plain}%
	% \pdfbookmark[0]{\contentsname}{toc}%
	\clearpage}{}{}

% - Add dot leader for chapter levels
\renewcommand\cftchapdotsep{\cftdotsep}

% - Prefix "Chapter " to chapter number
% - Adjust indentation of levels
% - Capitalize title entries, if appropriate
\if@isu@capstoc
	\renewcommand\cftchappresnum{\MakeUppercase{\chaptertitlename} }
	\cftsetindents{chapter}{0em}{8em}
	\cftsetindents{section}{2em}{0em}
	\cftsetindents{subsection}{3em}{0em}
	\renewcommand{\cftchapfont}{\MakeUppercase}
\else
	\renewcommand\cftchappresnum{\chaptertitlename\ }
	\cftsetindents{chapter}{0em}{6em}
	\cftsetindents{section}{1em}{0em}
	\cftsetindents{subsection}{2em}{0em}
\fi

% - Remove section/subsection numbers from ToC by capturing
%   see idea at  http://tex.stackexchange.com/questions/71123/remove-section-number-toc-entries-with-tocloft
\if@isu@tocnumbersections@\else
\renewcommand{\cftsecpresnum}{\begin{lrbox}{\@tempboxa}}
\renewcommand{\cftsecaftersnum}{\end{lrbox}}
\fi

\if@isu@tocnumbersubsections@\else
\renewcommand{\cftsubsecpresnum}{\begin{lrbox}{\@tempboxa}}
\renewcommand{\cftsubsecaftersnum}{\end{lrbox}}
\fi

%%%
% List of Figures:
% - Single space
% - Page break after
\xpretocmd{\listoffigures}{%
	\begin{singlespace}}{}{}
\xapptocmd{\listoffigures}{%
	\end{singlespace}\clearpage}{}{}

% - Prepend the word "Figure" to the number
\renewcommand\cftfigpresnum{Figure }
\cftsetindents{figure}{0em}{6em}

%%%
% List of Tables:
% - Single space
% - Page break after
\xpretocmd{\listoftables}{%
	\begin{singlespace}}{}{}
\xapptocmd{\listoftables}{%
	\end{singlespace}\clearpage}{}{}

% - Prepend the word "Table" to the number
\renewcommand\cfttabpresnum{Table }
\cftsetindents{table}{0em}{6em}

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

% Command to indicate we're done with main content
\newcommand{\backmatter}{
	\setcounter{isu@secnumdepth}{\value{secnumdepth}}
	\setcounter{secnumdepth}{-1}
	\@mainmatterfalse
}

%%%
% Title Page

% Temporary: hardcode these values in.
\newcommand\isu@degree{Doctor of Philosophy}
\newcommand\isu@gradyear{2014}
\newcommand\isu@submissiontype{dissertation}
\newcommand\isu@majorline{Co-majors: Human-Computer Interaction; Computer Science}
\newcommand\isu@committee{%
Judy M. Vance, Co-major Professor\\%
Leslie Miller, Co-major Professor\\%
Debra Satterfield \\ Jonathan Kelly \\ David Weiss \\ Horea Ilies}
\newcommand\isu@copyrightnotice{\\       % Unclear what the spacing between notice and the text above should be.
Copyright \copyright\ \@author, \isu@gradyear.
All rights reserved.}

% Spacing tools
% - used for what the thesis office calls "two blank lines"
\newcommand{\@isu@twoblanklines}{20pt}
\newcommand{\@isu@maketwoblanklines}{\vspace{\@isu@twoblanklines}}

% The actual title page layout.
% Note that portions that appear double-spaced in the sample/annotated PDF
% are given the same spacing as the body of the document (1.5 or 2)
\renewcommand{\maketitle}{
	\begin{titlepage}
	\setlength{\parindent}{0pt} % Don't you dare try to indent!
	\vbox to \textheight{ % Full-page box to contain everything and stretch everything.
		\begin{center}                      % Center this whole page
		\vspace*{12pt}                      % Designated blank line at the top of the page.

		\begin{singlespace}                 % Single-space this section, we manually add spacing.
		\textbf{\@title}\\                  % Title in bold
		\@isu@maketwoblanklines             % "two blank lines"
		by\\                                % the word 'by', not in bold
		\@isu@maketwoblanklines             % "two blank lines"
		\textbf{\@author}                   % Author in bold
		\end{singlespace}

		\vfill{}                            % let LaTeX decide what "4-6 blank lines" should be.

		\begin{\isu@space}                  % Normal document spacing here.
		A \isu@submissiontype\ submitted to the graduate faculty\\
		in partial fulfillment of the requirements of the degree of\\
		\MakeUppercase{\isu@degree}         % Doctor of Philosophy, etc. We enforce caps so they don't have to.
		\end{\isu@space}

		\@isu@maketwoblanklines             % "two blank lines"

		\begin{singlespace}                 % Committee is single-spaced, looks like really long majors would be too.
		\isu@majorline\\                    % "Major: MAJ (CONC)" or "Co-majors: MAJ; MAJ;
		\medskip                            % Unspecified space here, looks like just "one blank line" on sample
		Program of Study Committee:\\
		\isu@committee                      % Committee, user-delimited with \\ and user-annoted with ", Major Professor" or "Co-major Professor"
		\end{singlespace}

		\vfill{}                            % let LaTeX decide what "7-8 blank lines" should be.
		\@isu@maketwoblanklines             % Suggest it's a little longer than the other vfill.

		\begin{\isu@space}                  % Normal document spacing here
		Iowa State University\\
		Ames, Iowa\\
		\isu@gradyear                       % Newline after here, if needed, is in the copyright notice macro.
		\isu@copyrightnotice                % Copyright line optional if copyright not formally filed.
		\end{\isu@space}

		\end{center}
	}
	\end{titlepage}
}

\endinput

