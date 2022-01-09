### Data Science Capstone : Final Project
suppressWarnings(library(tm))
suppressWarnings(library(stringr))
suppressWarnings(library(shiny))

# Load n-gram data files 
quadgram <- readRDS("./ShinyApp/quadgram.RData");
trigram <- readRDS("./ShinyApp/trigram.RData");
bigram <- readRDS("./ShinyApp/bigram.RData");
mesg <<- ""

# DaTA CLEANING 

Predict <- function(x) {
  xclean <- removeNumbers(removePunctuation(tolower(x)))
  xtoken <- strsplit(xclean, " ")[[1]]
  
# ALGORITHMS USED FOR PREDICTING NEEXT WORD 
# 1. Quadgram: use the first three words for prediction
# 2. Trigram: use the first two words for prediction 
# 3. Bigram: use the first word for prediction
# 4. If no ngram detected, then the most common word with highest frequency 'the' is returned.


  if (length(xtoken)>= 3) {
    xtoken <- tail(xtoken,3)
    if (identical(character(0),head(quadgram[quadgram$unigram == xtoken[1] & quadgram$bigram == xtoken[2] & quadgram$trigram == xtoken[3], 4],1))){
      Predict(paste(xtoken[2],xtoken[3],sep=" "))
    }
    else {mesg <<- "The 4-gram model is used for prediction."; head(quadgram[quadgram$unigram == xtoken[1] & quadgram$bigram == xtoken[2] & quadgram$trigram == xtoken[3], 4],1)}
  }
  else if (length(xtoken) == 2){
    xtoken <- tail(xtoken,2)
    if (identical(character(0),head(trigram[trigram$unigram == xtoken[1] & trigram$bigram == xtoken[2], 3],1))) {
      Predict(xtoken[2])
    }
    else {mesg<<- "The 3-gram model is used for prediction."; head(trigram[trigram$unigram == xtoken[1] & trigram$bigram == xtoken[2], 3],1)}
  }
  else if (length(xtoken) == 1){
    xtoken <- tail(xtoken,1)
    if (identical(character(0),head(bigram[bigram$unigram == xtoken[1], 2],1))) {mesg<<-"No match found. Most common word 'the' is returned."; head("the",1)}
    else {mesg <<- "The 2-gram model is used for prediction."; head(bigram[bigram$unigram == xtoken[1],2],1)}
  }
}

shinyServer(function(input, output) {
    output$prediction <- renderPrint({
    result <- Predict(input$inputString)
    output$text2 <- renderText({mesg})
    result
  });
  
  output$text1 <- renderText({
    input$inputString});
}
)