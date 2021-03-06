% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/post_analyses.R
\name{calculate_DIC}
\alias{calculate_DIC}
\title{DIC}
\usage{
calculate_DIC(chain, location = NULL)
}
\arguments{
\item{chain}{the MCMC chain with a lnlike column and all columns (number of columns will be used}

\item{location}{optionally, subset the chain by a given location}
}
\value{
a single DIC value
}
\description{
Calculates DIC from a given MCMC chain. Optionally can look at subset by location.
}

