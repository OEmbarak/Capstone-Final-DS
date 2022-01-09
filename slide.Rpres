Capstone Project: Final Project
========================================================
author: Ossama Embarak
date: 4/1/2022

The project makes use of Ngram modeling to predict words.


Introduction
========================================================
type: sub-section
<span style="color:red; font-weight:bold; font-size:0.7em">This presentation was developed as part of the Coursera Data Science Capstone Course requirement. </span>

<font size="5">
The project's purpose is to create a predictive text model combined with a shiny app UI that will guess the next word as the user types a sentence, similar to how most smart phone keyboards are implemented today utilizing Swiftkey technology.

*[Shiny App]* - [https://phng.shinyapps.io/capstone]

*[Github Repo]* - [https://github.com/justusfrantz/capstone]

</font>

Read, Sample & Cleaning Text Data
========================================================
type: sub-section

<span style="color:red; font-size:0.9em">Data is initially processed and sanitized before the word prediction algorithm is built, as shown in the stages below:</span>

<font size="5">

- A portion of the original data from the three sources (blogs, Twitter, and news) was sampled and then blended into one.
- Following that, data is cleaned by converting it to lowercase, removing white space, and deleting punctuation and numbers.
- After that, the relevant n-grams are produced (Quadgram,Trigram and Bigram).
- The term-count tables are then extracted from the N-Grams and sorted in descending order according to frequency.
- Finally, R-Compressed files are created from the n-gram objects (.RData files).

</font>



Word Prediction Model
========================================================
type: sub-section

<span style="color:red; font-size:0.9em"> The Katz Back-off technique is used in the prediction model for the next word. The following is an explanation of the next word prediction flow:</span>

<font size="5">

- The first data sets imported are compressed data sets with descending frequency sorted n-grams.
- Before predicting the following word, user input words are cleaned in the same manner as before.
- Quadgram is initially used to forecast the next word where the first three words of Quadgram are the last three words of the user provided sentence.
- If you can't find a Quadgram, switch to Trigram where first two words of Trigram are the last two words of the sentence.
- If you can't find a Trigram, go back to Bigram where the first word of Bigram is the last word of the sentence
-If no Bigram is detected, the most common word with the highest frequency is returned, which is 'the.'

</font>

Shiny Application
========================================================
type: sub-section

<span style="color:red; font-weight:bold;font-size:0.7em">As demonstrated below, a Shiny application was created using the previously mentioned next word prediction model. </span><img src="./www/app.png"></img>
