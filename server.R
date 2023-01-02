#######################################################################
# shiny server

library(shiny)
library(dplyr)
library(dbplyr)
library(stringr)

source('setup.R')

shinyServer(
  
  function(input, output, session) {
    
    # get user database
    conn <- DBI::dbConnect(RSQLite::SQLite(), dbfile)
    userbase <- tbl(conn, 'users')
    
    # check conditions on user input
    username_success <- reactive({
      taken <- userbase %>% 
        collect() %>% # note shiny inputs can't be translated to SQL 
        transmute(x = (user == input$username)) %>% 
        summarise(sum(x)) %>% 
        as.integer()
      # return
      taken == 0
    })
    email_success <- reactive({
      input$email %>% str_detect(email_pattern)
    })
    password_success <- reactive({
        (input$password1 == input$password2) &
        nchar(input$password1) >= min_pwd_len
    })
    
    # update database on successful input
    success <- reactive({
      if(username_success() & email_success() & password_success()){
        # add user to database
        newentry <- data.frame(user = input$username,
                               email = input$email,
                               password = sodium::password_store(input$password1),
                               permissions = 'standard'
        )
        DBI::dbAppendTable(conn, 'users', newentry)
        # return
        TRUE
      } else {
        # return
        FALSE
      }
    })
    
    # response back to user
    output$response <- renderText({
      # return 
      if(success()){
        "<b0>Registration successful. <a href = 'http://blitscansql.uksouth.azurecontainer.io:3838//'>Return to login page.</a></b0>"
      } else if(input$username != "" & !username_success()){
        "<b1>Username already taken...</b1>"
      } else if(input$email != "" & !email_success()){
        "<b1>Invalid email address...</b1>"
      } else if(input$password2 != "" & !password_success()) {
        "<b1>Invalid password - either fails to match or not strong enough ...</b1>"
      }
    })
    
    # header and footer
    output$header <- renderText({
      "<h1 id='logo'><a href='https://www.birdlife.org/'><img src='birdlifeinternational.jpg' alt='logo' width=160></a> LitScan - register here</h1>
      <hr>
    "
    })
    output$footer <- renderText({
      "<hr>
       <a href='mailto: bill.oxbury@birdlife.org'>&#169; BirdLife International 2022</a>"
    })
}) 