Notes on Statistical Theory
===============

## Some Notes on my Notes
This is my sad attempt to compile all of my notes in statistics in one place where I can reference them.  They will be primarily used to help me brainstorm ideas on how to implement
various ideas in R packages, and to give justification for some of my choices there.

I really wanted two different formats for these notes.  On the one hand, a PDF that was completely self contained was attractive.  But the idea of a set of webpages to which I could direct myself or others seemed too good to pass up.  Using R markdown, it seemed I could have
both options with just some minor adjustments from the PDF to the HTML design.

Some of the decisions I had to make for this:
1. All of the design is done in the files in the `/md_to_pdf` subdirectory.  These files are
rendered to PDFs and it seemed easier to convert section headings from the LaTeX style 
commands to the markdown style commands, as opposed to the other direction.
2. There are no chapter numbers.  There's probably will be no index either.  It seemed 
more intuitive to present the chapters in alphabetical order, and so I can't guarantee the
order of the chapters will remain the same forever.  Instead, I've ommitted chapter number, and
sections should be referenced as "Bernoulli Distribution 1.1," for example.


## Rendering the PDF

First, you will need to define `RepoDir` as the directory to which you have cloned
the project.  After doing that, you can run the following code:

```r
RepoDir <- ""
library(knitr)
library(rmarkdown)
rmarkdown::render(file.path(RepoDir, "StatsNotesMaster.Rmd"),
                  "pdf_document")
```

This will update the pdf in your local copy.  Changes to the PDF are not tracked in the 
project.


## Rendering the HTML

The HTML files are an adaptation of the PDF. The primary difference is that the HTML files
render each chapter as a separate web page.  The make the adaptations, use the following 
code:

```r
RepoDir <- ""
source(file.path(RepoDir, "utility_scripts/markdown_pdf_to_html.R"))
ConvertPDFtoHTML(RepoDir)
```

Please remember that changes to the files in the `/md_to_html` subdirectory are *not* tracked and will not be committed.  Changes must be made to the files in `/md_to_pdf` subdirectory.