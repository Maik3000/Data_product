library(shiny)
library(DT)

# Define UI for application with plot interactions
fluidPage(
  
  # Application title
  titlePanel("Interacción Gráfica con mtcars"),
  
  # Tabset for plot interactions
  tabsetPanel(
    tabPanel("Plot interactions",
             plotOutput("plot_click_options",
                        click = 'clk_data',
                        dblclick = "dclk",
                        hover = 'mhover',
                        brush = 'mbrush'),
             verbatimTextOutput("click_data"), # Imprime el valor de las variables seleccionadas
             DTOutput('mtcars_tbl')  # Usar DT para la tabla interactiva
    )
  )
)

