% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/user_helpers.R
\name{use_ad_template}
\alias{use_ad_template}
\title{Open an ADaM Template Script}
\usage{
use_ad_template(
  adam_name = "adsl",
  save_path = paste0("./", adam_name, ".R"),
  package = "admiral",
  overwrite = FALSE,
  open = interactive()
)
}
\arguments{
\item{adam_name}{An ADaM dataset name. You can use any of the available dataset name ADAE, ADCM, ADEG, ADEX, ADLB, ADMH, ADPP, ADSL, ADVS, and the dataset name is case-insensitive. The default dataset name is ADSL.}

\item{save_path}{Path to save the script.}

\item{package}{The R package in which to look for templates. By default \code{"admiral"}.}

\item{overwrite}{Whether to overwrite an existing file named \code{save_path}.}

\item{open}{Whether to open the script right away.}
}
\value{
No return values, called for side effects
}
\description{
Open an ADaM Template Script
}
\details{
Running without any arguments such as \code{use_ad_template()} auto-generates adsl.R in the current path. Use \code{list_all_templates()} to discover which templates are available.
}
\examples{
if (interactive()) {
  use_ad_template("adsl")
}
}
\seealso{
Utilities used for examples and template scripts: 
\code{\link{list_all_templates}()}
}
\author{
Shimeng Huang, Thomas Neitmann
}
\concept{utils_examples}
\keyword{utils_examples}
