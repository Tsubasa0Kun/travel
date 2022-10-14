################################################################################
# UI of the about page
#
# Author: Dongli He
# Created: 13/10/2022 17:12
################################################################################

about <- tabPanel(title = "About us", 
                  value = "about", 
                  br(), hr(),
                  
                  includeHTML(rmarkdown::render('descriptions/Dongli.Rmd')), br(),
                  
                  # includeHTML(rmarkdown::render('descricoes/xxx.Rmd')), br(),
)