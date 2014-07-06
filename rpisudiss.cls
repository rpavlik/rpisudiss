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

\renewcommand{\titlepage}
	{\thispagestyle{empty}
	\pagenumbering{roman}}
\renewcommand{\endtitlepage}
	{\newpage}


% Set up sectioning
\RequirePackage{titlesec}
\titleformat{\chapter}[block]
	{\normalfont\large\bfseries\centering}
	{\MakeUppercase{\chaptertitlename} \thechapter.\quad}
	{0pt}
	{\MakeUppercase}{}

% For journal paper format
\newcommand{\paperinfo}[1]{\begin{center} A paper #1 \end{center} \vspace{.4in}}

% Don't include chapter number in section numbering
\renewcommand\thesection{\arabic{section}}

% Double-space overall
\usepackage[doublespacing]{setspace}

% Rename the ToC
\RequirePackage[subfigure,titles]{tocloft}
\renewcommand{\contentsname}{Table of Contents}

% Remove parskips from toc/lof/lot
\setlength{\cftparskip}{0pt}


\RequirePackage{xpatch}

% Single space ToC
\xpretocmd{\tableofcontents}{%
	\begin{singlespace}}{}{}
\xapptocmd{\tableofcontents}{%
	\end{singlespace}}{}{}

% Put the List of Figures in the ToC
% and single space it
\xpretocmd{\listoffigures}{%
	\phantomsection%
	\addcontentsline{toc}{chapter}{List of Figures}%
	\begin{singlespace}}{}{}
\xapptocmd{\listoffigures}{%
	\end{singlespace}}{}{}

% Put the List of Tables in the ToC,
% and single space it.
\xpretocmd{\listoftables}{%
	\phantomsection%
	\addcontentsline{toc}{chapter}{List of Tables}%
	\begin{singlespace}}{}{}
\xapptocmd{\listoftables}{%
	\end{singlespace}}{}{}

% \RequirePackage{xpatch}
% \xpatchcmd{\@chapter}
	% {{\protect\numberline{\thechapter}#1}}
	% {{\protect\numberline{\thechapter} MEGATEST! \texorpdfstring{\MakeUppercase{#1}}{#1}}}
	% {}{}

%\renewcommand{\titlepage}{}
%%% PACKAGES
%\usepackage{booktabs} % for much better looking tables
%\usepackage{array} % for better arrays (eg matrices) in maths
%\usepackage{paralist} % very flexible & customisable lists (eg. enumerate/itemize, etc.)
%\usepackage{verbatim} % adds environment for commenting out blocks of text & for better verbatim
%\usepackage{subfig} % make it possible to include more than one captioned figure/table in a single float
% These packages are all incorporated in the memoir class to one degree or another...


\endinput
%%% HEADERS & FOOTERS
%\usepackage{fancyhdr} % This should be set AFTER setting up the page geometry
%\pagestyle{fancy} % options: empty , plain , fancy
%\renewcommand{\headrulewidth}{0pt} % customise the layout...
%\lhead{}\chead{}\rhead{}
%\lfoot{}\cfoot{\thepage}\rfoot{}

%%% SECTION TITLE APPEARANCE
%\usepackage{sectsty}
%\allsectionsfont{\sffamily\mdseries\upshape} % (See the fntguide.pdf for font help)
% (This matches ConTeXt defaults)

%%% ToC (table of contents) APPEARANCE
%\usepackage[nottoc,notlof,notlot]{tocbibind} % Put the bibliography in the ToC
%\usepackage[titles,subfigure]{tocloft} % Alter the style of the Table of Contents
%\renewcommand{\cftsecfont}{\rmfamily\mdseries\upshape}
%\renewcommand{\cftsecpagefont}{\rmfamily\mdseries\upshape} % No bold!
