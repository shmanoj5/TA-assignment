
library(shiny)
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

shinyServer(function(input, output) {
  
  
  ###########################################################
  dataset <- reactive({
    
    if (is.null(input$file)) {return(NULL)}
    else {
      
      dataset = readLines(input$file$datapath)
      dataset  =  str_replace_all(dataset, "<.*?>", "")
      return(dataset)}
    
  })
  
  ###########################################################
  ## annotated df
  annotated_df_calculator <- reactive({
    
    m_type = udpipe_load_model("C:\\Users\\sharm\\Downloads\\ShinyApp\\english-ewt-ud-2.4-190531.udpipe")
    
    x <- udpipe_annotate(m_type, x = dataset())
    x <- select(as.data.frame(x),-sentence)
    x
    head(x,100)
    return(x)
  })
  output$annotated_df <- renderDataTable({ annotated_df_calculator() })
  
  ###########################################################
  #wc(nouns)
  nouns_wordcloud_calculator <- reactive({
    df = annotated_df_calculator()
    all_nouns = df %>% subset(., upos %in% "NOUN"); all_nouns$token[1:20]
    top_nouns = txt_freq(all_nouns$lemma)
    wordcloud(words = top_nouns$key, 
              freq = top_nouns$freq,
              min.freq = 1, 
              max.words = 1000,
              random.order = FALSE, 
              colors = brewer.pal(6, "Dark2"))
  }) #end of function
  output$nouns_wordcloud<-renderPlot({ nouns_wordcloud_calculator() })
  
  ###########################################################
  #wc(verbs)
  verbs_wordcloud_calculator <- reactive({
    df = annotated_df_calculator()
    all_verbs = df %>% subset(., upos %in% "VERB"); all_verbs$token[1:20]
    top_verbs = txt_freq(all_verbs$lemma)
    wordcloud(words = top_verbs$key, 
              freq = top_verbs$freq,
              min.freq = 1, 
              max.words = 1000,
              random.order = FALSE, 
              colors = brewer.pal(6, "Dark2"))
  }) #end of function
  output$verbs_wordcloud<-renderPlot({ verbs_wordcloud_calculator() })
  
  ###########################################################
  #co occurances graph
  Co_occurrences_Graph_calculator <- reactive({
    
    x = annotated_df_calculator()
    
    nokia_cooc <- cooccurrence(     # try `?cooccurrence` for parm options
      x = subset(x, upos %in% c("NOUN", "ADJ")), 
      term = "lemma", 
      group = c("doc_id", "paragraph_id", "sentence_id"))  # 0.02 secs
    
    wordnetwork <- head(nokia_cooc, 50)
    wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
    
    ggraph(wordnetwork, layout = "fr") +  
      
      geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
      geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
      
      theme_graph(base_family = "Arial Narrow") +  
      theme(legend.position = "none") +
      
      labs(title = "Cooccurrences within 3 words distance", subtitle = "Nouns & Adjective")
    
  }) #end of function
  
  
  
  
  
  ###########################################################

  output$Co_occurrences_Graph<-renderPlot({ Co_occurrences_Graph_calculator() })
  
}) 
