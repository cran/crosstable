% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/officer.R
\name{generate_autofit_macro}
\alias{generate_autofit_macro}
\title{Generate a macro file for autofitting}
\usage{
generate_autofit_macro()
}
\value{
Nothing, called for its side effects
}
\description{
Autofitting using existing tools in flextable should be enough for most cases. For the others, here is a VBA macro which autofits all tables from inside MS Word.
This function generates a file that can be imported into MS Word in order to use this macro. The macro file should be imported only once per computer.
}
\section{Installation}{

\itemize{
\item In the \code{R} console, run \code{generate_autofit_macro()} to generate the file \code{crosstable_autofit.bas} in your working directory.
\item In MS Word, press Alt+F11 to open the VB Editor.
\item In the Editor, go to \code{File} > \code{Import} or press \code{Ctrl+M} to open the import dialog, and import \code{crosstable_autofit.bas}. There should now be a "CrosstableMacros" module in the "Normal" project.
\item Run the macro, either from the VB Editor or from \code{View} > \code{Macros} > \verb{View Macros} > \code{Run}.
}

This process will make the macro accessible from any Word file on this computer. Note that, in the Editor, you can also drag the module to your document project to make the macro accessible only from this file. The file will have to be named with the \code{docm} extension though.
}

\author{
Dan Chaltiel
}
