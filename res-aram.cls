% A resume class based off of: http://www.stat.berkeley.edu/~paciorek/computingTips/Latex_template_creating_CV_.html
%
% Author: Aram Avila-Herrera

\NeedsTeXFormat{LaTeX2e}[2014/05/01]
\ProvidesClass{res-aram}[2015/06/26]

% Set the margins
\newlength\thelmargin
\thelmargin=1.5in

\newlength\thesecmargin
\thesecmargin=0.5in

% Load dependencies
\DeclareOption*{\PassOptionsToClass{\CurrentOption,notitlepage}{article}}
\ProcessOptions\relax
\LoadClass{article}
\RequirePackage{calc}              % calculate lengths
%\RequirePackage{fp}               % calculate floats
\RequirePackage[top=1in,
                marginparwidth=\thelmargin-\thesecmargin,
                lmargin=\thelmargin,
                rmargin=\thesecmargin]{geometry}
\RequirePackage{fancyhdr}          % headers
\RequirePackage[compact]{titlesec} % modify sections
\RequirePackage{booktabs}          % prettier table spacing
%\RequirePackage{array}            % \newcolumntype
%\RequirePackage{varwidth}         % variable width minipage
%\RequirePackage{ragged2e}         % fancy Ragged commands
\RequirePackage[inline]{enumitem}  % lists
\RequirePackage{xcolor}            % gray text?
\RequirePackage{etoolbox}          % \ifstrempty, etc...
\RequirePackage{trimspaces}        % trim spaces in address
\RequirePackage{lastpage}          % gets last page number

% More formatting
\raggedbottom

% Body and Margin proportions (for description and dates)
\newcommand{\BodyScale}{0.8}
%\newcommand{\MarginScale}{1}  % needed for using varwidth or tabular* to control body and margin widths
%\FPsub{\MarginScale}{1}{\BodyScale}  % needed to set proper tabular* widths

% Maybe use to put address on one line?
% "\\" line breaks to ", " for \mbox{}es
\newcommand{\removelinebreaks}[1]{%
    \begingroup\def\\{, }#1\endgroup}

% Compare strings when they're the output of commands
\newcommand\@ifstrequal{\expandafter\ifstrequal\expandafter}

% Definitions ------------------------------------------------------------------
% Address, emails, names, ...
\newcommand{\@name}{}
\newcommand{\@shortname}{}
\newcommand{\theaddress}{}   % exported
\newcommand{\theemail}{}     % exported
\newcommand{\thesocial}{}    % exported
\newcommand{\thephone}{}     % exported

\newcommand{\address}[1]{%
    \renewcommand{\theaddress}{\trim@spaces{#1}}
}

\newcommand{\email}[1]{%
    \renewcommand{\theemail}{#1}
}

\newcommand{\social}[1]{%
    \renewcommand{\thesocial}{#1}
}

\newcommand{\phone}[1]{%
    \renewcommand{\thephone}{#1}
}

% Optionally set a short name
\newcommand{\name}[2][]{%
    \ifstrempty{#1}{%
        \renewcommand{\@name}{#2}
    }{%
        \renewcommand{\@name}{#2}
        \renewcommand{\@shortname}{#1}
    }
}


% Pagestyle --------------------------------------------------------------------

% Place contact info in header .................................................
\newcommand{\LeftContactInfo}{%   % Goes inside a minipage
    \theemail\\
    \thesocial\\
    \vspace{0.5ex}
    \thephone%
}
\newcommand{\PlaceLeftContactInfo}[1]{%
    \renewcommand{\LeftContactInfo}{#1}%
}

\newcommand{\RightContactInfo}{%  % Goes inside a minipage
    \theaddress%
}
\newcommand{\PlaceRightContactInfo}[1]{%
    \renewcommand{\RightContactInfo}{#1}%
}

\newcommand{\headercontact}{%
    \begin{minipage}[t]{0.4\linewidth}
        {\raggedright \LeftContactInfo\par}%
    \end{minipage}
    \hfill
    \begin{minipage}[t]{0.4\linewidth}
        {\raggedleft \RightContactInfo\par}%
    \end{minipage}%
}

% Add extra space for contact info to header
\newlength\@oldheadsep
\setlength{\@oldheadsep}{\headsep}

\newlength{\@contactheight}
\setlength{\@contactheight}{\headsep}
\newcommand{\ContactHeight}[1]{%
    \setlength{\@contactheight}{\headsep + #1}
}
% ..............................................................................

\fancypagestyle{CVfancytitle}{%
    \fancyhf{}
    \setlength{\headsep}{\@contactheight}  % modify headsep
    \renewcommand{\headrulewidth}{0.1pt}
    \renewcommand{\footrulewidth}{0pt}
    \renewcommand{\headrule}{%
        \hrule width\headwidth
        \vspace{2pt}
        \textcolor{black!50}{\small \headercontact}%
        %\removelinebreaks{\theaddress}
    }
    \fancyhead[L]{{\LARGE\bfseries \@name}}
    \fancyhead[R]{{\itshape p.~\thepage~of~\pageref*{LastPage}}}
}

\fancypagestyle{CVsimple}{%
    \fancyhf{}
    \setlength{\headsep}{\@oldheadsep}  % reset headsep
    \renewcommand{\headrulewidth}{0.1pt}
    \renewcommand{\footrulewidth}{0pt}
    \fancyhead[R]{{\itshape \@shortname~~p.~\thepage~of~\pageref*{LastPage}}}
}

\pagestyle{CVsimple}
\thispagestyle{CVfancytitle}


% Section title formatting -----------------------------------------------------
\titleformat{\section}[leftmargin]{%
    \scshape\filright
}{%
    \thesection
}{0pt}{}[]
\titlespacing*{\section}{\marginparwidth}{2ex}{\marginparsep}


% Body formatting  -------------------------------------------------------------
% Places text in document body, extending to right margin (eg. for dates)

% ..............................................................................
% Format using fixed width tabular*
% - Long "#2"s wrap nicely
% - All entries have same maximum widths and make indented entries stick out
%
%\newcolumntype{R}[1]{>{\RaggedLeft\hspace{0pt}}p{#1}}
%\newcolumntype{L}[1]{>{\RaggedRight\hspace{0pt}}p{#1}}
%\newcommand{\@BMentry}[3][]{%
%    \@ifstrequal{#1}{*}{\noindent}{}%
%    \begin{tabular*}{\linewidth}[t]{%
%        @{}L{\BodyScale\linewidth}%
%        @{\extracolsep{\fill}}R{\MarginScale\linewidth}%
%    }
%        #2 & #3 \\
%    \end{tabular*}
%}

% Format using variable width minipages
% - No vertical alignment
%
%\newcommand{\@BMentry}[3][]{%
%    \@ifstrequal{#1}{*}{\noindent}{}%
%    \begin{varwidth}{\BodyScale\linewidth}
%        {\raggedright #2}
%    \end{varwidth}
%    \hfill
%    \begin{varwidth}{\MarginScale\linewidth}
%        {\raggedleft #3}
%    \end{varwidth}
%    \newline
%}
% ..............................................................................

% Format using a simple hfill
% - Long entries get ugly formatting
%
% Use optional argument [*] to suppress indent (not needed following a new section)
\newcommand{\@BMentry}[3][]{%
    % [*], Body, Margin
    \@ifstrequal{#1}{*}{\noindent}{}%
    #2 \hfill #3\newline
}

\newcommand{\@employer}[2]{%
    % Employer, City
    \textbf{#1}\ifstrempty{#2}{}{, #2}
}

\newcommand{\experience}[4][]{%
    % [*], Employer, City, Dates
    \@BMentry[#1]{\@employer{#2}{#3}}{#4}
}

\newcommand{\jobtitle}[3][]{%
    % [*], Title, Dates
    \@BMentry[#1]{\textit{#2}}{\textit{#3}}
}

\newcommand{\jobdescription}[2][]{%
    % [*], Body
    \@ifstrequal{#1}{*}{}{\hspace*{1em}}
    \begin{minipage}[t]{\BodyScale\linewidth}
        \raggedright
        {#2}
    \end{minipage}
    \newline\par\smallskip
}

% Lists ------------------------------------------------------------------------
\newlist{CVitemize}{itemize}{3}
\setlist[CVitemize]{label=\textbullet, nosep,
                    leftmargin=\parindent+\labelwidth}

\newlist{CVinline}{itemize*}{2}
\setlist[CVinline]{label={{\small $\cdot$}},
                   itemjoin={{ }},
                   labelwidth=0pt}

\newlist{CVdescription}{description}{3}
\setlist[CVdescription]{before={\raggedright}, nosep}

\newcommand{\award}[3][]{%
    \item[#1] #2 \ifstrempty{#3}{}{\hfill #3}%
}
