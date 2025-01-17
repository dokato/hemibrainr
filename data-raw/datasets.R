### Code to prepare datasets ###
library(googledrive)

### Colours ###
paper.settings = read.csv("/Users/GD/LMBD/Papers/hemibrain_olf_data/settings/paper_colours.csv")
paper_colours = paper.settings$hex
names(paper_colours) = paper.settings$label
paper_colours = paper_colours[order(names(paper_colours))]
paper_colours["neuron"] = "grey80"
usethis::use_data(paper_colours, overwrite = TRUE)

### Match information ###
hemibrain_matched = hemibrain_matches()
lm_matched = lm_matches()
usethis::use_data(hemibrain_matched, overwrite = TRUE)
usethis::use_data(lm_matched, overwrite = TRUE)

### Lineage information ###
hemibrain_hemilineages = read.csv("data-raw/annotations/hemibrain_hemilineages_cbf.csv")
hemibrain_hemilineages = hemibrain_hemilineages[order(hemibrain_hemilineages$cellBodyFiber),]
hemibrain_hemilineages$notes = NULL
hemibrain_hemilineages = hemibrain_hemilineages[hemibrain_hemilineages$cellBodyFiber!="",]
hemibrain_hemilineages = hemibrain_hemilineages[!duplicated(hemibrain_hemilineages$cellBodyFiber),]
rownames(hemibrain_hemilineages) = NULL
hemibrain_hemilineages = as.data.frame(apply(hemibrain_hemilineages,2,function(c) gsub(" ","",c)), stringsAsFactors = FALSE)
usethis::use_data(hemibrain_hemilineages, overwrite = TRUE)

### Olfactory layers ###
hemibrain_olfactory_layers= read.csv("data-raw/annotations/hemibrain_olfactory_layers.csv")
usethis::use_data(hemibrain_olfactory_layers, overwrite = TRUE)

### Access Team Drive
hemibrain = googledrive::team_drive_get(hemibrainr_team_drive())
drive_hemibrain = googledrive::drive_find(type = "folder", team_drive = hemibrain)
hemibrain_drive_csvs = drive_find(type = "csv", team_drive = hemibrain)
hemibrain_drive_data = subset(hemibrain_drive_csvs,grepl("splitpoints|metrics",name))
for(i in 1:nrow(hemibrain_drive_data)){
  drive_download(file = hemibrain_drive_data[i,],
                 path = paste0("data-raw/",hemibrain_drive_data[i,'name']),
                 overwrite = TRUE,
                 verbose = TRUE)
}

### Download the status of the splitsave files
selected_file = "1YjkVjokXL4p4Q6BR-rGGGKWecXU370D1YMc1mgUYr8E"
gs = googlesheets4::read_sheet(ss = selected_file, sheet = "roots")
gs = unlist_df(gs)
manual = googlesheets4::read_sheet(ss = selected_file, sheet = "manual")
manual = unlist_df(manual)
write.csv(gs, file = "data-raw/hemibrain_data/hemibrain_manual/split_pipeline_roots.csv", row.names = FALSE)
write.csv(manual, file = "data-raw/hemibrain_data/hemibrain_manual/split_pipeline_manualsplits.csv", row.names = FALSE)

### Somas
hemibrain_somas = googlesheets4::read_sheet(ss = selected_file, sheet = "somas")
hemibrain_somas = as.data.frame(hemibrain_somas, stringsAsFactors = FALSE)
hemibrain_somas[hemibrain_somas=="NA"] = NA
hemibrain_somas = hemibrain_somas[!is.na(hemibrain_somas$bodyid),]
hemibrain_somas$cellBodyFiber = hemibrain_somas$cbf
hemibrain_somas$cellBodyFiber[is.na(hemibrain_somas$cellBodyFiber)] = hemibrain_somas$clusters[is.na(hemibrain_somas$cellBodyFiber)]
hemibrain_somas$cellBodyFiber[hemibrain_somas$cellBodyFiber=="unknown"] = paste0("unknown_",hemibrain_somas$clusters[hemibrain_somas$cellBodyFiber=="unknown"])
hemibrain_somas$soma.edit = as.logical(hemibrain_somas$soma.edit)
hemibrain_somas$init = NULL
hemibrain_somas$cbf = NULL
hemibrain_somas$soma.checked = NULL
hemibrain_somas$clusters = NULL
hemibrain_somas$wrong.cbf = NULL
rownames(hemibrain_somas) = hemibrain_somas$bodyid
hemibrain_somas = unlist_df(hemibrain_somas)
usethis::use_data(hemibrain_somas, overwrite = TRUE)

### Split points
hemibrain_splitpoints_polypre_centrifugal_distance <- read.csv("data-raw/metrics/hemibrain_all_neurons_splitpoints_polypre_centrifugal_distance.csv")
hemibrain_splitpoints_pre_centrifugal_distance <- read.csv("data-raw/metrics/hemibrain_all_neurons_splitpoints_pre_centrifugal_distance.csv")
hemibrain_splitpoints_polypre_centrifugal_synapses <- read.csv("data-raw/metrics/hemibrain_all_neurons_splitpoints_polypre_centrifugal_synapses.csv")

### Metrics
hemibrain_metrics_polypre_centrifugal_distance <- read.csv("data-raw/hemibrain_all_neurons_metrics_polypre_centrifugal_distance.csv")
hemibrain_metrics_polypre_centrifugal_synapses <- read.csv("data-raw/hemibrain_all_neurons_metrics_polypre_centrifugal_synapses.csv")
rownames(hemibrain_metrics_polypre_centrifugal_distance) <- hemibrain_metrics_polypre_centrifugal_distance$bodyid
rownames(hemibrain_metrics_polypre_centrifugal_synapses) <- hemibrain_metrics_polypre_centrifugal_synapses$bodyid

### Use data
usethis::use_data(hemibrain_splitpoints_pre_centrifugal_distance, overwrite = TRUE)
usethis::use_data(hemibrain_splitpoints_polypre_centrifugal_distance, overwrite = TRUE)
usethis::use_data(hemibrain_splitpoints_polypre_centrifugal_synapses, overwrite = TRUE)
usethis::use_data(hemibrain_metrics_polypre_centrifugal_distance, overwrite = TRUE)
usethis::use_data(hemibrain_metrics_polypre_centrifugal_synapses, overwrite = TRUE)

### Reach consensus
hemibrain_all_splitpoints <- hemibrain_splitpoints_polypre_centrifugal_synapses ### original definition
hemibrain_metrics <- hemibrain_metrics_polypre_centrifugal_synapses ### original definition
selected_file = "1YjkVjokXL4p4Q6BR-rGGGKWecXU370D1YMc1mgUYr8E"
gs = googlesheets4::read_sheet(ss = selected_file, sheet = "roots")
gs = as.data.frame(gs, stringsAsFactors = FALSE)
gs = gs[!duplicated(gs$bodyid),]
manual = googlesheets4::read_sheet(ss = selected_file, sheet = "manual")
manual = as.data.frame(manual, stringsAsFactors = FALSE)
manual = remove_duplicates(manual)
hemibrain_all_splitpoints = subset(hemibrain_all_splitpoints, !bodyid%in%manual$bodyid)
hemibrain_all_splitpoints = plyr::rbind.fill(hemibrain_all_splitpoints,manual)
hemibrain_all_splitpoints$X.1 = NULL
hemibrain_metrics[as.character(gs$bodyid),colnames(gs)] = gs

### Further update metrics based on manual splits
#### To be done on Cluster ####

### Consensus
usethis::use_data(hemibrain_metrics, overwrite = TRUE)
usethis::use_data(hemibrain_all_splitpoints, overwrite = TRUE)

### Surface mesh
hemibrain.surf = readobj::read.obj("data-raw/hemibrain_raw.obj", convert.rgl = TRUE)
hemibrain.surf = nat::as.hxsurf(hemibrain.surf[[1]])
hemibrain_microns.surf = hemibrain.surf*(8/1000)
nat.templatebrains::regtemplate(hemibrain_microns.surf) = "JRCFIB2018F"
nat.templatebrains::regtemplate(hemibrain.surf) = "JRCFIB2018Fraw"
usethis::use_data(hemibrain_microns.surf, overwrite = TRUE)
usethis::use_data(hemibrain.surf, overwrite = TRUE)

### Other roi meshes
# hemibrain_rois = hemibrain_roi_meshes()
# usethis::use_data(hemibrain_rois, overwrite = TRUE)

### AL glomeruli meshes
al.stls = list.files("data-raw/AL/PN/",pattern = ".stl",full.names = TRUE)
al.meshes.stl = sapply(al.stls, readSTL, plot = FALSE)
al.meshes = pbapply::pblapply(al.meshes.stl, as.mesh3d)
gloms = gsub(".*raw\\.|\\_mesh.*|\\.stl","",names(al.meshes))
names(al.meshes) = gloms
Vertices = data.frame(stringsAsFactors = FALSE)
Regions = list()
count = 0
for(i in 1:length(al.meshes)){
  glom = names(al.meshes)[i]
  mesh = al.meshes[[glom]]
  h = nat::as.hxsurf(mesh)
  vertices = h$Vertices
  vertices$PointNo = vertices$PointNo+count
  regions = h$Regions$Interior + count
  count = max(vertices$PointNo)
  Vertices = rbind(Vertices, vertices)
  Regions[[glom]] = regions
}
hemibrain_al.surf = list(Vertices = Vertices,
     Regions = Regions,
     RegionList = gloms,
     RegionColourList = hemibrain_bright_colour_ramp(length(gloms)))
class(hemibrain_al.surf) = "hxsurf"
hemibrain_al_microns.surf = hemibrain_al.surf*(8/1000)
nat.templatebrains::regtemplate(hemibrain_al_microns.surf) = "JRCFIB2018F"
nat.templatebrains::regtemplate(hemibrain_al.surf) = "JRCFIB2018Fraw"
usethis::use_data(hemibrain_al_microns.surf, overwrite = TRUE)
usethis::use_data(hemibrain_al.surf, overwrite = TRUE)

### Same from FAFB
fw.al.objs = list.files("data-raw/AL/FAFB/",pattern = ".obj",full.names = TRUE)
fw.al.meshes = sapply(fw.al.objs, readobj::read.obj, convert.rgl = TRUE)
fw.gloms = basename(gsub(".*raw\\.|\\_mesh.*|\\.obj","",fw.al.objs))
names(fw.al.meshes) = fw.gloms
Vertices = data.frame(stringsAsFactors = FALSE)
Regions = list()
count = 0
for(i in 1:length(fw.al.meshes)){
  glom = names(fw.al.meshes)[i]
  mesh = fw.al.meshes[[glom]]
  h = nat::as.hxsurf(mesh)
  h = nat.templatebrains::xform_brain(h, sample = "FAFB14", reference = "FlyWire", OmitFailures = FALSE, Verbose = FALSE)
  # Save converted .obj files
  plot3d(h)
  writeOBJ(paste0("flywire_right_",glom,".obj"))
  clear3d()
  vertices = h$Vertices
  vertices$PointNo = vertices$PointNo+count
  regions = h$Regions$Interior + count
  count = max(vertices$PointNo)
  Vertices = rbind(Vertices, vertices)
  Regions[[glom]] = regions
}
flywire_al.surf = list(Vertices = Vertices,
                         Regions = Regions,
                         RegionList = fw.gloms,
                         RegionColourList = hemibrain_bright_colour_ramp(length(fw.gloms)))
class(flywire_al.surf) = "hxsurf"
nat.templatebrains::regtemplate(flywire_al.surf) = "FlyWire"
usethis::use_data(flywire_al.surf, overwrite = TRUE)

# Just save the ORN and HRN bodyids
# ton.ids = read.csv("data-raw/annotations/bodyids_thirdorder.csv")
# lhn.ids = read.csv("data-raw/annotations/bodyids_lhns.csv")
lhn.ids = as.character(lhns::hemibrain.lhn.bodyids)
ton.ids = as.character(unique(ton.info$bodyid))
lc.ids = as.character(unique(lc.info$bodyid))
rn.ids = class2ids("RN", possible = TRUE)
orn.ids = class2ids("ORN")
hrn.ids = class2ids("HRN")
pn.ids = class2ids("PN")
upn.ids = class2ids("uPN")
mpn.ids = class2ids("mPN")
vppn.ids = class2ids("VPPN")
alln.ids = class2ids("ALLN")
dan.ids = class2ids("DAN")
mbon.ids = class2ids("MBON")
dn.ids = class2ids("DN")
kc.ids = as.character(unique(kc.info$bodyid))

# Read in other classes
## Let's get some other, easy and popular neuron types
kc.info = neuprint_search("KC.*")
apl.info = neuprint_search(".*APL.*")
cent.info = neuprint_search(".*LHCENT.*|.*PPL201_.*")
kc.ids = as.character(kc.info$bodyid)
apl.ids = as.character(apl.info$bodyid)
cent.ids = as.character(cent.info$bodyid)

## Use them bodyids
usethis::use_data(lhn.ids, overwrite = TRUE)
usethis::use_data(dn.ids, overwrite = TRUE)
usethis::use_data(ton.ids, overwrite = TRUE)
usethis::use_data(rn.ids, overwrite = TRUE)
usethis::use_data(orn.ids, overwrite = TRUE)
usethis::use_data(hrn.ids, overwrite = TRUE)
usethis::use_data(pn.ids, overwrite = TRUE)
usethis::use_data(upn.ids, overwrite = TRUE)
usethis::use_data(mpn.ids, overwrite = TRUE)
usethis::use_data(vppn.ids, overwrite = TRUE)
usethis::use_data(alln.ids, overwrite = TRUE)
usethis::use_data(dan.ids, overwrite = TRUE)
usethis::use_data(mbon.ids, overwrite = TRUE)
usethis::use_data(kc.ids, overwrite = TRUE)
usethis::use_data(apl.ids, overwrite = TRUE)
usethis::use_data(cent.ids, overwrite = TRUE)
usethis::use_data(lc.ids, overwrite = TRUE)

## Some notes on data
# Badly skeletonised: "5812986485"
