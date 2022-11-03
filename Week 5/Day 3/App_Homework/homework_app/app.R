library(shiny)
library(tidyverse)
library(janitor)
library(bslib)

install.packages("ggdark")

library(ggdark)

imdb_movies <- read_csv(here::here("imdb_movies.csv")) %>% clean_names()

# view(imdb_movies)

# App that shows the five highest rated movies for the last 5 years 
# each tab is a different year

genre <- imdb_movies %>% 
  distinct(main_genre) %>% 
  arrange()

year <- imdb_movies %>% 
  distinct(year) %>% 
  arrange()

year


ui <- fluidPage(
  theme = bs_theme(
    bg = "#101010", 
    fg = "#FDF7F7", 
    primary = "#ED79F9", 
    base_font = font_google("Prompt"),
    code_font = font_google("JetBrains Mono")
  ),
  titlePanel("Movie Rating Comparison"),
  
  
  tabsetPanel(
    tabPanel("Movie Rating Summary",
             
             fluidRow(
               plotOutput("movie_plot"),
               tags$a("IMDb Website", 
                      href = "https://www.imdb.com/")
             ),
             
             fluidRow(
               column(
                 6,
                 # genre input
                 selectInput(
                   inputId = "main_genre",
                   label = "Select a genre",
                   choices = genre
                 )
               ),
               column(
                 6,
                 # year input
                 selectInput(
                   inputId = "year",
                   label = "Select a year",
                   choices = year
                 )
               )
             )
    ),
    
    tabPanel(
      title = "About",
      
      "This dashboard shows movies ratings that achieved or exceeded a rating of
      8.0 based on year and genre"
    ),
      #content
  ),
  
)
  
 
    mainPanel(plotOutput("movie_plot"))

server <- function(input, output) {
  output$movie_plot <- renderPlot(
    imdb_movies %>% 
      filter(rating >= 8.0) %>%
      filter(main_genre == input$main_genre) %>%
      filter(year == input$year) %>%
      ggplot() +
      aes(x = movie_title, y = rating) +
      geom_col() +
      coord_flip() +
      scale_y_continuous(breaks = seq(1,10)) +
      labs(x = "Movie Title", y = "Movie")
    )
}

shinyApp(ui, server)
