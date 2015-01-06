ConvertPDFtoHTML <- function(RepoDir){
  if (!require(knitr)){
    install.packages("knitr")
    library(knitr)
  }
  if (!require(rmarkdown)){
    install.packages("rmarkdown")
    library(rmarkdown)
  }
  #* Determine the file path and file names of the Rmarkdown documents.
  #* Only the Rmarkdown documents in "md_to_pdf" should be edited.
  #* This script will then make the appropriate changes to the HTML versions.
  MdFilePath <- file.path(RepoDir, "md_to_pdf")
  MdFileNames <- list.files(MdFilePath)
  MdFileNames <- MdFileNames[grepl("[.]Rmd", MdFileNames)]
  MdFiles <- file.path(MdFilePath, MdFileNames)

  #* Read in the PDF markdown
  Md_pdf <- lapply(MdFiles, readLines)

  #* Replace section headings with HTML section headings
  removeSectionHeading <- function(t, sec){
    hash <- switch(sec,
                   "section" = "# ",
                   "subsection" = "## ",
                   "subsubsection" = "### ",
                   "paragraph" = "#### ",
                   "subparagraph" = "##### ")
    sec <- paste0("\\\\", sec, "[{]")
    sec.line <- grep(sec, t)
    t[sec.line] <- gsub(sec, hash, t[sec.line])
    t[sec.line] <- gsub("[}]", "", t[sec.line])
    return(t)
  }

  Md_html <- lapply(Md_pdf, removeSectionHeading, "section")
  Md_html <- lapply(Md_html, removeSectionHeading, "subsection")
  Md_html <- lapply(Md_html, removeSectionHeading, "subsubsection")
  Md_html <- lapply(Md_html, removeSectionHeading, "paragraph")
  Md_html <- lapply(Md_html, removeSectionHeading, "subparagraph")

  #* Replace 'aligned' environment with 'align' environment
  Md_html <- lapply(Md_html, function(text) gsub("\\\\begin[{]aligned[}]",
                                                 "\\\\begin{align}", text))
  Md_html <- lapply(Md_html, function(text) gsub("\\\\end[{]aligned[}]",
                                                 "\\\\end{align}", text))

  #* Write the new HTML markdown files to the "md_to_html" directory
  for(i in 1:length(Md_html)){
    write(Md_html[[i]], file=file.path(RepoDir, "md_to_html", MdFileNames[i]),
          sep="\n")
  }

  #* Render the HTML files and store them in the "html_document" folder
  for(i in 1:length(MdFileNames)){
    rmarkdown::render(file.path(RepoDir, "md_to_html", MdFileNames[i]),
                      "html_document")
    file.rename(file.path(RepoDir, "md_to_html", gsub("[.]Rmd", ".html", MdFileNames[i])),
                file.path(RepoDir, "html_files", gsub("[.]Rmd", ".html", MdFileNames[i])))
  }
}