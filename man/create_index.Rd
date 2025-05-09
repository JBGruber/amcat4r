% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/index.R
\name{create_index}
\alias{create_index}
\alias{modify_index}
\title{Create an index}
\usage{
create_index(
  index,
  name = index,
  description = NULL,
  create_fields = NULL,
  guest_role = NULL,
  credentials = NULL
)

modify_index(
  index,
  name = index,
  description = NULL,
  guest_role = NULL,
  credentials = NULL
)
}
\arguments{
\item{index}{short name of the index to create (follows naming conventions of
Elasticsearch, see details).}

\item{name}{optional more descriptive name of the index to create (all
characters are allowed here)}

\item{description}{optional description of the index to create}

\item{create_fields}{create fields in the new index.}

\item{guest_role}{Role for unauthorized users. Options are "admin", "writer",
"reader" and "metareader".}

\item{credentials}{The credentials to use. If not given, uses last login
information.}
}
\description{
Create or modify an index.
}
\details{
The short name for the new index (index argument) must meet these
criteria:
\itemize{
\item Lowercase only
\item Cannot include \verb{\\}, \code{/}, \code{*}, \verb{?}, \verb{"}, \code{<}, \code{>}, \code{|}, \code{:}, \verb{ }(space), \verb{,} (comma), \verb{#}
\item Cannot start with -, _, +
\item Cannot be \code{.} or \code{..}
\item Cannot be longer than 255 character (note that some symbols like emojis take up tw characters)
\item If names start with ., the index will be hidden and non accesible
}
}
\section{Functions}{
\itemize{
\item \code{modify_index()}: Modify an index

}}
\examples{
\dontrun{
create_index("test_index")
}

}
