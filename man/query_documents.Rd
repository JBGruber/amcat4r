% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/query.R
\name{query_documents}
\alias{query_documents}
\title{Conduct a query and return the resulting documents}
\usage{
query_documents(
  index,
  queries = NULL,
  fields = c("date", "title"),
  filters = NULL,
  scroll = "5m",
  per_page = 1000,
  credentials = NULL,
  merge_tags = ";",
  max_pages = 1
)
}
\arguments{
\item{index}{The index to query}

\item{queries}{An optional vector of queries to run (implicit OR)}

\item{fields}{An optional vector of fields to return}

\item{filters}{An optional list of filters, e.g. list(publisher='A', date=list(gte='2022-01-01'))}

\item{scroll}{Time to keep scrolling cursor alive}

\item{per_page}{Number of results per page}

\item{credentials}{The credentials to use. If not given, uses last login information}

\item{merge_tags}{Character to merge tag fields with, default ';'. Set to NULL to prevent merging.}

\item{max_pages}{Stop after getting this many pages. Set to 0 to retrieve all.}
}
\description{
Conduct a query and return the resulting documents
}
