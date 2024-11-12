library(shiny)
library(dplyr)
library(tidyverse)
library(readxl)
library(rsconnect)
library(rsconnect)

file_path <- "dormancy.gene.expression.view.ortho.xls"

# Load your data tables here from the specified sheets
pombe_human_orthologs <- read_excel(file_path, sheet = "Table 1")

rna_spores_vegetative <- read_excel(file_path, sheet = "Table 3")
rna_spores_quiescent <- read_excel(file_path, sheet = "Table 4")
rna_spores_stationary <- read_excel(file_path, sheet = "Table 5")
protein_spores_vegetative <- read_excel(file_path, sheet = "Table 6")
protein_spores_quiescent <- read_excel(file_path, sheet = "Table 7")
protein_spores_stationary <- read_excel(file_path, sheet = "Table 8")
rna_diapause <- read_excel(file_path, sheet = "Table 9")
protein_diapause <- read_excel(file_path, sheet = "Table 10")
rna_dormant_cancer <- read_excel(file_path, sheet = "Table 11")
barseq_longevity <- read_excel(file_path, sheet = "Table 12")
barseq_heatshock <- read_excel(file_path, sheet = "Table 13")
rna_spores_vegetative$Result <- ifelse(rna_spores_vegetative$logFC>0.58 &rna_spores_vegetative$padj<0.05,"upregulated","")
rna_spores_vegetative$Result <- ifelse(rna_spores_vegetative$logFC< -0.58 &rna_spores_vegetative$padj<0.05,"downregulated",rna_spores_vegetative$Result)

rna_spores_quiescent$Result <- ifelse(rna_spores_quiescent$logFC>0.58&rna_spores_quiescent$padj<0.05,"upregulated","")
rna_spores_quiescent$Result <- ifelse(rna_spores_quiescent$logFC< -0.58&rna_spores_quiescent$padj<0.05,"downregulated",rna_spores_quiescent$Result)

rna_spores_stationary$Result <- ifelse(rna_spores_stationary$logFC>0.58&rna_spores_stationary$padj<0.05,"upregulated","")
rna_spores_stationary$Result <- ifelse(rna_spores_stationary$logFC< -0.58&rna_spores_stationary$padj<0.05,"downregulated",rna_spores_stationary$Result)

protein_spores_vegetative$Result <- ifelse(protein_spores_vegetative$logFC>0.58&protein_spores_vegetative$padj<0.05,"upregulated","")
protein_spores_vegetative$Result <- ifelse(protein_spores_vegetative$logFC< -0.58&protein_spores_vegetative$padj<0.05,"downregulated",protein_spores_vegetative$Result)

protein_spores_quiescent$Result <- ifelse(protein_spores_quiescent$logFC>0.58&protein_spores_quiescent$padj<0.05,"upregulated","")
protein_spores_quiescent$Result <- ifelse(protein_spores_quiescent$logFC< -0.58&protein_spores_quiescent$padj<0.05,"downregulated",protein_spores_quiescent$Result)

protein_spores_stationary$Result <- ifelse(protein_spores_stationary$logFC>0.58&protein_spores_stationary$padj<0.05,"upregulated","")
protein_spores_stationary$Result <- ifelse(protein_spores_stationary$logFC< -0.58&protein_spores_stationary$padj<0.05,"downregulated",protein_spores_stationary$Result)


rna_diapause$Result <- ifelse(rna_diapause$logFC>0.58&rna_diapause$padj<0.05,"upregulated","")
rna_diapause$Result <- ifelse(rna_diapause$logFC< -0.58&rna_diapause$padj<0.05,"downregulated",rna_diapause$Result)

protein_diapause$Result <- ifelse(protein_diapause$logFC>0.58&protein_diapause$padj<0.05,"upregulated","")
protein_diapause$Result <- ifelse(protein_diapause$logFC< -0.58&protein_diapause$padj<0.05,"downregulated",protein_diapause$Result)


ui <- fluidPage(
  tags$div(
    tags$img(src = "logo.png", height = "100px"),
    style = "text-align: center; margin-bottom: 20px;"
  ),
  # Add logo at the top

  titlePanel("Dormancy Expression Viewer"),
  sidebarLayout(
    sidebarPanel(
      textInput("gene", "Enter gene name (pombe.gene, killi.gene, human.gene):", ""),
      actionButton("search", "Search")
    ),
    mainPanel(
      h3("Search Results"),
      tableOutput("orthologs"),
      h4("Expression Data"),
      tabsetPanel(
        tabPanel("Spores vs Vegetative cells (RNA)", tableOutput("table3")),
        tabPanel("Spores vs Quiescent cells (RNA)", tableOutput("table4")),
        tabPanel("Spores vs Stationary cells (RNA)", tableOutput("table5")),
        tabPanel("Spores vs Vegetative cells (protein)", tableOutput("table6")),
        tabPanel("Spores vs Quiescent cells (protein)", tableOutput("table7")),
        tabPanel("Spores vs Stationary cells (protein)", tableOutput("table8")),
        tabPanel("Diapause vs active embryos (RNA)", tableOutput("table9")),
        tabPanel("Diapause vs active embryos (protein)", tableOutput("table10")),
        tabPanel("Dormant Cancer Cells vs active cancer cells (RNA)", tableOutput("table11")),
        tabPanel("BarSeq spores Longevity", tableOutput("table12")),
        tabPanel("BarSeq spores Heatshock Resistance", tableOutput("table13"))
      ))
    ),
  
  # Add contact information at the bottom
  tags$footer(
    tags$div(
      "For any inquiries, please contact: ",
      tags$a(href = "mailto:shaimaa.hassan.18@ucl.ac.uk", "shaimaa.hassan.18@ucl.ac.uk"),
      style = "text-align: center; padding: 10px; font-size: 14px; color: #4b0082;"
    ),
    style = "position: absolute; bottom: 0; width: 100%; background-color: #e0e0f8;"
  )
)
# Define server logic
server <- function(input, output, session) {
  observeEvent(input$search, {
    gene_query <- input$gene
    
    # Initialize corresponding genes
    corresponding_killi_gene <- gene_query
    corresponding_human_gene <- gene_query
    corresponding_pombe_gene <- gene_query
    
    # Determine the corresponding genes if the input is in ortholog tables
    if (gene_query %in% pombe_human_orthologs$killi.gene) {
      # If gene_query is a killi.gene, find corresponding human and pombe genes
      corresponding_human_gene <- pombe_human_orthologs %>% filter(killi.gene == gene_query) %>% pull(human.gene)
      corresponding_pombe_gene <- pombe_human_orthologs %>% filter(human.gene == corresponding_human_gene) %>% pull(pombe.gene)
    } else if (gene_query %in% pombe_human_orthologs$pombe.gene) {
      # If gene_query is a pombe.gene, find corresponding human and killi genes
      corresponding_human_gene <- pombe_human_orthologs %>% filter(pombe.gene == gene_query) %>% pull(human.gene)
      corresponding_killi_gene <- pombe_human_orthologs %>% filter(human.gene == corresponding_human_gene) %>% pull(killi.gene)
    } else if (gene_query %in% pombe_human_orthologs$human.gene) {
      # If gene_query is a human.gene, find corresponding pombe and killi genes
      corresponding_pombe_gene <- pombe_human_orthologs %>% filter(human.gene == gene_query) %>% pull(pombe.gene)
      corresponding_killi_gene <- pombe_human_orthologs %>% filter(human.gene == gene_query) %>% pull(killi.gene)
    }
    
    # Helper function to filter tables based on the specified gene type
    filter_table <- function(df, query_column, query) {
      if (query_column %in% colnames(df)) {
        return(df %>% filter(!!sym(query_column) == query))
      } else {
        return(df[0, ])  # Return empty data frame if no match found
      }
    }
    
    # Display orthologs data (combining results from different sources)
    output$orthologs <- renderTable({
      bind_rows(
        filter_table(pombe_human_orthologs, "pombe.gene", gene_query) %>% mutate(Source = "Pombe - Human Orthologs"),
        filter_table(pombe_human_orthologs, "killi.gene", gene_query) %>% mutate(Source = "Killi - Human Orthologs")
      )
    })
   
    # Display each table with the specified gene type for filtering
    output$table3 <- renderTable({ filter_table(rna_spores_vegetative, "pombe.gene", corresponding_pombe_gene) })
    output$table4 <- renderTable({ filter_table(rna_spores_quiescent, "pombe.gene", corresponding_pombe_gene) })
    output$table5 <- renderTable({ filter_table(rna_spores_stationary, "pombe.gene", corresponding_pombe_gene) })
    output$table6 <- renderTable({ filter_table(protein_spores_vegetative, "pombe.gene", corresponding_pombe_gene) })
    output$table7 <- renderTable({ filter_table(protein_spores_quiescent, "pombe.gene", corresponding_pombe_gene) })
    output$table8 <- renderTable({ filter_table(protein_spores_stationary, "pombe.gene", corresponding_pombe_gene) })
    output$table9 <- renderTable({ filter_table(rna_diapause, "killi.gene", corresponding_killi_gene) })
    output$table10 <- renderTable({ filter_table(protein_diapause, "killi.gene", corresponding_killi_gene) })
    output$table11 <- renderTable({ filter_table(rna_dormant_cancer, "human.gene", corresponding_human_gene) })
    output$table12 <- renderTable({ filter_table(barseq_longevity, "pombe.gene", corresponding_pombe_gene) })
    output$table13 <- renderTable({ filter_table(barseq_heatshock, "pombe.gene", corresponding_pombe_gene) })
  })
}
# Run the application
shinyApp(ui = ui, server = server)

