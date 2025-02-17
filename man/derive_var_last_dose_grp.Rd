% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/derive_var_last_dose_grp.R
\name{derive_var_last_dose_grp}
\alias{derive_var_last_dose_grp}
\title{Derive Last Dose with User-Defined Groupings}
\usage{
derive_var_last_dose_grp(
  dataset,
  dataset_ex,
  filter_ex = NULL,
  by_vars = vars(STUDYID, USUBJID),
  dose_id = vars(),
  dose_date,
  analysis_date,
  single_dose_condition = (EXDOSFRQ == "ONCE"),
  new_var,
  grp_brks,
  grp_lbls,
  include_lowest = TRUE,
  right = TRUE,
  dose_var = EXDOSE,
  traceability_vars = NULL
)
}
\arguments{
\item{dataset}{Input dataset.
The variables specified by the \code{by_vars} and \code{analysis_date} parameters are expected.}

\item{dataset_ex}{Input EX dataset.
The variables specified by the \code{by_vars}, \code{dose_date}, \code{new_vars} parameters,
and source variables from \code{traceability_vars} parameter are expected.}

\item{filter_ex}{Filtering condition applied to EX dataset.
For example, it can be used to filter for valid dose.
Defaults to NULL.}

\item{by_vars}{Variables to join by (created by \code{dplyr::vars}).}

\item{dose_id}{Variables to identify unique dose (created by \code{dplyr::vars}).
Defaults to empty \code{vars()}.}

\item{dose_date}{The EX dose date variable. A date or date-time object is expected.}

\item{analysis_date}{The analysis date variable. A date or date-time object is expected.}

\item{single_dose_condition}{The condition for checking if \code{dataset_ex} is single dose. An error
is issued if the condition is not true. Defaults to \code{(EXDOSFRQ == "ONCE")}.}

\item{new_var}{The output variable defined by the user.}

\item{grp_brks}{User supplied breaks to apply to groups.
Refer to \code{breaks} parameter in \code{cut()} for details.}

\item{grp_lbls}{User supplied labels to apply to groups.
Refer to \code{labels} parameter in \code{cut()} for details.}

\item{include_lowest}{logical, indicating if a value equal to the lowest
(or highest, for right = FALSE) ‘breaks’ value should be included.
Refer to \code{include.lowest} parameter in \code{cut()} for details.}

\item{right}{Logical, indicating if the intervals should be closed on the right
(and open on the left) or vice versa.
Refer to \code{right} parameter in \code{cut()} for details.}

\item{dose_var}{The source dose amount variable. Defaults to \code{EXDOSE}.}

\item{traceability_vars}{A named list returned by \code{\link[=vars]{vars()}} listing the traceability variables,
e.g. \code{vars(LDOSEDOM = "EX", LDOSESEQ = EXSEQ)}.
The left-hand side (names of the list elements) gives the names of the traceability variables
in the returned dataset.
The right-hand side (values of the list elements) gives the values of the traceability variables
in the returned dataset.
These can be either strings or symbols referring to existing variables.}
}
\value{
Input dataset with additional column \code{new_var}.
}
\description{
Add a variable for user-defined dose grouping of the last dose to the input dataset.
}
\details{
Last dose is the dose with maximum \code{dose_date} that is lower to or equal to the
\code{analysis_date} per \code{by_vars} for each observation in \code{dataset}.
The last dose group is then derived by user-defined grouping, which groups
\code{dose_var} as specified in \code{grp_brks}, and returns \code{grp_lbls} as the values for \code{new_var}.

If dose information is aggregated (i.e. is a dosing frequency other than \code{"ONCE"}
over a period defined by a start and end date) the function
\code{create_single_dose_dataset()} can be used to generate single doses from
aggregate dose information and satisfy \code{single_dose_condition}.
}
\examples{
library(dplyr, warn.conflicts = FALSE)
library(admiral.test)
data(admiral_ae)
data(ex_single)

ex_single <- derive_vars_dtm(
  head(ex_single, 100),
  dtc = EXSTDTC,
  new_vars_prefix = "EXST",
  flag_imputation = "none"
)

adae <- admiral_ae \%>\%
  head(100) \%>\%
  derive_vars_dtm(
    dtc = AESTDTC,
    new_vars_prefix = "AST",
    highest_imputation = "M"
  )

adae \%>\%
  derive_var_last_dose_grp(
    dataset_ex = ex_single,
    filter_ex = (EXDOSE > 0 | (EXDOSE == 0 & grepl("PLACEBO", EXTRT))) &
      !is.na(EXSTDTM),
    by_vars = vars(STUDYID, USUBJID),
    dose_date = EXSTDTM,
    new_var = LDGRP,
    grp_brks = c(0, 20, 40, 60),
    grp_lbls = c("Low", "Medium", "High"),
    include_lowest = TRUE,
    right = TRUE,
    dose_var = EXDOSE,
    analysis_date = ASTDTM,
    traceability_vars = vars(LDOSEDOM = "EX", LDOSESEQ = EXSEQ, LDOSEVAR = "EXENDTC")
  ) \%>\%
  select(USUBJID, LDGRP, LDOSEDOM, LDOSESEQ, LDOSEVAR)
}
\seealso{
\code{\link[=derive_vars_last_dose]{derive_vars_last_dose()}}, \code{\link[=cut]{cut()}}, \code{\link[=create_single_dose_dataset]{create_single_dose_dataset()}}

General Derivation Functions for all ADaMs that returns variable appended to dataset:
\code{\link{derive_var_confirmation_flag}()},
\code{\link{derive_var_extreme_flag}()},
\code{\link{derive_var_last_dose_amt}()},
\code{\link{derive_var_last_dose_date}()},
\code{\link{derive_var_merged_cat}()},
\code{\link{derive_var_merged_character}()},
\code{\link{derive_var_merged_exist_flag}()},
\code{\link{derive_var_merged_summary}()},
\code{\link{derive_var_obs_number}()},
\code{\link{derive_var_relative_flag}()},
\code{\link{derive_var_worst_flag}()},
\code{\link{derive_vars_joined}()},
\code{\link{derive_vars_last_dose}()},
\code{\link{derive_vars_merged_lookup}()},
\code{\link{derive_vars_merged}()},
\code{\link{derive_vars_transposed}()},
\code{\link{get_summary_records}()}
}
\author{
Ben Straub
}
\concept{der_gen}
\keyword{der_gen}
