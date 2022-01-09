### Data Science Capstone : Final Project
suppressWarnings(library(shiny))
suppressWarnings(library(markdown))
shinyUI(navbarPage("Capstone Final Project",
                   tabPanel("Next Word Prediction",
                            HTML("<strong>Author: Ossama Embarak</strong>"),
                            br(),
                            HTML("<strong>Date: 2/1/2022</strong>"),
                            br(),
                            br(),
                            # Sidebar
                              sidebarLayout(
                              sidebarPanel(
                                helpText("Enter a sentence to begin the prediction"),
                                textInput("inputString", "Enter a sentence words",value = ""),
                                br(),
                                br(),
                                ),
                              mainPanel(
                                  h2("Predicted the Next Word"),
                                  verbatimTextOutput("prediction"),
                                  strong("Sentence Input:"),
                                  tags$style(type='text/css', '#text1 {background-color: rgba(255,255,0,0); color: red;}'), 
                                  textOutput('text1'),
                                  br(),
                                  strong("Note:"),
                                  tags$style(type='text/css', '#text2 {background-color: rgba(255,255,0,0); color: blue;}'),
                                  textOutput('text2')
                              )
                              )
                             
                  ),
                   tabPanel("About the project",
                            mainPanel(
                              includeMarkdown("about_Project.md")
                            )
                   )
)
)