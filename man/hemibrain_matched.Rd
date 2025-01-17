% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hemibrain_data.R
\docType{data}
\name{hemibrain_matched}
\alias{hemibrain_matched}
\alias{lm_matched}
\title{Manually verified neuron matches between the hemibrain and FAFB dataset}
\format{
An object of class \code{data.frame} with 99155 rows and 16 columns.

An object of class \code{data.frame} with 27878 rows and 11 columns.
}
\usage{
hemibrain_matched

lm_matched
}
\value{
a \code{data.frame} where each row is a neuron, either from the hemibrain or FAFB data sets. Each row gives you its matching neuron in the other data set. These matches have been
manually assigned using \code{\link{fafb_matching}}, \code{\link{hemibrain_matching}} and \code{\link{LR_matching}}. If you use this information make sure you credit it appropriately.
Contact us if unsure:
\itemize{

  \item{"cell.type"}{ - the neuPrint designated 'type' for the neuron. If \code{dataset} is not \code{"hemibrain"}, then this is based on the hemibrain \code{match}.}

  \item{"cell"}{ - the unique cell, which is just \code{cell.type#number}.}

  \item{"cellBodyFiber"}{ - the cell body fiber to which this neuron belongs}

  \item{"ItoLee_Hemilineage"}{ - the hemilineage to which this neuron belongs. Seer \code{\link{hemibrain_hemilineages}}.}

  \item{"match"}{ - the ID of the manual match from the other data set. If \code{dataset=="hemibrain"} then this is a \code{flywire.id} that can be found in \code{flywire_neurons}.If \code{"CATMAID"} or \code{"flywire"} then it is a hemibrain body ID.}

  \item{"quality"}{ - the matcher makers qualitative assessment of how good this match is.}

  \item{"FAFB.hemisphere.match"}{ - the flywire coordinates of a neuron on the opposite hemisphere, which a match maker has designated as this \code{id}'s cognate.}

  \item{"FAFB.hemisphere.match.quality"}{ - the quality of this match.}

  \item{"LM.match"}{ - indicates a light level neuron that is a match for \code{id}. This neuron will be in \code{flycircuit_neurons()} or other light level data.}

  \item{"LM.match.quality"}{ - the quality of this match.}

  \item{"dataset"}{ - the data set to which \code{id} belongs. Either \code{"hemibrain"}, or one of the two FAFB repositories, \code{"CATMAID"} or \code{"flywire"}.}

  \item{"priority"}{ - whether FAFB->hemibrain matches (\code{"FAFB"}) or hemibrain->FAFB matches (\code{"hemibrain"}) were used in order to ascribe cell type names to FAFB neurons.
  In both cases, cell type names are attached to hemibrain bodyids, and propagated to their FAFB matches.}

}
}
\description{
Manually verified neuron matches between the hemibrain and FAFB dataset, as well as some light level data from the package natverse-compatible \code{lhns}.
The Fly Connectome team at the University of Cambridge has
manually made cell-to-cell matches based on an initial NBLAST calculation, and given matches a qualitative score.
There can be no
  match (none), a poor match (poor) an okay match (okay) or an exact match (good). As a
  rule of thumb, a poor match could be a neuron from a very similar same cell
  type or a highly untraced neuron that may be the correct cell type. An okay
  match should be a neuron that looks to be from the same morphological cell
  type but there may be some discrepancies in its arbour. An exact match is a
  neuron that corresponds well between FAFB and the hemibrain data.
the \href{https://docs.google.com/spreadsheets/d/1OSlDtnR3B1LiB5cwI5x5Ql6LkZd8JOS5bBr-HTi0pOw/edit#gid=0}{Google Sheet} or using \code{\link{hemibrain_matches}}
if they have an authenticated email.
}
\keyword{datasets}
