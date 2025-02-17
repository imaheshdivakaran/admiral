% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/filter_extreme.R
\name{filter_extreme}
\alias{filter_extreme}
\title{Filter the First or Last Observation for Each By Group}
\usage{
filter_extreme(dataset, by_vars = NULL, order, mode, check_type = "warning")
}
\arguments{
\item{dataset}{Input dataset

The variables specified by the \code{order} and the \code{by_vars} parameter are
expected.}

\item{by_vars}{Grouping variables

\emph{Default}: \code{NULL}

\emph{Permitted Values:} list of variables created by \code{vars()}}

\item{order}{Sort order

Within each by group the observations are ordered by the specified order.

\emph{Permitted Values:} list of variables or \verb{desc(<variable>)} function calls
created by \code{vars()}, e.g., \code{vars(ADT, desc(AVAL))}}

\item{mode}{Selection mode (first or last)

If \code{"first"} is specified, the first observation of each by group is
included in the output dataset. If \code{"last"} is specified, the last
observation of each by group is included in the output dataset.

\emph{Permitted Values:}  \code{"first"}, \code{"last"}}

\item{check_type}{Check uniqueness?

If \code{"warning"} or \code{"error"} is specified, the specified message is issued
if the observations of the input dataset are not unique with respect to the
by variables and the order.

\emph{Default:} \code{"warning"}

\emph{Permitted Values:} \code{"none"}, \code{"warning"}, \code{"error"}}
}
\value{
A dataset containing the first or last observation of each by group
}
\description{
Filters the first or last observation for each by group.
}
\details{
For each group (with respect to the variables specified for the
\code{by_vars} parameter) the first or last observation (with respect to the
order specified for the \code{order} parameter and the mode specified for the
\code{mode} parameter) is included in the output dataset.
}
\examples{
library(dplyr, warn.conflicts = FALSE)
library(admiral.test)
data("admiral_ex")

# Select first dose for each patient
admiral_ex \%>\%
  filter_extreme(
    by_vars = vars(USUBJID),
    order = vars(EXSEQ),
    mode = "first"
  ) \%>\%
  select(USUBJID, EXSEQ)

# Select highest dose for each patient on the active drug
admiral_ex \%>\%
  filter(EXTRT != "PLACEBO") \%>\%
  filter_extreme(
    by_vars = vars(USUBJID),
    order = vars(EXDOSE),
    mode = "last",
    check_type = "none"
  ) \%>\%
  select(USUBJID, EXTRT, EXDOSE)
}
\seealso{
Utilities for Filtering Observations: 
\code{\link{count_vals}()},
\code{\link{filter_confirmation}()},
\code{\link{filter_relative}()},
\code{\link{max_cond}()},
\code{\link{min_cond}()}
}
\author{
Stefan Bundfuss
}
\concept{utils_fil}
\keyword{utils_fil}
