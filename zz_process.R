RepoDir <- "C:/Users/nutterb/Documents/GitHub/StatisticsNotes"

# Process PDF
library(knitr)
library(rmarkdown)
rmarkdown::render(file.path(RepoDir, "StatsNotesMaster.Rmd"),
                  "pdf_document")

# Process HTML
source(file.path(RepoDir, "utility_scripts/markdown_pdf_to_html.R"))
source(file.path(RepoDir, "utility_scripts/master_to_html.R"))
ConvertPDFtoHTML(RepoDir)
master_to_html(RepoDir)
