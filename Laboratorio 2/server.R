library(shiny)
library(ggplot2)
library(dplyr)
library(DT)

# Define server logic required to handle plot interactions
function(input, output, session) {
  
  # Estado inicial: mostrar todos los puntos en negro y la tabla completa
  plot_data <- reactiveVal(mtcars)
  point_colors <- reactiveVal(rep("black", nrow(mtcars)))
  
  # Gráfico con interacciones
  output$plot_click_options <- renderPlot({
    plot_data_df <- plot_data()
    colors <- point_colors()
    
    plot(plot_data_df$wt, plot_data_df$mpg, col = colors, pch = 19, xlab = "wt", ylab = "Millas por galón")
  })
  
  # Mostrar información de las interacciones
  output$click_data <- renderPrint({
    clk_msg <- NULL
    dbl_msg <- NULL
    hover_msg <- NULL
    brush_msg <- NULL
    
    if (!is.null(input$clk_data$x)) {
      clk_msg <- paste0("Click en coordenada x = ", round(input$clk_data$x, 2), 
                        ", y = ", round(input$clk_data$y, 2))
    }
    
    if (!is.null(input$dclk$x)) {
      dbl_msg <- paste0("Doble click en coordenada x = ", round(input$dclk$x, 2), 
                        ", y = ", round(input$dclk$y, 2))
    }
    
    if (!is.null(input$mhover$x)) {
      hover_msg <- paste0("Hover en coordenada x = ", round(input$mhover$x, 2), 
                          ", y = ", round(input$mhover$y, 2))
    }
    
    if (!is.null(input$mbrush$xmin)) {
      brush_msg <- paste0('Rango en x = (', round(input$mbrush$xmin, 2), ', ', 
                          round(input$mbrush$xmax, 2), ')\n',
                          'Rango en y = (', round(input$mbrush$ymin, 2), ', ', 
                          round(input$mbrush$ymax, 2), ')')
    }
    
    cat(clk_msg, dbl_msg, hover_msg, brush_msg, sep = '\n')
  })
  
  # Cambiar colores con interacciones
  observeEvent(input$clk_data, {
    colors <- point_colors()
    idx <- nearPoints(mtcars, input$clk_data, xvar = "wt", yvar = "mpg", allRows = TRUE)$selected_
    colors[idx] <- "green"
    point_colors(colors)
  })
  
  observeEvent(input$dclk, {
    colors <- point_colors()
    colors[] <- "black"  # Resetear colores al hacer doble clic
    point_colors(colors)
  })
  
  observeEvent(input$mhover, {
    colors <- point_colors()
    idx <- nearPoints(mtcars, input$mhover, xvar = "wt", yvar = "mpg", allRows = TRUE)$selected_
    colors[idx] <- "grey"
    point_colors(colors)
  })
  
  observeEvent(input$mbrush, {
    colors <- point_colors()
    idx <- brushedPoints(mtcars, input$mbrush, xvar = "wt", yvar = "mpg", allRows = TRUE)$selected_
    colors[idx] <- "red"
    point_colors(colors)
  })
  
  # Mostrar la tabla usando DT
  output$mtcars_tbl <- renderDT({
    plot_data_df <- plot_data()
    datatable(plot_data_df)
  })
}

