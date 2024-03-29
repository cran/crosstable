% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/labels.R
\name{set_label}
\alias{set_label}
\alias{copy_label_from}
\title{Set the "label" attribute of an object}
\usage{
set_label(x, value, object = FALSE)

copy_label_from(x, from)
}
\arguments{
\item{x}{the variable to label}

\item{value}{value of the label. If \code{x} is a list/data.frame, the labels will all be set recursively. If \code{value} is a function, it will be applied to the current labels of \code{x}.}

\item{object}{if \code{x} is a list/data.frame, \code{object=TRUE} will force setting the labels of the object instead of the children}

\item{from}{the variable whose label must be copied}
}
\value{
An object of the same type as \code{x}, with labels
}
\description{
Set the "label" attribute of an object

Copy the label from one variable to another
}
\examples{
library(dplyr)
mtcars \%>\%
   mutate(mpg2=set_label(mpg, "Miles per gallon"),
          mpg3=mpg \%>\% copy_label_from(mpg2)) \%>\%
   crosstable(c(mpg, mpg2, mpg3))
mtcars \%>\%
   copy_label_from(mtcars2) \%>\%
   crosstable(c(mpg, vs))
mtcars2 \%>\% set_label(toupper) \%>\% get_label()
}
\seealso{
\code{\link[=get_label]{get_label()}}, \code{\link[=import_labels]{import_labels()}}, \code{\link[=remove_label]{remove_label()}}
}
\author{
Dan Chaltiel
}
