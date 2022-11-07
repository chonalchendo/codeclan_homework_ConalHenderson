library(shiny)
library(bslib)

ui <- fluidPage(
  theme = bs_theme(
    bg = "#101010", 
    fg = "#FDF7F7", 
    primary = "#ED79F9", 
    base_font = font_google("Prompt"),
    code_font = font_google("JetBrains Mono")
  ),
  titlePanel("Game Data Dashboard"),
  
  
  tabsetPanel(
    tabPanel("Best Selling Games",
             
             fluidRow(
               plotOutput("game_plot"),
             ),
             
             fluidRow(
               column(
                 6,
                 # genre input
                 selectInput(
                   inputId = "publisher",
                   label = "Select a Publisher",
                   choices = publisher
                 )
               ),
               column(
                 6,
                 # year input
                 selectInput(
                   inputId = "year",
                   label = "Select a Year",
                   choices = year
                 )
               )
             )
    ),
    
    tabPanel(
      title = "Year on Year Sales",
      
      fluidRow(
        plotOutput("sales_plot")
      ),
      
      fluidRow(
        column(
          6,
          selectInput(
            inputId = "platform",
            label = "Choose a Platform",
            choices = platform
          )
        )
      )
    ),
    
    tabPanel(
      title = "Filter by Rating",
      
      radioButtons(
        inputId = "rating",
        label = "Select a Rating",
        choices = rating,
        inline = TRUE
      ),
      
      DT::dataTableOutput("table_games")
      
    )
  )
)

mainPanel(plotOutput("game_plot"))

server <- function(input, output, session) {
  
  output$game_plot <- renderPlot(
    game_sales %>%
      filter(publisher == input$publisher) %>%
      filter(year_of_release == input$year) %>%
      ggplot() +
      aes(x = reorder(name, sales), y = sales) +
      geom_col(fill = "#ff1493") +
      theme(legend.position = "none") +
      theme_bw() +
      coord_flip()  +
      labs(x = "Game Title", y = "Sales")
  )
  
  output$sales_plot <- renderPlot(
    game_sales %>% 
      filter(platform == input$platform) %>% 
      select(platform, sales, year_of_release) %>% 
      group_by(year_of_release) %>% 
      summarise(total_sales = sum(sales)) %>% 
      ungroup() %>% 
      ggplot() + 
      aes(x = year_of_release, y = total_sales) +
      geom_line(linetype = "dashed") +
      geom_point(size = 4, shape = 22, colour = "darkred", fill = "pink") +
      labs(x = "Year", y = "Total Sales", title = "Total Game Sales Year on Year")
  )
  
  output$table_games <- DT::renderDataTable({
    game_sales %>% 
      filter(rating == input$rating)
  })
}

shinyApp(ui, server)
