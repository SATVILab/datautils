% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/filter_based_on_mean_grp_value.R
\name{filter_based_on_mean_grp_value}
\alias{filter_based_on_mean_grp_value}
\title{Choose subset of data with larger/smaller mean value}
\usage{
filter_based_on_mean_grp_value(data, val, grp_outer, grp_inner, sel)
}
\arguments{
\item{data}{dataframe. Dataframe for which subset(s) should be chosen.}

\item{val}{character. Name of column in \code{data} containing the data
whose mean determines which group in \code{group_inner} to choose.}

\item{grp_outer}{character. Name of column in \code{data} indicating
a group of entries for which only one level in \code{grp_inner} should be chosen.}

\item{grp_inner}{character. Name of of column in \code{data} indicating
the sub-groups in grp_outer. Only one level of grp_inner will be chosen per
level of grp_outer.}

\item{sel}{'smaller' or 'larger'. Level of \code{grp_inner} will be
chosen per level of \code{grp_outer} such that it has the smallest mean
of all groups (as defined by \code{grp_inner}) for that level of \code{grp_outer},
if \code{sel == 'smaller'}. Opposite if \code{sel == 'larger'}. No default.}
}
\value{
A dataframe with only one level of \code{grp_inner} for
each level of \code{grp_outer}.
}
\description{
Choose subset of data with larger/smaller mean value
}
\details{
This was written for the situation where the abundance of various types of cells
are available (e.g. CD4 T cells expressing IFNg+), and where both frequencies and counts are available
but it is not indicated which column pertains to frequencies and which to counts. Note that
this function will not work reliably when the response is a frequncy (rather than a proportion)
and the denominator cell count is not consistently much higher than 100.
}
\examples{
set.seed(3)
test_tbl <- tibble(
  pid = rep(c("id1", "id2", "id1", "id2"), each = 2),
  type = c(paste0(rep(c("a", "b"), each = 4), rep(c("", "_1"), 4)))
) \%>\%
  mutate(type_base = stringr::str_remove(type, "_1")) \%>\%
  group_by(pid, type_base) \%>\%
  mutate(resp = purrr::map_dbl(type_base, function(x) {
    round(rnorm(1, 5 + stringr::str_detect(x, "b") * 3), 2)
  })[1]) \%>\%
  ungroup() \%>\%
  mutate(resp = ifelse(str_detect(type, "_1"), rep(runif(4, 1e4, 1e5), each = 2), 1) * resp)

test_tbl

filter_based_on_mean_grp_value(
  data = test_tbl, val = "resp", grp_outer = "type_base",
  grp_inner = "type", sel = "smaller"
)
}
