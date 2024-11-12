# Dormancy-expression-viewer
This Shiny app allows users to explore gene expression data across various datasets related to dormancy. Users can input gene names (Ensembl human genes or pombe genes) to retrieve corresponding orthologues and expression data across multiple conditions. The app is designed to help researchers analyze gene expression changes under dormancy-related conditions in different organisms.

Features

Orthologue Search: Input Ensembl human or pombe gene names to find corresponding orthologues.
Gene Expression Analysis: Retrieve gene expression data across several dormancy conditions, including:
Spores vs. Vegetative cells (RNA and protein)
Spores vs. Quiescent cells (RNA and protein)
Spores vs. Stationary cells (RNA and protein)
Diapause vs. Active embryos (RNA and protein)
Dormant Cancer Cells vs. Active Cancer Cells (RNA)
BarSeq analysis for spore longevity and heatshock resistance
Conditional Formatting: The app highlights upregulated and downregulated genes based on logFC and padj thresholds.
Installation and Usage

1. Clone the Repository
To get started, clone this repository to your local machine:

git clone https://github.com/yourusername/dormancy-expression-viewer.git
2. Open the Project
Open the project in RStudio or another R environment, and navigate to the project directory.

3. Install Dependencies
Ensure you have the necessary R packages installed. Run the following command to install any missing packages:

install.packages(c("shiny", "dplyr", "readxl", "DT"))
4. Run the App
Launch the app by running:

shiny::runApp()
The app will open in your web browser, where you can enter gene names and view the corresponding orthologues and expression data across dormancy-related conditions.

Dependencies

This app requires the following R packages:

shiny: For building the interactive web application.
dplyr: For data manipulation.
readxl: For reading Excel files containing gene expression data.
DT: For rendering interactive tables.
Input Guidelines

Supported Gene Names: The app accepts Ensembl human gene names and pombe gene names. Enter the gene name in the input box to retrieve relevant orthologues and expression data.
Expression Data Output: Depending on the gene entered, the app displays corresponding orthologues and gene expression data across several conditions, highlighting upregulated and downregulated genes based on specified thresholds.
File Structure

The app's files are organized as follows:

dormancy-expression-viewer/
├── app.R                               # Main Shiny app file
├── dormancy.gene.expression.view.ortho.xls # Excel file with gene expression data
└── www/
    ├── style.css                       # Custom CSS for styling
    └── logo.png                        # Logo image (optional)
License

This project is licensed under the MIT License, allowing others to freely use, modify, and distribute the app with attribution.

Contact

For any inquiries, please contact shaimaa.hassan.18@ucl.ac.uk.

Example Usage
Once the app is running, you can:

Enter a gene name (e.g., an Ensembl human gene or pombe gene).
Click Search to retrieve orthologues and view expression data for the gene across different dormancy-related conditions.
View the gene expression tables, where upregulated and downregulated genes are highlighted for easier analysis.
