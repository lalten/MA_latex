%LaTeX
\typeout{Document Style Option `$Id$'}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% HISTORY:
% $Log$
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{diplomarbeit}[2004/08/17]

% Unbekannte optionen an die scrbook-Klasse weitergeben
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrbook}}
\ProcessOptions
\LoadClass{scrbook}
\RequirePackage{lmodern}
\RequirePackage{rcslocal}
\RequirePackage{color}
\RequirePackage{ifthen}

\AtEndOfClass{
        \RequirePackage[pdftex]{graphicx}
        \DeclareGraphicsExtensions{.pdf,.jpg,.png,.tif}
  \graphicspath{{.generated/}{gfx/}}
}
%

% --------------------------------------------------------------------
% language dependend settings
% --------------------------------------------------------------------
\AtBeginDocument{
  \ifx\languagename\undefined
    \ClassWarning{rcs-diplomarbeit}{\string\languagename\space not
      defined, using \string\language.\MessageBreak This may result in
      use of wrong language!\MessageBreak
      You should use a compatible language package\MessageBreak
      (e.g. Babel; this is required for the '\addto' to work)}
  \else
    \iflanguage{german}{% German
      \def\listofsymbolsname{Verzeichnis der verwendeten Symbole}
      \def\monatsdatum{\month@german\space\number\year}
      \def\dankname{Danksagung}
      \def\arbeitsarttext{Diplomarbeit}%
      \def\praktikumsberichttext{Praktikumsbericht}%
      \def\idptext{Interdisziplin\"ares Projekt}%
      \def\techreporttext{Technischer Bericht}%
      \def\studientext{Studienarbeit}%
      \def\bachelortext{Bachelorarbeit}%
      \def\eingereichttext{Eingereicht im~}
      \def\lehrstuhltext{%
        Lehrstuhl f\"ur Realzeit-Computersysteme\\
        Technische Universit\"at M\"unchen\\
        Prof. Dr.~sc. Samarjit Chakraborty}
      \def\ausgefuehrttext{Ausgef\"uhrt~}
      \def\ausgefuehrtamtext{Ausgef\"uhrt am~}
      \def\betreutdurchtext{Betreut durch den~}
      \def\betreuertext{Betreuer:}
      \def\bearbeitertext{Bearbeiter:}
      \renewcommand*\indexname{Stichwortverzeichnis}
    }{% English and all others
      \def\listofsymbolsname{List of Symbols}
      \def\month@english{\ifcase\month\or
        January\or February\or March\or April\or May\or June\or
        July\or August\or September\or October\or November\or December\fi
        \space}
      \def\monatsdatum{\month@english\number\year}
      \def\dankname{Acknowledgements}
      \def\arbeitsarttext{Master's Thesis}%
      \def\techreporttext{Technical Report}%
      \def\praktikumsberichttext{This style is only available in German!!}%
      \def\idptext{This style is only available in German!!}%
      \def\studientext{This style is only available in German!!}%
      \def\bachelortext{Bachelor's Thesis}%
      \def\eingereichttext{Submitted in~}
      \def\lehrstuhltext{%
        Institute for Real-Time Computer Systems\\
        Technische Universit\"at M\"unchen\\
        Prof. Dr.~sc. Samarjit Chakraborty}
      \def\ausgefuehrttext{Executed~}
      \def\ausgefuehrtamtext{Executed at the~}
      \def\betreutdurchtext{Supervised by the~}
      \def\betreuertext{Advisor:}
      \def\bearbeitertext{Author:}
    }

    \expandafter\selectlanguage\expandafter{\languagename}
    \ClassInfo{diplomarbeit}{used language is \languagename}

    % Vielleicht kann man alles auf diese Basis umstellen?
    % ACTHUNG: diese Option setzt anscheinend 'babel' vorraus !
    \addto\extrasgerman{\renewcommand{\figurename}{Bild}}
\fi
}

% --------------------------------------------------------------------
% Makros fuer die Titelseite(n)
% --------------------------------------------------------------------
\def\arbeitsart#1{
  \ifthenelse{\equal{#1}{Techreport}}{
    \typeout{Technical Report}
    \gdef\@arbeitsart{\techreporttext}
    \def\@techreport{true}
  }{
    \ifthenelse{\equal{#1}{Praktikumsbericht}}
    {\typeout{Praktikumsbericht}
      \gdef\@arbeitsart{\praktikumsberichttext}
    }{
      \ifthenelse{\equal{#1}{IDP}}
      {\typeout{Interdisziplin\"ares Projekt}
        \gdef\@arbeitsart{\idptext}
      }{
        \ifthenelse{\equal{#1}{Studienarbeit}}
        {\typeout{Studienarbeit}
          \gdef\@arbeitsart{\studientext}
        }{
          \ifthenelse{\equal{#1}{Bachelor}}
          {\typeout{Bachelorarbeit}
            \gdef\@arbeitsart{\bachelortext}
          }{
            \gdef\@arbeitsart{#1}
          }
        }
      }
    }
  }
}
                        
\gdef\@arbeitsart{\arbeitsarttext}
\gdef\@techreport{false}
\def\band#1{\gdef\@band{#1}}
\gdef\@band{\null}

\def\authorsaddr#1{\gdef\@authorsaddr{#1}}
\gdef\@authorsaddr{\null}

\def\betreuer#1{\gdef\@betreuer{#1}}
\gdef\@betreuer{\null}

\def\eingereicht#1{\gdef\@eingereicht{#1}}
% Default is today's date (month and year)
\gdef\@eingereicht{\monatsdatum}

% Ausf"uhrung und Betreuung (f. externe Arbeiten)
\def\ausgefuehrtam#1{\gdef\@ausgefuehrtam{#1}}
\gdef\@ausgefuehrtam{}

\def\betreutdurch#1{\gdef\@betreutdurch{#1}}
\gdef\@betreutdurch{\lehrstuhltext}

\def\techreportident#1{\gdef\@techreportident{#1}}
\gdef\@techreportident{missing}


% ------------------------------------------------------------------------
% wenn's gar nicht anders geht: Titelverbreiterung :-)
% ------------------------------------------------------------------------
\newlength{\TitleWidth}  \setlength{\TitleWidth}{.9\textwidth}
\newcommand{\EnlargeTitleWidth}[1]{%
  \addtolength{\TitleWidth}{#1}
}

% ------------------------------------------------------------------------
%                        \def\maketitle
% ------------------------------------------------------------------------
%\newcommand{\inFutura}[1]{\sffamily #1}
%\newcommand{\inBoldFutura}[1]{\bfseries\sffamily #1}
%\newcommand{\inItalicFutura}[1]{\itshape\sffamily #1}
\renewcommand{\rmdefault}{lmr}

\def\maketitle{\begin{titlepage}%
\sffamily
% ------------------------------------------------------------------------
% Deckblatt
% ------------------------------------------------------------------------
 \thishead{rcsheadwobgempty}
 \pagestyle{empty}
 %%\setcounter{page}{1}
 \let\footnotesize\small
 \let\footnoterule\relax
 \null
 % Der Titel und so...
 %\vspace*{\oRand}\hspace*{\lRand} \begin{minipage}{16cm}
 \vspace*{8cm}
 \begin{center}
   \begin{minipage}[c][\totalheight][c]{\TitleWidth} % Breite des Titels
   \begin{center}
    {\LARGE \bfseries{\@title} \par}%
  \vskip 3em%
  {\Large
   \lineskip .75em%
    \@author}
    \vskip 7em%
        {\Large \bfseries{\@band}}
   \end{center}
  \end{minipage}\end{center}
 \par
 %\end{minipage}
  \vfill
 %\hspace*{\lRand} \begin{minipage}{16cm}\begin{center}%
 % {\LARGE \inBoldFutura{\@arbeitsart}}
 %\end{center}\par\end{minipage}
 \begin{center}
 \begin{minipage}{16cm}\begin{center}%
  {\LARGE \bfseries{\@arbeitsart}}
 \end{center}\par\end{minipage}
 \end{center}
 \ifthenelse{\equal{\@techreport}{true}}{
        \par%
        \begin{center}
          \begin{minipage}{16cm}\begin{center}%
           {\Large \bfseries{\@techreportident}}
          \end{center}\par\end{minipage}
        \end{center}
 }{
 \cleardoublepage
 % ------------------------------------------------------------------------
 % Das ganze etwas genauer
 % ------------------------------------------------------------------------
 \null
 \vspace*{126pt}
 \begin{center}
  \begin{minipage}{\TitleWidth}\centering%
   \vfil
   {\Large \bfseries{\@title} \par}%
   \vfil
   \vskip 2.5em
   {\large \@arbeitsart \par}%
   {\normalsize \@band \par}%
   \vfil
  \end{minipage}
 \end{center}\par
 \vfill
 \begin{center}%
  \ifx\@ausgefuehrtam\@empty {{\ausgefuehrtamtext\@betreutdurch}}
  \else {{\betreutdurchtext\@betreutdurch
         \vfill  
         \ausgefuehrttext\@ausgefuehrtam}}
  \fi
 \end{center}\par
 \vskip 1.5em
 \vfill
 \begin{tabular}{l@{\hspace{1cm}}l}%
   \bfseries{\betreuertext} & 
     \parbox[t]{9cm}{{\@betreuer}}\\
     & \\
   \bfseries{\bearbeitertext} & 
     \parbox[t]{9cm}{{\@author\\ \@authorsaddr}} \\
     & \\*[0.5cm]
 \multicolumn{2}{l}{{\eingereichttext \@eingereicht}} \\
 \end{tabular}
 }
 \@thanks
\end{titlepage}%
\setcounter{footnote}{0}%
\let\thanks\relax%
\gdef\@thanks{}\gdef\@author{}\gdef\@title{}\let\maketitle\relax
}

% --------------------------------------------------------------------
% Änderung am Koma-Script Style
\deffootnote[1em]{1.5em}{1em}{
  \textsuperscript{\normalfont\thefootnotemark)~}}
\deffootnotemark{\textsuperscript{\normalfont\thefootnotemark)}}

% --------------------------------------------------------------------
% Dank 
% --------------------------------------------------------------------
\newenvironment{danksagung}{%
  \clearpage
  \thispagestyle{empty}
  \@makeschapterhead{\dankname}
  \sffamily
}{
}

% --------------------------------------------------------------------
% Abstract (Zusammenfassung)
% --------------------------------------------------------------------
\def\abstract{
  \clearpage
  \thispagestyle{plain}
  \@makeschapterhead{\abstractname}
  \sffamily
}{
}
\def\endabstract{
}

% --------------------------------------------------------------------
\newenvironment{Widmung}{
 \clearpage
 \thispagestyle{empty}
 \@makeschapterhead{\null}
}{
}

% --------------------------------------------------------------------
% Verwendete Symbole
% --------------------------------------------------------------------
\newenvironment{listofsymbols}{%
  \clearpage
  \addchap{\listofsymbolsname}
}{
}

% Um die hyperref-Sprünge korrekt zu bekommen
\renewcommand*\idx@heading{%
  \addchap{\indexname}
}
 
\endinput
% LocalWords:  makeatletter
