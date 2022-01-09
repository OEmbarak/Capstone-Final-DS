# Preload required R librabires
library(tm)
library(ggplot2)
library(RWeka)
library(R.utils)
library(dplyr)
library(parallel)
library(wordcloud)
library(rJava)


blogs <-readLines("./data/en_US.blogs.txt" ,warn=FALSE,encoding="UTF-8")
news <-readLines("./data/en_US.news.txt" ,warn=FALSE,encoding="UTF-8")
twitter <-readLines("./data/en_US.twitter.txt" ,warn=FALSE,encoding="UTF-8")


Sample_Text <- function(Filetext) {
  taking <- sample(1:length(Filetext), length(Filetext)* 0.005)
  Sample_Text <- Filetext[taking]
  Sample_Text
}


# sampling text files 
set.seed(65364)
SampleBlog <- Sample_Text(blogs)
SampleNews <- Sample_Text(news)
SampleTwitter <- Sample_Text(twitter)

# Combine sampled texts into one variable
SampleAll <- c(SampleBlog, SampleNews, SampleTwitter)

# write sampled texts into text files for further analysis
writeLines(SampleAll, "./Sampling/SampleAll.txt")


##Data Cleaning

##Next, the corpus was converted to lowercase, strip white space, and removed punctuation and numbers.

CleanCorpus <- function (CorpusText) {
  CorpusText <- tm_map(CorpusText, content_transformer(tolower))
  CorpusText <- tm_map(CorpusText, stripWhitespace)
  CorpusText <- tm_map(CorpusText, removePunctuation)
  CorpusText <- tm_map(CorpusText, removeNumbers)
  CorpusText
}

SampleAll <- VCorpus(DirSource("./Sampling", encoding = "UTF-8"))

# tokenizing sampled text 
SampleAll <- CleanCorpus(SampleAll)

# Define function to create  N grams 
NGrams <- function (CorpusText, n) {
  NgramTokenizer <- function(x) {RWeka::NGramTokenizer(x, RWeka::Weka_control(min = n, max = n))}
  TDM_Ngram <- TermDocumentMatrix(CorpusText, control = list(tokenizer = NgramTokenizer))
  TDM_Ngram
}

# Define function to extract the N grams and sort the text 
SortedNgramdf <- function (TDM_Ngram) {
  NgramMRTX <- as.matrix(TDM_Ngram)
  Ngram_df <- as.data.frame(NgramMRTX)
  colnames(Ngram_df) <- "Count"
  Ngram_df <- Ngram_df[order(-Ngram_df$Count), , drop = FALSE]
  Ngram_df
}


# Calculate text values in each N-Gram
Ngram_1 <- NGrams(SampleAll, 1)
Ngram_2 <- NGrams(SampleAll, 2)
Ngram_3 <- NGrams(SampleAll, 3)
Ngram_4 <- NGrams(SampleAll, 4)


# Extract term-count tables from N-Grams and sort 
Ngram_1df <- SortedNgramdf(Ngram_1)
Ngram_2df <- SortedNgramdf(Ngram_2)
Ngram_3df <- SortedNgramdf(Ngram_3)
Ngram_4df <- SortedNgramdf(Ngram_4)


# Save data into a CSV files and save the models outputs into r-compressed files

BigramTM <- data.frame(rows=rownames(Ngram_2df),count=Ngram_2df$Count)
BigramTM$rows <- as.character(BigramTM$rows)
BigramTM_split <- strsplit(as.character(BigramTM$rows),split=" ")
BigramTM <- transform(BigramTM,first = sapply(BigramTM_split,"[[",1),second = sapply(BigramTM_split,"[[",2))
BigramTM <- data.frame(unigram = BigramTM$first,BigramTM = BigramTM$second,freq = BigramTM$count,stringsAsFactors=FALSE)
write.csv(BigramTM[BigramTM$freq > 1,],"./ShinyApp/BigramTM.csv",row.names=F)
BigramTM <- read.csv("./ShinyApp/BigramTM.csv",stringsAsFactors = F)
saveRDS(BigramTM,"./ShinyApp/BigramTM.RData")


TrigramTM <- data.frame(rows=rownames(Ngram_3df),count=Ngram_3df$Count)
TrigramTM$rows <- as.character(TrigramTM$rows)
TrigramTM_split <- strsplit(as.character(TrigramTM$rows),split=" ")
TrigramTM <- transform(TrigramTM,first = sapply(TrigramTM_split,"[[",1),second = sapply(TrigramTM_split,"[[",2),third = sapply(TrigramTM_split,"[[",3))
TrigramTM <- data.frame(unigram = TrigramTM$first,BigramTM = TrigramTM$second, TrigramTM = TrigramTM$third, freq = TrigramTM$count,stringsAsFactors=FALSE)
write.csv(TrigramTM[TrigramTM$freq > 1,],"./ShinyApp/TrigramTM.csv",row.names=F)
TrigramTM <- read.csv("./ShinyApp/TrigramTM.csv",stringsAsFactors = F)
saveRDS(TrigramTM,"./ShinyApp/TrigramTM.RData")


QuadgramTM <- data.frame(rows=rownames(Ngram_4df),count=Ngram_4df$Count)
QuadgramTM$rows <- as.character(QuadgramTM$rows)
QuadgramTM_split <- strsplit(as.character(QuadgramTM$rows),split=" ")
QuadgramTM <- transform(QuadgramTM,first = sapply(QuadgramTM_split,"[[",1),second = sapply(QuadgramTM_split,"[[",2),third = sapply(QuadgramTM_split,"[[",3), fourth = sapply(QuadgramTM_split,"[[",4))
QuadgramTM <- data.frame(unigram = QuadgramTM$first,BigramTM = QuadgramTM$second, TrigramTM = QuadgramTM$third, QuadgramTM = QuadgramTM$fourth, freq = QuadgramTM$count,stringsAsFactors=FALSE)
write.csv(QuadgramTM[QuadgramTM$freq > 1,],"./ShinyApp/QuadgramTM.csv",row.names=F)
QuadgramTM <- read.csv("./ShinyApp/QuadgramTM.csv",stringsAsFactors = F)
saveRDS(QuadgramTM,"./ShinyApp/QuadgramTM.RData")


