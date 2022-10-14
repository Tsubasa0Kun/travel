################################################################################
# Server of the about page
#
# Author: Dongli He
# Created: 13/10/2022 18:28
################################################################################

output$about <- renderUI({
  
  p1 <- includeMarkdown('descriptions/Dongli.md')
  
  # p2 <- includeMarkdown('descriptions/xx.md')
  # 
  # p3 <- includeMarkdown('descriptions/xx.md')
  # 
  # p4 <- includeMarkdown('descriptions/xx.md')
  
  paste(p1)  # , br(), #p2, br(), p3, br(), p4)
  
})

