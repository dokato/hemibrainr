% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/flywire_googledrive.R
\name{flywire_ids_update}
\alias{flywire_ids_update}
\title{Update the flywire.id column in a set of google sheets based on flywire xyz positions}
\usage{
flywire_ids_update(
  selected_sheets = NULL,
  chosen.columns = c("flywire.xyz", "flywire.svid", "flywire.id", "skid", "FAFB.xyz",
    "cell.type", "side", "ItoLee_Hemilineage", "Hartenstein_Hemilineage", "status"),
  ws = NULL,
  regex = FALSE,
  meta = NULL,
  match = FALSE,
  matching_sheet = options()$hemibrainr_matching_gsheet,
  priority = c("FAFB", "hemibrain"),
  Verbose = TRUE,
  retry = 1
)
}
\arguments{
\item{selected_sheets}{character vector. the google sheet(s) to update. Each entry is a unique google sheet ID. You can find these in a sheet's URL.
If \code{NULL} then defaults to \code{option('hemibrainr_gsheets')}.}

\item{chosen.columns}{as well as writing column updates to the specified google sheets, this function returns a \code{data.frame} built from all given sheets and their
individual tabs, that have been updated. This argument specifies which column you want returned. Filled with NAs if it does not exist.}

\item{ws}{character vector, tabs (i.e. work sheets) on the google sheet to query/read. This works with regex, so you only need to give the name partially.
If set to \code{NULL} for \code{flywire_tracing_sheets}, the whole google sheet is read and all tabs are combined using \code{plyr::rbind.fill}.}

\item{regex}{logical, use \code{ws} with regex.}

\item{meta}{meta data for flywire neurons, e.g. as retreived using \code{\link{flywire_meta}}. Used to efficiently input \code{flywire.xyz} column if only a \code{flywire.id} entry has been given.
Only works if that id is also in this provided \code{data.frame}, \code{meta}.}

\item{match}{logical. If \code{TRUE}, hemibrain matches given.}

\item{matching_sheet}{the master matching sheet. Cannot be in \code{selected_sheets}. This sheet will be processed using \code{\link{hemibrain_matches}} to produce a
\code{data.frame} describing hemibrain-FAFB and FAFB-hemibrain matches.}

\item{priority}{whether to use FAFB->hemibrain matches (FAFB) or hemibrain->FAFB matches (hemibrain) in order to ascribe
cell type names to FAFB neurons. In both cases, cell type names are attached to hemibrain bodyids, and propagated to their FAFB matches.}

\item{Verbose}{logical, whether or not to supply you with messages.}

\item{retry}{integer, sometimes \code{fafbseg::flywire_xyz2id} fails due to a server timeout. This is the number of times to re-arrempt failed calls before accepting defeat.}
}
\value{
a \code{data.frame} with columns from the given google sheet(s), specified using the argument \code{chosen.columns}.
}
\description{
This function retrieves flywire IDs based on xyz positions in flywire voxel space, from a set of google sheets.
It also writes the updated flywire IDs to the same google sheets. This is often helpful because flywire IDs are inherently unstable, they change every time
a neuron is modified even slightly. Users can record 'stable' points in a neuron that identify it, e.g. a single xyz position in the cell body fibre, or at the soma, and
then use this function to update and get the correct flywire ID whenever they wish.
}
\details{
For this function to work, the specified google sheet(s) must have either the column \code{flywire.xyz},
which gives the xyz position of points in a format that can be read by \code{nat::xyzmatrix}, for example \code{"(135767,79463,5284)"} or \code{"(135767;79463;5284)"}.
If this is missing, then the columns: \code{fw.x}, \code{fw.y}, \code{fw.z} must be specified. The xyz positions must be in FlyWire voxel space, which is what you get if you use the
copy location tool in the flywire.ai web-interface.

The logic of the update procedure is:, find the \code{flywire.xyz} column.
If that does not exist, find: \code{fw.x}, \code{fw.y}, \code{fw.z}, and use that to create a \code{flywire.xyz} column.
We use \code{flywire.xyz} if both are given, and there is a mismatch.
For each row, a \code{flywire.id} is then found based on these points, using \code{fafbseg::flywire_xyz2id} (using the argument \code{rawcoords = TRUE}).
The google sheet columns \code{flywire.id},\code{flywire.xyz}, \code{fw.x}, \code{fw.y}, \code{fw.z} are then updated if they exist in the original google sheet.
If they do not, they are not updated. The function returns a \code{data.frame} combining all tabs of all googlesheets specified, but returning only the columns
specified by the argument \code{chosen.columns}.
}
\examples{
\donttest{
\dontrun{

# Update flywire.ids in the sheet:
### https://docs.google.com/spreadsheets/d/
### 1rzG1MuZYacM-vbW7100aK8HeA-BY6dWAVXQ7TB6E2cQ
### /edit#gid=0
## And return
fw.gsheet.meta = flywire_ids_update(selected_sheets =
"1rzG1MuZYacM-vbW7100aK8HeA-BY6dWAVXQ7TB6E2cQ")

}}
}
\seealso{
\code{\link{flywire_ids}},
  \code{\link{flywire_meta}},
  \code{\link{flywire_neurons}}
}
