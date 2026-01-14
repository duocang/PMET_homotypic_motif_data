library(universalmotif)
library(dplyr)
library(stringr)

# memes <- read_meme("ArabidopsisDAPv1.meme")

args <- commandArgs(trailingOnly = TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (ArabidopsisDAPv1.meme).", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  memes_path <- args[1]
  memes <- read_meme(memes_path)
} else {
  stop("Only one argument must be supplied (ArabidopsisDAPv1.meme).n", call.=FALSE)
}


motif_names     <- c()
motif_alt_names <- c()

for (meme in memes) {
  motif_names <- str_split_1(meme@name, "\\.")[2] %>%
    str_remove_all("_m1|_a|_col|_v31|_v3h|_v3a|_v3b|_b|_d1") %>%
    str_remove_all("_D1") %>%
    toupper() %>%
    c(motif_names , .)
  motif_alt_names <- c(motif_alt_names, meme@altname)
}

cat(paste0("Number of motifs             : ", length(motif_names), "\n"))
cat(paste0("Number of motifs' name       : ", length(motif_names), "\n"))
cat(paste0("Number of unique motifs' name: ", length(unique(motif_names)), "\n"))

for (i in 1:length(memes)) {
  memes[[i]]@name <- motif_names[i]
}

universalmotif::write_meme(memes, file.path(dirname(memes_path), "Plant_Cistrome_DB_parsed.meme"), overwrite = TRUE)
