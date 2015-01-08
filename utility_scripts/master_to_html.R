master_to_html <- function(RepoDir){
  file <- file.path(RepoDir, "StatsNotesMaster.Rmd")  
  text <- readLines(file)
  
  #* Modify YAML header
  text[grepl("pdf_document:", text)] <- 
    sub("pdf_document", "html_document", text[grepl("pdf_document:", text)])
  text[grepl("number_sections: yes", text)] <- 
    sub("yes", "no", text[grepl("number_sections: yes", text)])
  text[grepl("fig_caption: yes", text)] <- 
    sub("yes", "no", text[grepl("fig_caption: yes", text)])
  
  #* Convert \part to # 
  part_lines <- grep("\\\\part[{]", text)
  text[part_lines] <- gsub("\\\\part[{]", "# ", text[part_lines])
  text[part_lines] <- sub("\\s+$", "", text[part_lines], perl=TRUE)
  text[part_lines] <- substr(text[part_lines], 1, nchar(text[part_lines])-1)
  
  #* Find lines with children
  child_lines <- grep("```[{]r, child=", text)
  text[child_lines] <- gsub("(```[{]r, child=\"|\"[}])", "", text[child_lines])
  text[child_lines] <- gsub("md_to_pdf", "md_to_html", text[child_lines])
  
  
  
  children <- lapply(file.path(RepoDir, text[child_lines]), readLines)
  children <- lapply(children, 
                     function(child){ 
                       heads <- child[c(2, which(substr(child, 1, 1) == "#"))]
                       heads[1] <- sub("  title:", "", heads[1])
                       heads <- sub(" ", " [", heads)
                       heads <- paste0("#", heads, "]")
                       heads <- sub("# ", "* ", heads)
                       heads <- gsub("#", "    ", heads)
                       heads
                     })
                       
  hash <- lapply(children,
                 function(child){
                   child <- sub("[[:space:]]+[*] ", "", child)
                   child <- gsub("-", " ", child)
                   child <- gsub("#", "", child)
                   child <- substr(child, 2, nchar(child))
                   child <- gsub("[[:punct:]]", "", child)
                   child <- tolower(child)
                   child <- gsub(" ", "-", child)
                   child <- paste0("#", child)
                   child[1] <- ""
                   return(child)
                 })
  
  for (i in 1:length(text[child_lines])){
    hash[[i]] <- paste0("(", text[child_lines][i], "", hash[[i]], ")")
    hash[[i]] <- sub("[.]Rmd", ".html", hash[[i]])
    hash[[i]] <- sub("md_to_html", "html_files", hash[[i]])
    children[[i]] <- paste0(children[[i]], hash[[i]])
  }
  
  children <- sapply(children, paste, collapse="\n")
  text[child_lines] <- children
  text[child_lines + 1] <- ""
  
  write(text, file.path(RepoDir, "StatsNotes_html.Rmd"), sep="\n")
  render(file.path(RepoDir, "StatsNotes_html.Rmd"),
         "html_document")
  file.rename(file.path(RepoDir, "StatsNotes_html.html"),
              file.path(RepoDir, "index.html"))
}