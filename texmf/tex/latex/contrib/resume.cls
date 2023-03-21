%
% resume.cls
%
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{resume}[2003/10/12 v0.1 Resume document class]
\RequirePackage{randtext}
\usepackage{strings}
\def\centerline#1{\noindent\hfil\hbox{#1}\par}
\def\lrlinefrac#1#2#3{%
    \noindent
    \@tempdima=#3\hsize
    \@tempdimb=\hsize \advance\@tempdimb-\@tempdima
    \vtop{\hsize\@tempdimb \rightskip\fill#1}\hfill
    \vtop{\hsize\@tempdima \leftskip\fill #2}\par
}%
\def\lrlinedim#1#2#3{%
    \noindent
    \@tempdima=#3\relax
    \@tempdimb=\hsize \advance\@tempdimb-\@tempdima
    \vtop{\hsize\@tempdimb \rightskip\fill#1}\hfill
    \vtop{\hsize\@tempdima \leftskip\fill #2}\par
}%
\def\tracking{\afterassignment\@tracking\@tempdima}
\def\@stop{\@stop}
\def\@tracking#1#2{%
    \@tempskipa 4\@tempdima
    \def\reserved@b{}
    \edef\reserved@a{#1 }\expandafter\@trackbywords\reserved@a\@stop
    \let#2\reserved@b
}
\def\@trackbywords#1 #2\@stop{%
    \def\reserved@a{#2}%
    \ifx\reserved@a\@empty
	\def\reserved@a{#1}\ifx\reserved@a\@empty\else\@trackword#1\@stop\fi
	\let\reserved@a\@empty
    \else
	\@trackword#1\@stop%
	\edef\reserved@b{\reserved@b\space\nobreak\hskip\the\@tempskipa\relax}%
	\def\reserved@a{\@trackbywords#2\@stop}%
    \fi
    \reserved@a
}
\def\@trackword#1#2\@stop{%
    \def\reserved@a{#2}%
    \ifx\reserved@a\@empty
	\def\reserved@a{#1}\ifx\reserved@a\@empty\else
	    \edef\reserved@b{\reserved@b#1}%
	\fi
	\let\reserved@a\@empty
    \else
	\edef\reserved@b{\reserved@b#1\kern\the\@tempdima\relax}%
	\def\reserved@a{\@trackword#2\@stop}%
    \fi
    \reserved@a
}
%
% Styles of the document elements
%
\def\namestyle{\LARGE\bfseries\MakeUppercase}
\def\sectionstyle{\bfseries\scshape}
\def\datestyle{\itshape}
\def\entryheadstyle{\bfseries}
\def\headernamestyle{\bfseries\scshape}
\def\headerpagestyle{\scshape}
\def\leftheaderstyle{}
\def\rightheaderstyle{}
%
% Document elements
%
\def\name#1{\gdef\@name{#1}}
\def\address#1{\gdef\@address{#1}}
\def\phone#1{\gdef\@phone{#1}}
\def\email#1{\gdef\@email{#1}}
%
% Header format
%
\def\onlyifmakingheader#1{%
    \expandafter\ifx\csname @address\endcsname\relax\else
        #1%
    \fi
}
\def\makeleftheader{{\leftheaderstyle{\@address}}}
\def\makerightheader{{\rightheaderstyle{\@phone\\{\expandafter\randomize\expandafter{\@email}}}}}
\def\maketitle{%
    \thispagestyle{empty}%
    \begingroup
	\realvbox{%
	    \centerline{{\namestyle{\@name}}}%
	}%
	\vskip 0.5em plus 2em\relax
        \onlyifmakingheader{%
            \realvbox{%
                \lrlinefrac{\makeleftheader}{\makerightheader}{0.5}%
            }%
            \vskip 0.5em plus 2em\relax
        }%
    \endgroup
    \mark{}%
}
%
% Page style
%
\def\ps@resume{%
    \let\@oddfoot\@empty\let\@evenfoot\@empty
    \def\@oddhead{%
        \hskip-\dateregionwidth
        \vtop{%
            \hb@xt@\realtextwidth{%
                {\headernamestyle{\@name}}%
                \hfill
                {\headerpagestyle{Page \thepage}}%
            }%
            \ifx\thetopmark\@empty\else
                \vskip .25in
                \hb@xt@\realtextwidth{%
                    \sectionstyle{\thetopmark}, \emph{continued}%
                    \hfill
                }%
                \vskip 2pt
            \fi
        }\hss
    }%
    \let\@evenhead\@oddhead
    \let\@mkboth\@gobbletwo
}
\let\thetopmark\@empty
\addto@macro\@outputpage{%
    \protected@xdef\thetopmark{\botmark}%
}%
%
% Section format
%
\newcommand\section[2][]{%
    \par
    \mark{}%
    \goodbreak
    \vskip 1em plus 1em minus .25em\relax
    \realvtop{%
	\noindent{\sectionstyle{#2}}%
	\vskip 2pt
	%\hrule width \dateregionwidth \relax
    }
    \par
    \nobreak
    \begingroup
        \let\protect\@unexpandable@protect
        \mark{#2}%
    \endgroup
    \nobreak
}
\newcounter{section}
%
% Entry format
%
\def\thepage{}
\def\entry#1.#2|{%
    \ifdim\lastskip=\z@\vskip0.5\baselineskip\fi
    \leavevmode\@formatdate{#1}%
    {\entryheadstyle{\ignorespaces#2}}%
    \hskip1sp\relax % To avoid automatic space insertion by Bluebook
}
\def\resume@lastdate{}
\def\@formatdate#1{%
    \def\resume@thisdate{#1}%
    \ifx\resume@lastdate\resume@thisdate\else
        \let\resume@lastdate\resume@thisdate
        \marginpar{%
            %\leftskip=0pt plus 1filll
            \rightskip=0pt plus 1fill
            \hangindent=1em
            \noindent
            %\hskip 0pt plus -1filll
            \datestyle{\@parserange#1--\@end}%
        }%
    \fi
}%
\def\@parserange#1-#2-#3\@end{%
    \@parsedate#1///\@end
    \def\@t{#2}%
    \ifx\@t\@empty\else
        \ifx\@t\space--\else
	    --\@parsedate#2///\@end
	\fi
    \fi
}
\def\@parsedate#1/#2/#3/#4\@end{%
    \begingroup
	\def\@month{#2}%
	\ifx\@month\@empty\else
	    \month=#2\relax
	    \ifcase\month\or
	    Jan.\or Feb.\or Mar.\or Apr.\or May\or June\or
	    July\or Aug.\or Sept.\or Oct.\or Nov.\or Dec.\or Summer\fi~%
	    \def\@day{#3}%
	    \ifx\@day\@empty\else\day=#3\relax\number\day, \fi
	\fi
	#1%
    \endgroup
}
%
% Lists
%
\newlength\listindent
\newlength\listsep
\AtBeginDocument{\listindent=2em\relax\listsep=0.5em}
\def\item{%
    \par\noindent
    \hangindent\listindent\advance\hangindent\listsep
    \hb@xt@\listindent{\hfill\@doitem}\hskip\listsep
}
\newcount\@itemizecolcount
\newcount\@itemizecolnum
\renewenvironment{itemize}[1][1]{
    \@itemizecolnum=#1\relax
    \ifnum\@itemizecolnum=1
	\let\@doitem\textbullet\par
    \else
	\@itemizecolcount=0
	\def\item{%
	    \let\@afterfi\relax
	    \ifnum\@itemizecolcount=\@itemizecolnum\relax
		\def\@afterfi{\cr}%
		\global\@itemizecolcount=1
	    \else
		\ifnum\@itemizecolcount=0
		\else
		    \def\@afterfi{&}%
		\fi
		\global\advance\@itemizecolcount 1
	    \fi
	    \@afterfi
	    \hb@xt@\listindent{\hfill\textbullet}\hskip\listsep
	}%
	\halign\bgroup &\ignorespaces##\unskip\hfill\cr
    \fi\ignorespaces
}{
    \ifnum\@itemizecolnum=1
	\par
    \else
	\crcr\egroup
    \fi
    \ignorespacesafterend
}
\newcounter{enumctr}\setcounter{enumctr}{1}
\renewenvironment{enumerate}{%
    \def\@doitem{\arabic{enumctr}\addtocounter{enumctr}{1}.}\par
}{
    \par\ignorespacesafterend
}
%
% Set up paper size and fonts (copied from article.cls)
%
\if@compatibility\else
\DeclareOption{a4paper}
   {\setlength\paperheight {297mm}%
    \setlength\paperwidth  {210mm}}
\DeclareOption{a5paper}
   {\setlength\paperheight {210mm}%
    \setlength\paperwidth  {148mm}}
\DeclareOption{b5paper}
   {\setlength\paperheight {250mm}%
    \setlength\paperwidth  {176mm}}
\DeclareOption{letterpaper}
   {\setlength\paperheight {11in}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{legalpaper}
   {\setlength\paperheight {14in}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{executivepaper}
   {\setlength\paperheight {10.5in}%
    \setlength\paperwidth  {7.25in}}
\DeclareOption{landscape}
   {\setlength\@tempdima   {\paperheight}%
    \setlength\paperheight {\paperwidth}%
    \setlength\paperwidth  {\@tempdima}}
\fi
\newcommand\@ptsize{}
\if@compatibility
  \renewcommand\@ptsize{0}
\else
\DeclareOption{10pt}{\renewcommand\@ptsize{0}}
\fi
\DeclareOption{11pt}{\renewcommand\@ptsize{1}}
\DeclareOption{12pt}{\renewcommand\@ptsize{2}}
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\if@compatibility\else
\DeclareOption{final}{\setlength\overfullrule{0pt}}
\fi
\ExecuteOptions{10pt,letterpaper,draft}
\ProcessOptions
\input{size1\@ptsize.clo}
%
% Set page parameters (override the size1x.clo file)
%
\RequirePackage[margin=1in,headsep=.5in]{geometry}
\newdimen\realtextwidth
\parindent=0pt
\newdimen\dateregionwidth \dateregionwidth=\z@
\newdimen\innerrightmargin
\innerrightmargin=0em
%
% Changes the resume's date region size.
%
\def\resumedateregion#1{%
    \advance\hoffset-\dateregionwidth
    \advance\textwidth\dateregionwidth
    \dateregionwidth=#1\relax
    \advance\hoffset\dateregionwidth
    \advance\textwidth-\dateregionwidth
    \marginparwidth=\dateregionwidth \advance\marginparwidth-\marginparsep
    \reversemarginpar
}
\def\resumegeometry{%
    \realtextwidth=\textwidth
    \advance\textwidth-\innerrightmargin
    \advance\textwidth-\dateregionwidth
}
\resumegeometry
\resumedateregion{1in}
\long\def\realvbox#1{%
    \ifvmode\else\par\fi
    \moveleft\dateregionwidth\vbox{\hsize\realtextwidth#1}%
}
\def\realvtop#1{%
    \ifvmode\else\par\fi
    \moveleft\dateregionwidth\vtop{\hsize\realtextwidth#1}%
}
%
\pagestyle{resume}
\pagenumbering{arabic}
\endinput
