# APP TO UPDATE BLITSCAN USER DATABASE

library(shiny)

shinyUI(
  
  fluidPage(
    
    # suppresses spurious 
    # 'progress' error messages after all the debugging 
    # is done:
    #tags$style(type="text/css",
    #           ".shiny-output-error { visibility: hidden; }",
    #           ".shiny-output-error:before { visibility: hidden; }"
    #),
    HTML("<style>
       b0 {
         color: blue;
       }
       b1 {
         color: red;
       }
       </style>"),
    htmlOutput("header"),
    textInput("username", 
              label = "User name:", 
              value = ""),
    textInput("email", 
              label = "Email:", 
              value = ""),
    passwordInput("password1", 
                  label = "Password:", 
                  value = ""),
    passwordInput("password2", 
                  label = "Confirm password:", 
                  value = ""),
    htmlOutput("response"),
    htmlOutput("footer")
  )
)
