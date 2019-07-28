#
#
# Jakki Seshapanpu (11915005)
# Manoj Sharma (11915050)
# Utkarsh Agrawal (11915020)
#
#


library("shiny")
require(dplyr)
require(magrittr)
require(tidytext)
library(udpipe)
library(textrank)
library(lattice)
library(igraph)
library(ggraph)
library(ggplot2)
library(wordcloud)
library(stringr)
library(topicmodels)
library(dplyr)
library(RColorBrewer)
library(stringr)

# Define ui function
shinyUI(
  fluidPage(
    
    titlePanel("Building a Shiny App around the UDPipe NLP workflow"),
    
    sidebarLayout( 
      
      sidebarPanel(  
        
        fileInput("file", "Upload a text file "),
        
        selectInput("select_var", "Model", 
                    c("english-ewt", "english-gum", "english-lines", "english-partut"), selected = "english-ewt"),
        
        checkboxGroupInput("input_selection", "select list of Universal part-of-speech tags (upos)",
                           c("adjective (ADJ)" = "adj",
                             "noun(NOUN)" = "noun",
                             "proper noun (PROPN)" = "propn",
                             "adverb (ADV)" = "adv",
                             "verb (VERB)" = "verb"),
                           selected = c("adjective (ADJ)" = "adj",
                                        "noun(NOUN)" = "noun",
                                        "proper noun (PROPN)" = "propn"),
                           inline = FALSE)),
      mainPanel(
        
        tabsetPanel(type = "tabs",
                    
                    tabPanel("Description about this app", h4(p("Workflow about using this app")),
                             
                       p("This Shiny App related to UDPipe NLP workflow.\n\n 
                       Upload the file by clicking the browse button on the left side. \n\n
                       After uploading the file, select the model. \n\n
                       Then select the Universal part-of-speech tags from the selection check boxes. \n\n
                       Now select on tab(annotated documents or wordclouds or co-ocurrences) to see the results ", align = "justify")),
  
                             
                    tabPanel("Annotated documents", 
                             h4(p("Download Annotated document file")),
                             downloadButton('downloadData1', 'Download Annotated document file'),br(),br(),
                             
                             h4(p("Display of the annotated documents")),
                             dataTableOutput('annotated_df')),
                    
                    tabPanel("Word clouds",
                             h4("Nouns Word Cloud"),
                             plotOutput("nouns_wordcloud",height = 700, width = 700),
                             
                             h4("Verbs Word Cloud"),
                             plotOutput("verbs_wordcloud",height = 700, width = 700)),
                    
                    tabPanel("Co-occurrences ",
                             h4("Co occurrences Graph "),
                             plotOutput('Co_occurrences_Graph'))
               
        ) # end of tabsetPanel
      )# end of main panel
    ) # end of sidebarLayout
  )  # end if fluidPage
) # end of UI


