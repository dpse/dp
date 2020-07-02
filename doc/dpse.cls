\ProvidesClass{dpse}[2020/07/02 DPSE document class]
\NeedsTeXFormat{LaTeX2e}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}

\newif\ifdpse@watermark
\DeclareOption{watermark}{\dpse@watermarktrue}

\newif\ifdpse@sans
\DeclareOption{sans}{\dpse@sanstrue}

\newif\ifdpse@nosans
\DeclareOption{nosans}{\dpse@nosanstrue}

\newif\ifdpse@notikzsans
\DeclareOption{notikzsans}{\dpse@notikzsanstrue}

\newif\ifdpse@sanstables
\DeclareOption{sanstables}{\dpse@sanstablestrue}

\newif\ifdpse@twoside
\DeclareOption{twoside}{\dpse@twosidetrue}

\newif\ifdpse@final
\DeclareOption{final}{\dpse@finaltrue}

\newif\ifdpse@parskip
\DeclareOption{parskip}{\dpse@parskiptrue}

\newif\ifdpse@nomath
\DeclareOption{nomath}{\dpse@nomathtrue}

\newif\ifdpse@git
\DeclareOption{git}{\dpse@gittrue}

\ProcessOptions \relax

\LoadClass{memoir}

% Additions
%\RequirePackage{etex}
%\reserveinserts{28}
\RequirePackage{memhfixc}
\RequirePackage{etoolbox,xpatch}
\RequirePackage{xifthen}
\RequirePackage{ifpdf,ifxetex,ifluatex}
\RequirePackage{shellesc}
\RequirePackage[l2tabu, orthodox]{nag}

\ifluatex
\else\ifxetex
	\else
		\PackageError{dpse}{ *** Compile with LuaTeX or XeTex instead! *** ^^J}{}
	\fi
\fi

% Git
\ifdpse@git
	\RequirePackage{latexgit}
\fi

\newcommand{\ifempty}[3]{%
	\ifthenelse{\isempty{#1}}{#2}{#3}%
}

% Add missing definitions if running LuaTeX (needed by marginfit package)
\ifluatex
\let\pdfpagewidth\pagewidth
\let\pdfpageheight\pageheight
\let\pdfadjustspacing\adjustspacing
\let\pdfprotrudechars\protrudechars
\let\pdfnoligatures\ignoreligaturesinfont
\let\pdffontexpand\expandglyphsinfont
\let\pdfcopyfont\copyfont
\let\pdfxform\saveboxresource
\let\pdflastxform\lastsavedboxresourceindex
\let\pdfrefxform\useboxresource
\let\pdfximage\saveimageresource
\let\pdflastximage\lastsavedimageresourceindex
\let\pdflastximagepages\lastsavedimageresourcepages
\let\pdfrefximage\useimageresource
\let\pdfsavepos\savepos
\let\pdflastxpos\lastxpos
\let\pdflastypos\lastypos
\let\pdfoutput\outputmode
\let\pdfdraftmode\draftmode
\let\pdfpxdimen\pxdimen
\let\pdfinsertht\insertht
\let\pdfnormaldeviate\normaldeviate
\let\pdfuniformdeviate\uniformdeviate
\let\pdfsetrandomseed\setrandomseed
\let\pdfrandomseed\randomseed
\let\pdfprimitive\primitive
%\let\ifpdfprimitive\ifprimitive
\let\ifpdfabsnum\ifabsnum
\let\ifpdfabsdim\ifabsdim
	\newdimen\pdfeachlineheight
	\newdimen\pdfeachlinedepth
	\newdimen\pdflastlinedepth
	\newdimen\pdffirstlineheight
	\newdimen\pdfignoreddimen
\fi

% Math
\RequirePackage{amsmath, amsthm} % AMS Enhanced math support
\RequirePackage{mathtools}
\RequirePackage[all,warning]{onlyamsmath}
\RequirePackage{physics}
\RequirePackage{thmtools}

% Patch list of theorems
\xpatchcmd{\listoftheorems}
{\let\thref@starttoc\@starttoc}
{%
	\@for\thmt@envname:=\thmt@allenvs\do{%
		\@xa\let\csname l@\thmt@envname\endcsname\l@figure
	}%
	\let\cftfigurenumwidth\thmt@listnumwidth
	\let\thref@starttoc\@starttoc
}{}{}

% Units and Numbers
\RequirePackage{numprint,nicefrac}
\RequirePackage[detect-all]{siunitx}
\sisetup{range-phrase=--,range-units=single,per-mode=symbol,text-celsius,
	inter-unit-product = \ensuremath{{}\cdot{}}, separate-uncertainty, %unit-mode=text, 
	quotient-mode = fraction,fraction-function=\nicefrac}
\DeclareSIUnit\micron{\micro\metre}
\newcommand*{\angRange}[2]{\SIrange[range-units=repeat]{#1}{#2}{\degree}}

% Encoding and Language
\RequirePackage[english]{babel}

% Layout
\RequirePackage{geometry}
%\RequirePackage{lastpage}
\RequirePackage[absolute,overlay]{textpos}
\RequirePackage{marginfit}
\RequirePackage{ragged2e}
\RequirePackage{mdframed}

% Code formatting
\RequirePackage{fancyvrb}
\ifxetex
	\@namedef{ver@framed.sty}{9999/12/31} % Avoid loading framed twice because of collision
	\@namedef{opt@framed.sty}{}%
	% \@namedef{ver@float.sty}{99999/12/31}%
\fi
\ifcsname tikzexternalrealjob\endcsname
	\RequirePackage[newfloat,draft]{minted}
\else
	\RequirePackage[newfloat,cache]{minted}
\fi
\usemintedstyle{pastie}
\setminted{ %
	linenos=true,             % Line numbers
	autogobble=true,          % Automatically remove common white space
	frame=lines,
	framesep=2mm,
	fontsize=\footnotesize
}

% Graphics and Colour
\RequirePackage{graphicx}
\RequirePackage[usenames,dvipsnames]{xcolor}
\RequirePackage{xcoffins}
\RequirePackage{rotating}
%\RequirePackage{float}
\let\newfloat\undefined
\RequirePackage{floatrow}
\floatsetup[widefigure]{facing=yes,capposition=beside,capbesidesep=quad,margins=hangoutside,facing=yes,capbesideposition={outside,center}}
\RequirePackage[maxfloats=30]{morefloats}
\RequirePackage{wrapfig}
\RequirePackage[some]{background}
\RequirePackage[export]{adjustbox}
\ifdpse@watermark
	\RequirePackage[stamp]{draftwatermark}
	% Draft watermark
	\SetWatermarkText{\ttfamily DRAFT}
	\SetWatermarkScale{0.75}
	\SetWatermarkLightness{0.9}
\fi

% Tikz
\RequirePackage{tikz,pgfplots,tikzscale,tikz-layers}
\usetikzlibrary{calc,babel,fit,positioning,arrows,shapes}
\tikzset{>=latex}
\pgfplotsset{width=0.9\linewidth,compat=newest,colormap name=viridis,grid=both,
	every axis plot/.append style={thick},
	every x tick scale label/.style={
			at={(1,0)},xshift=1pt,anchor=south west,inner sep=0pt
		}}

% Tables and Enums
\RequirePackage{array,multirow,multicol}
\RequirePackage{booktabs,threeparttable}
\RequirePackage{tabu,longtable}
\RequirePackage{enumitem}

% Captions
\RequirePackage[font={small},labelfont={bf},singlelinecheck=true]{caption} %format=hang
\setlength{\abovecaptionskip}{0.5\onelineskip}
\setlength{\belowcaptionskip}{0.5\onelineskip}

% Indexing
\RequirePackage{idxlayout}

\newcommand{\idxbf}[1]{\textbf{\hyperpage{#1}}}
\newcommand{\idxit}[1]{\textbf{\hyperpage{#1}}}

\newcommand{\doidxbookmark}[1]{{
			\textbf{\color{accentcolor}#1}%
			\phantomsection%
			\pdfbookmark[1]{#1}{#1-idx}
			\vskip 0.5ex\par}}

% Override for xindy
\providecommand*\lettergroupDefault[1]{}
\providecommand*\lettergroup[1]{%
	\par\textbf{\color{accentcolor}#1}%
	\phantomsection%
	\pdfbookmark[1]{#1}{#1-idx}%
	\par
	\nopagebreak
}

% Typography
\ifluatex
	\RequirePackage[protrusion=true,expansion=true,tracking=true]{microtype}
\else\ifxetex
		\RequirePackage[protrusion=true]{microtype}
	\else
		\RequirePackage[protrusion=true,expansion=true,kerning=true,spacing=true,tracking=true]{microtype}
	\fi\fi
%\RequirePackage[protrusion=true, expansion=true, tracking=true, kerning=true, spacing=true]{microtype}
\RequirePackage[all]{nowidow} %Try to avoid widows
\RequirePackage{lettrine}
%\renewcommand*{\LettrineFontHook}{\initialsfont\color{accentcolor}}
\RequirePackage{fnpct}

\ifdpse@parskip
	\nonzeroparskip
	\setlength{\parindent}{0pt}
\fi

% Lanugages
\newcommand*{\newlang}[2]{%
	\newtoggle{#1}%
	\newcommand{#2}[1]{\iftoggle{#1}{##1}{}}%
}
\newcommand*{\setlang}[1]{\toggletrue{#1}}

% Miscellaneous
%\RequirePackage{todonotes}

% Localization
\RequirePackage[useregional]{datetime2}
\RequirePackage[autostyle=true]{csquotes}

%\renewcommand*{\dateseparator}{-}
%\newcommand*{\todayiso}{\the\year \dateseparator \twodigit\month \dateseparator \twodigit\day}

% PDF
\RequirePackage[hyphens]{url}
\RequirePackage{pdflscape} %Landscape mode
%\RequirePackage[novbox]{pdfsync} %Pdf sync
\RequirePackage{bookmark}
%\AtEndOfClass{\RequirePackage{hyperref}}
\RequirePackage{hyperref}
\RequirePackage[capitalise,nameinlink]{cleveref}
\hypersetup{colorlinks=false}

% Must load imakeidx after hyperref
\RequirePackage[xindy]{imakeidx}

% References
\RequirePackage[backend=biber]{biblatex} %,style=authortitle
%\RequirePackage[round]{natbib}

% Glossaries TODO figure out how to pass options elsewhere
\RequirePackage[record,symbols,nomain,automake,xindy]{glossaries-extra}

% Fonts
\ifluatex
	%\RequirePackage[quiet,no-math]{fontspec}
	\RequirePackage[quiet,no-math]{fontspec}
	%\RequirePackage[italic]{mathastext}
	%\RequirePackage{unicode-math}
	%\unimathsetup{math-style=TeX}
\else\ifxetex
		\RequirePackage[quiet,MnSymbol]{mathspec}
	\fi\fi
%\RequirePackage{sansmath} %Sans serif if math mode
\RequirePackage{realscripts}

\defaultfontfeatures{
	Ligatures={TeX,Common},
	%Ligatures={TeX,Required,Common,Contextual}, 
	Numbers={OldStyle,Proportional},
	%Contextuals={Swash,WordInitial,Inner,LineFinal},
	SmallCapsFeatures={LetterSpace=6}
}
\defaultfontfeatures+[Minion 3]{
	SizeFeatures={%
			{Size={-8.4},Font=* Caption},
	{Size={8.4-13},Font=*},
{Size={13-19.9},Font=* Subhead},
{Size={19.9-},Font=* Display}
},
%BoldFont={*-Bold},
%BoldItalicFont={*-BoldItalic}
}
\defaultfontfeatures+[Cronos]{
	SizeFeatures={%
			{Size={-8.4},Font=* Caption},
	{Size={8.4-13},Font=*},
{Size={13-19.9},Font=* Subhead},
{Size={19.9-},Font=* Display}
},
%BoldFont={* Bold},
%BoldItalicFont={* Bold Italic}
}
\defaultfontfeatures+[Fira Code]{
	Contextuals=Alternate
}

\newcommand*{\mainfont}{Minion 3}
\newcommand*{\sansfont}{Cronos Pro}
\newcommand*{\monofont}{Fira Code}

\ifdpse@sans
	\renewcommand{\mainfont}{\sansfont}
\fi

\ifdpse@nomath
\else
	\ifxetex
		\setmathsfont(Digits,Latin,Greek)[Numbers={Lining,Proportional}]{\mainfont}
	\else\ifluatex
			%\setmathfont[Numbers={Lining,Proportional}]{\mainfont}
		\fi\fi
	\setmathrm[Numbers={Lining,Proportional}]{\mainfont}
	\setmathsf[Numbers={Lining,Proportional}]{\sansfont}
	\setmathtt[Numbers={Lining,Proportional}]{\monofont}
\fi

\setmainfont{\mainfont}
\setsansfont{\sansfont}
\setmonofont{\monofont}

\ifluatex
	\RequirePackage[LGRgreeks,italic]{mathastext}
	\RequirePackage{MnSymbol}
\fi

\newfontfamily\poetica{Poetica Std}[%
	ItalicFeatures={Style=Swash},
	Ligatures={TeX,Common,Rare}
]

%\newcommand{\swshape}{\itshape\addfontfeatures{ItalicFeatures={Style=Swash},Contextuals={Alternate},Ligatures={Rare}}}
%\newcommand{\textsw}[1]{{\swshape #1}}
\newcommand*{\fraction}[1]{{\addfontfeatures{Fractions=On}#1}}
%\newcommand*{\newfrac}[2]{\fraction{#1/#2}}
%\sisetup{fraction-function=\newfrac}
\newcommand{\oldstyle}{\addfontfeatures{Numbers={OldStyle,Proportional}}}
\newcommand{\lining}{\addfontfeatures{Numbers={Lining,Proportional}}}
\newcommand{\monospaced}{\addfontfeatures{Numbers={Monospaced}}}
\newcommand*{\fleuron}{\symbol{\string"2766}}
\newcommand*{\fleuronr}{\symbol{\string"2767}}
\newcommand*{\et}{{\itshape\&}}

% Define colors
\definecolor{accentcolor}{cmyk}{.2,1,0.5,.15}
\definecolor{accentgray}{cmyk}{0,1,.66,.42}

% Default page layout
\semiisopage[7]
\ifdpse@twoside
	\setlrmargins{*}{*}{1.618} %TODO FIX
\else
	\setlrmargins{*}{*}{*}
\fi

% Try to avoid orphans and widows
\setlength{\topskip}{1.6\topskip}

% Check and fix layout
\checkandfixthelayout

% Allow bottom stretching
\sloppybottom

% Strict check for marginpars
\strictpagecheck

% Set new penalties for orphans and widows
\clubpenalty=9996
\widowpenalty=9999
\brokenpenalty=4991
\predisplaypenalty=10000
\postdisplaypenalty=1549
\displaywidowpenalty=1602

% Default styles
\headstyles{bringhurst}

\newcommand*{\raisedrulefill}[2][0ex]{\leaders\hbox{\rule[#1]{1pt}{#2}}\hfill}

\NewCoffin\main
\NewCoffin\titleline
\NewCoffin\chapternumber
\makechapterstyle{Bringhurst}{%
	\chapterstyle{reparticle}
	\renewcommand*{\chaptitlefont}{%
		\normalfont% \sffamily\bfseries
		\addfontfeatures{LetterSpace=12}%
		\Large
	}
	\renewcommand*{\chapnumfont}{\poetica\addfontfeatures{LetterSpace=12}\LARGE\textcolor{black!50}}
	%\renewcommand*\chapterheadstart{}
	\renewcommand*\printchaptername{}
	\renewcommand*\chapternamenum{}
	\renewcommand*\afterchapternum{}
	\renewcommand*\printchapternum{%
		\SetHorizontalCoffin\chapternumber{%
			\chapnumfont{\thechapter}%
		}%
		\ScaleCoffin\chapternumber{8}{8}%
	}
	\renewcommand*\printchapternonum{\SetHorizontalCoffin\chapternumber{}}
	\renewcommand*\printchaptertitle[1]{\memRTLraggedright\chaptitlefont\MakeTextUppercase{##1}}
	%\setlength\beforechapskip{-\baselineskip}
	\setlength{\afterchapskip}{\baselineskip}
	\renewcommand*\afterchaptertitle{%
		\par\nobreak\vskip.5\onelineskip
		\SetHorizontalCoffin\titleline{\color{black}\rule{\textwidth}{0.5pt}}%
		\JoinCoffins\main\titleline
		\JoinCoffins*\main\chapternumber(\textwidth+\marginparsep+\baselineskip,-4\baselineskip)%
		\TypesetCoffin\main
		\par\nobreak\vskip \afterchapskip
	}
}

\makechapterstyle{dpse}{%
	\chapterstyle{reparticle}
	\renewcommand*{\chaptitlefont}{\normalfont\huge\bfseries\sffamily\addfontfeatures{Numbers=Lining}\color{accentcolor}}
	\renewcommand*{\chapnumfont}{\chaptitlefont}
	\renewcommand*{\printchaptertitle}[1]{\chaptitlefont ##1\hskip 0.5ex\raisedrulefill[0.5ex]{1pt}\hskip 0pt}
}

\makechapterstyle{Bringhurst-custom}{%
	\chapterstyle{Bringhurst}
	\renewcommand*{\chapnumfont}{\poetica\addfontfeatures{LetterSpace=12}\LARGE\color{accentcolor}}
}

% Default chapter style
\chapterstyle{Bringhurst-custom}

% Table of contents style
\renewcommand*{\cftchapterfont}{\scshape}
\renewcommand*{\cftchapterpagefont}{\scshape}
\renewcommand*{\cftchapterpresnum}{\addfontfeatures{Numbers=Lining}\color{accentcolor}}
\renewcommand*{\cftchapteraftersnum}{\color{black}}
\renewcommand*{\cftfigurefont}{\small}
\renewcommand*{\cfttablefont}{\small}

\newcommand\footer[1]{\renewcommand\@footer{#1}}
\newcommand\@footer{}

\newcommand\header[1]{\renewcommand\@header{#1}}
\newcommand\@header{}

\ifdpse@git
	\footer{auth: \gitcommitauthor}
	\header{\gitcommithash \gitcommitdate}
\fi

% Fancy headers
\copypagestyle{dpse}{ruled}
\makeevenfoot {dpse}{\thepage}{\small\@footer}{\small\DTMsetstyle{iso}\today} % page numbers at the outside
\makeoddfoot  {dpse}{\small\DTMsetstyle{iso}\today}{\small\@footer}{\thepage}
\makeevenhead {dpse}{\scshape\leftmark}{\small\@header}{\includegraphics[height=9pt]{logo.eps}} % small caps
\makeoddhead  {dpse}{\includegraphics[height=9pt]{logo.eps}}{\small\@header}{\rightmark}
\ifdpse@twoside
\else
	\makeoddhead  {dpse}{\includegraphics[height=9pt]{logo.eps}}{\small\@header}{\leftmark}
\fi

% Plain style for chapter openings
\copypagestyle{dpse-plain}{dpse}
\makeheadrule{dpse-plain}{\textwidth}{0pt}
\makeevenhead{dpse-plain}{}{\small\@header}{}
\makeoddhead{dpse-plain}{}{\small\@header}{}

\ifartopt
	\aliaspagestyle{chapter}{dpse}
\else
	\aliaspagestyle{chapter}{dpse-plain}
\fi

\pagestyle{dpse}

% Italic descriptions
\setlist[description]{font=\normalfont\itshape}

% Patch memoir margin footnotes for custom series
\renewcommand{\m@make@footnotetext}[1]{%
\@namelongdef{@footnotetext#1}##1{%
\ifm@mfnmargin
	\marginpar{%
		\def\baselinestretch{\m@m@footnote@spacing}% 
		\reset@font\@nameuse{foottextfont#1}%
		\protected@edef\@currentlabel{%
			\csname p@footnote#1\endcsname\@nameuse{@thefnmark#1}}% 
		\color@begingroup
		\@nameuse{@makefntext#1}{%
			\ignorespaces{\@nameuse{foottextfont#1}##1}}% <- v1.6180339a
		\color@endgroup}%
\else
	\insert\@nameuse{footins#1}{%
		\def\baselinestretch{\m@m@footnote@spacing}% 
		\reset@font\@nameuse{foottextfont#1}%
		\@preamfntext
		\hsize\columnwidth
		\protected@edef\@currentlabel{%
			\csname p@footnote#1\endcsname\@nameuse{@thefnmark#1}}% 
		\color@begingroup
		\@nameuse{@makefntext#1}{%
			\rule\z@\footnotesep\ignorespaces{\@nameuse{foottextfont#1}##1}% <- v1.6180339a
			\@finalstrut\strutbox}%
		\color@endgroup}%
\fi%
\m@mmf@prepare}}

% Footnotes styling
\newfootnoteseries{sym}
\renewcommand*{\thefootnotesym}{\fnsymbol{footnotesym}}
%\renewcommand*{\thefootnote}{\fnsymbol{footnote}}
\footnotesinmargin

% Break ling URLs
\expandafter\def\expandafter\UrlBreaks\expandafter{\UrlBreaks%
	\do\a\do\b\do\c\do\d\do\e\do\f\do\g\do\h\do\i\do\j%
	\do\k\do\l\do\m\do\n\do\o\do\p\do\q\do\r\do\s\do\t%
	\do\u\do\v\do\w\do\x\do\y\do\z\do\A\do\B\do\C\do\D%
	\do\E\do\F\do\G\do\H\do\I\do\J\do\K\do\L\do\M\do\N%
	\do\O\do\P\do\Q\do\R\do\S\do\T\do\U\do\V\do\W\do\X%
	\do\Y\do\Z}

\ifdpse@nosans
\else

	\ifdpse@notikzsans
	\else
		% Tikz label styles
		\tikzset{every picture/.style={/utils/exec={\sffamily}}}
		\pgfplotsset{
			compat=newest,
			tick label style = {font=\scriptsize\sansmath\sffamily},
			every axis label = {font=\scriptsize\sansmath\sffamily},
			legend style = {font=\footnotesize\sansmath\sffamily},
			label style = {font=\small\sansmath\sffamily},
			every x tick scale label/.style={
					at={(1,0)},xshift=1pt,anchor=south west,inner sep=0pt
				}
		}
	\fi

	% Sans serif captions
	\captionnamefont{\small\bfseries\sffamily}
	\captiontitlefont{\small\sffamily}
	\captionsetup{font={small,sf}}
\fi

% Sans serif tables automatically
\ifdpse@sanstables
	\renewenvironment{table}%
	{\renewcommand*{\familydefault}{\sfdefault}\small\selectfont
		\@float{table}}
	{\end@float}
\fi

% Margin captions
\setmarginfloatcaptionadjustment{figure}{\footnotesize}
\setmarginfloatcaptionadjustment{table}{\footnotesize}
\sidecapmargin{outer}
\renewcommand{\sideparfont}{\footnotesize}

% Default float placement
\setfloatlocations{figure}{htbp}
\setfloatlocations{table}{htbp}

% This command computes and creates a vertical space
% depending on the number of rows to compensate for.
% It makes use of the counter verticalcompensationrows
% and the length \verticalcompensationlength which equals
% \aboverulesep plus \belowrulesep
\newlength{\verticalcompensationlength}
\setlength{\verticalcompensationlength}{\aboverulesep}
\addtolength{\verticalcompensationlength}{\belowrulesep}
\newcounter{verticalcompensationrows}
\newcommand{\verticalcompensation}[1]{%
	\setcounter{verticalcompensationrows}{#1}%
	\addtocounter{verticalcompensationrows}{-1}%
	\vspace*{-\value{verticalcompensationrows}\verticalcompensationlength}%
}

% Fix spacing issues in tables with multirow and booktabs
\newlength{\vc}
\setlength{\vc}{-\belowrulesep}
% USAGE:
%\multicolumn{1}{c}{\multirow{2}{*}[\vc]{\centering TEXT}}

% Center figures vertically on empty pages
\setlength{\@fptop}{0pt plus 1fil}
\setlength{\@fpbot}{0pt plus 1fil}

% Prevent page breaks before lists
\@beginparpenalty=\@highpenalty

% Prevent incorrect hyphenation and uneven right margin
\emergencystretch=\maxdimen

% Setup mdframed
\mdfsetup{%
	skipabove=\topskip,skipbelow=\topskip,%
	linecolor=black,linewidth=1pt,%
	leftmargin=1em,rightmargin=1em,%
	innertopmargin=1em,innerbottommargin=1em,%
	innerleftmargin=2em,innerrightmargin=2em,
	topline=false,bottomline=false,%
	backgroundcolor=gray!5}
\mdfdefinestyle{frame}{}
\mdfdefinestyle{accent-frame}{linecolor=accentcolor}
\mdfdefinestyle{red-frame}{linecolor=red!50!black}
\mdfdefinestyle{green-frame}{linecolor=green!50!black}
\mdfdefinestyle{blue-frame}{linecolor=blue!50!black}

% MDF surroundings
\surroundwithmdframed[style=accent-frame]{note}
\surroundwithmdframed[style=green-frame]{example}
\surroundwithmdframed[style=blue-frame]{formula}

% Theorem titles
\newcommand*{\formulatitle}{Formula}
\newcommand*{\notetitle}{Note}
\newcommand*{\exampletitle}{Example}

% Theorem styles
\declaretheoremstyle[%
	spaceabove=-\topsep,
	spacebelow=0pt,
	notebraces={(}{)},
	headfont=\sffamily\scshape\bfseries\color{accentcolor},
	notefont=\mdseries\upshape,
	bodyfont=\normalfont\swshape,
	postheadspace=1ex,
	numberwithin=chapter,
	headpunct={},
	headindent=-1em,
]{note}
\declaretheoremstyle[%
	spaceabove=-\topsep,
	spacebelow=0pt,
	notebraces={(}{)},
	headfont=\sffamily\scshape\bfseries\color{green!50!black},
	notefont=\mdseries\upshape,
	bodyfont=\normalfont\swshape,
	postheadspace=1ex,
	numberwithin=chapter,
	headpunct={},
	headindent=-1em,
]{example}
\declaretheoremstyle[%
	spaceabove=-\topsep,
	spacebelow=0pt,
	notebraces={(}{)},
	headfont=\sffamily\scshape\bfseries\color{blue!50!black},
	notefont=\mdseries\upshape,
	bodyfont=\normalfont\swshape,
	postheadspace=1ex,
	numberwithin=chapter,
	headpunct={},
	headindent=-1em,
]{formula}

% Declare theorems
\declaretheorem[%
	style=note,
	name=\notetitle,
]{note}
\declaretheorem[%
	style=example,
	name=\exampletitle,
]{example}
\declaretheorem[%
	style=formula,
	name=\formulatitle,
]{formula}

% Remove page number if only one page
\AtEndDocument{\ifnum\value{lastsheet}=1\thispagestyle{empty}\fi}

% Todo notes in margin
% Hidden if final option is specified
\ifdpse@final
	\newcommand{\todonote}[1]{\@bsphack\@esphack}
\else
	\newlength{\todonotewidth}
	\newlength{\todonotesignwidth}
	\newcommand{\todonote}[1]{\@bsphack%
		{%% do not interfere with settings for other marginal notes
			\strictpagecheck%
			\checkoddpage%
			\setlength{\todonotewidth}{\foremargin}%
			\addtolength{\todonotewidth}{\trimedge}%
			\addtolength{\todonotewidth}{-3\marginparsep}%
			\ifoddpage
				\setlength{\marginparwidth}{\todonotewidth}%
				\marginpar{\flushleft\textbf{\textit{\HUGE !\ }}\small #1}%
			\else
				\settowidth{\todonotesignwidth}{\textbf{\textit{\HUGE\ !}}}%
				\addtolength{\todonotewidth}{-\todonotesignwidth}%
				\marginpar{\raggedleft\makebox[0pt][r]{%% hack around
						\parbox[t]{\todonotewidth}{%%%%%%%%% funny behaviour
							\raggedleft\small\hspace{0pt}#1%
						}}\textbf{\textit{\HUGE\ !}}%
				}%
			\fi
		}\@esphack}
\fi

% Rename abstract and use sans serif
\addto{\captionsenglish}{\renewcommand*{\abstractname}{Summary}}
\renewcommand*{\abstractnamefont}{\large\sffamily}
\renewcommand*{\abstracttextfont}{\small\sffamily}

% Section and TOC depth
\setsecnumdepth{subsection}
\maxtocdepth{subsection}

% Listing counter depth
\counterwithin{listing}{chapter}

% Titling page
\newcommand\subtitle[1]{\renewcommand\@subtitle{#1}}
\newcommand\@subtitle{}

\newcommand\image[1]{\renewcommand\@image{#1}}
\newcommand\@image{}

\newcommand\summary[1]{\renewcommand\@summary{#1}}
\newcommand\@summary{}

\newlength{\@titlepageblockwidth}
\setlength{\@titlepageblockwidth}{\paperwidth-2\spinemargin}
\renewcommand*{\maketitle}{%
	\backgroundsetup{
		scale=1,
		angle=0,
		opacity=1,
		contents={\begin{tikzpicture}[remember picture,overlay]
					\path [fill=accentcolor] (-0.5\paperwidth,4) rectangle (0.5\paperwidth,0.5\paperheight);
					\draw [color=white, very thick] (-0.5\paperwidth+\spinemargin+\textwidth,4)--(-0.5\paperwidth+\spinemargin+\textwidth,0.5\paperheight);
					\node[inner sep=0pt, anchor=south] (logo) at (0,0.5\paperheight-\uppermargin-\textheight)
					{\includegraphics[width=5cm]{logo.eps}};
				\end{tikzpicture}}
	}
	\begin{titlingpage}
		\BgThispage
		\sffamily
		\noindent\begin{textblock*}{\textwidth}
			(\spinemargin,\uppermargin)%
			\noindent\begin{minipage}{\textwidth}%
				\ifdefempty{\@title}{}{%
					\noindent\textcolor{white}{\setDisplayskipStretch{5}\fontsize{40}{48}\selectfont\@title}
					\ifdefempty{\@subtitle}{}{%
						\vspace*{1cm}\par
					}
				}%
				\ifdefempty{\@subtitle}{}{%
					\noindent\textcolor{white}{\Huge{\scshape\@subtitle}}
				}
			\end{minipage}
		\end{textblock*}%
		\begin{textblock*}{\@titlepageblockwidth}
			(\spinemargin,0.45\paperheight)%
			\noindent\begin{minipage}{\@titlepageblockwidth}
				\noindent\begin{minipage}{0.3\@titlepageblockwidth}
					\begin{flushright}
						{\large\@author\\[1em]\@date}
					\end{flushright}
				\end{minipage}
				%
				\noindent\begin{minipage}{0.05\@titlepageblockwidth}
					\centering\rule{1pt}{175pt}
				\end{minipage}
				%
				\noindent\begin{minipage}{0.65\@titlepageblockwidth}
					\ifdefempty{\@image}{}{%
						\centering\noindent\@image
					}%
					\ifdefempty{\@summary}{}{%
						\begin{abstract}
							\noindent\@summary
						\end{abstract}
					}%
				\end{minipage}
			\end{minipage}%
		\end{textblock*}%
		\mbox{}
	\end{titlingpage}
}

% Back cover
\newcommand*{\makebackcover}{%
	\backgroundsetup{
		scale=1,
		angle=0,
		opacity=1,
		contents={\begin{tikzpicture}[remember picture,overlay]
					\path [fill=accentcolor] (-0.5\paperwidth,4) rectangle (0.5\paperwidth,0.5\paperheight);
					\draw [color=white, very thick] (0.5\paperwidth-\spinemargin-\textwidth,4)--(0.5\paperwidth-\spinemargin-\textwidth,0.5\paperheight);
					\node[inner sep=0pt] (logo) at (0,-0.2\paperheight)
					{\includegraphics[width=10cm]{logo.eps}};
				\end{tikzpicture}}
	}
	\cleartoverso
	\thispagestyle{empty}
	\BgThispage
	\mbox{}
}

% Image annotation commands
\newcounter{@annotation}
\newenvironment{annotatedimage}[2][]{%
	\setcounter{@annotation}{0}
	\begin{tikzpicture}
		\node[anchor=south west,inner sep=0] (image) at (0,0) {#2}
		;
		\begin{scope}[x={(image.south east)},y={(image.north west)}]
			\ifstrequal{#1}{grid}{%
				\draw[help lines,xstep=.1,ystep=.1] (0,0) grid (1,1);
				\foreach \x in {0,1,...,9} { \node [anchor=north] at (\x/10,0) {0.\x}; }
				\foreach \y in {0,1,...,9} { \node [anchor=east] at (0,\y/10) {0.\y}; }
			}{}
			}{%
		\end{scope}
	\end{tikzpicture}
}

\newcommand{\annotate}[6][0,0]{%
	\draw[accentcolor,thick,rounded corners,fill=black,fill opacity=0.1] (#2,#3) rectangle (#4,#5);
	\begin{scope}[on above layer]
		\node[draw=accentcolor,thick,fill=white,rounded corners,inner sep=1mm,text=accentcolor,shift={(#1)}] at (#4,#3) {\refstepcounter{@annotation}#6\bfseries\scriptsize\arabic{@annotation}};
	\end{scope}
}

\newenvironment{annotationlegend}[1][3]{%
	\begin{multicols}{#1}
		\begin{itemize}
			\firmlist\sffamily\small
			}{%
		\end{itemize}
	\end{multicols}
}

% New column types
\newcolumntype{L}[1]{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}
\newcolumntype{C}[1]{>{\centering\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}
\newcolumntype{R}[1]{>{\raggedleft\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}

% Quick-start environment
\newcounter{@qscounter}

\newenvironment{quickstart}{%
	\setcounter{@qscounter}{0}
	\tabulinesep=2pt}{}

\newcommand{\qsitem}[2]{%
	\tabcolsep=0pt
	\begin{tabu}{lc}
		\tabcolsep=1ex
		\begin{tabu} to 0.85\textwidth [c]{@{\extracolsep{-1ex}}R{1.5em}X}
			\stepcounter{@qscounter}\arabic{@qscounter}. & #1 \\
		\end{tabu} & \ifempty{#2}{\hspace*{0.08\textwidth}\hspace*{2ex}}{\includegraphics[width=0.08\textwidth,valign=c,padding=1ex 0.5ex 1ex 0.5ex]{#2}} \\
	\end{tabu}}

% Code environment (multi-page listing)
\newenvironment{code}{\captionsetup{type=listing}}{}

% Command for printing open type alts
\newcommand*{\printalternates}[1]{%
	{#1}\hspace{1ex}%
	{\addfontfeatures{Alternate=1}#1}\hspace{1ex}%
	{\addfontfeatures{Alternate=2}#1}\hspace{1ex}%
	{\addfontfeatures{Alternate=3}#1}\hspace{1ex}%
	{\addfontfeatures{Alternate=4}#1}\hspace{1ex}%
	{\addfontfeatures{Alternate=5}#1}\hspace{1ex}%
	{\addfontfeatures{Alternate=6}#1}\hspace{1ex}%
	{\addfontfeatures{Alternate=7}#1}\hspace{1ex}%
	{\addfontfeatures{Alternate=8}#1}\hspace{1ex}%
	{\addfontfeatures{Alternate=9}#1}\hspace{1ex}%
	{\addfontfeatures{Alternate=10}#1}\hspace{1ex}%
	{\addfontfeatures{Alternate=11}#1}\hspace{1ex}%
	{\addfontfeatures{Alternate=12}#1}\hspace{1ex}%
	{\addfontfeatures{Alternate=13}#1}\hspace{1ex}%
	{\addfontfeatures{Alternate=14}#1}\hspace{1ex}%
	{\addfontfeatures{Alternate=15}#1}}

% Define new line style for pgfplots
\pgfplotscreateplotcyclelist{color linestyles*}{
	red, solid\\
	blue, dashed\\
	black, dotted\\
	yellow, dashdotted\\
	brown, dashdotdotted\\
	teal, solid\\
	orange, dashed\\
	violet, dotted\\
	cyan, dashdotted\\
	green!70!black, dashdotdotted\\
	magenta, solid\\
	gray, dashed\\
}