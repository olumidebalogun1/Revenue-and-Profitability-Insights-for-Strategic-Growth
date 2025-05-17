--------------------------------------------------------------------
  
  #  Title: "ETL Process: Extracting, Transforming, and Loading Data"
  #  Author: "Olumide Balogun"
  #  Date: "2024-09-22"
  
  -------------------------------------------------------------------
  
  # ===============================================================================================

#  ---  EDA and Correlation Analysis with Significance Testing  ---

#   What are the strengths and directions of relationships between key business variables,
#   and which of these correlations are statistically significant?
       

#  --- Strategic Analysis Overview  ---

#  ---  1. Business Challenge:
#   The company aims to analyze relationships between key business variables to uncover patterns, assess dependencies
#   and identify drivers of sales and profitability, supporting strategic decisions and risk mitigation.

#  ---  2. Objective of the Question :
#   This analysis explores statistical correlations to uncover meaningful relationships between variables,
#   providing data-driven insights to optimize sales strategies, boost profitability, and support business growth.

#  ---  3. Analytical Approach:
#   - Write R Script to create a correlation matrix using the psych package.
#   - Perform statistical correlation analysis, including significance testing and confidence intervals, to assess the reliability of the observed relationships.
#   - Identify strong, moderate, and weak correlations, along with their directions (positive or negative). 
#   - Create clear visualizations (correlation heatmaps) to illustrate the relationships between variables.
#   - Provide actionable insights to leverage strong positive correlations, mitigate risks from strong negative correlations, and validate strategic decisions with statistical rigor.

# ===============================================================================================

#  ---  Loading Necessary Libraries  ---

library(tidyverse)
library(ggplot2)
library(readxl)
library(lubridate)
library(corrplot)
library(psych)
library(ggstatsplot)

#  ---  Importing Dataset from sales_data_processed.csv  ---

#   The file sales_data_processed.csv contains the cleaned and processed sales data, 
#   exported as the final output of the ETL (Extract, Transform, Load) process.

cleaned_sales_data <- read.csv("processed_sales_data.csv")

head(cleaned_sales_data)


#  ---  1.  Correlation Matrix with corrplot.

#####  Prepare the data for correlation analysis
cor_data <- cleaned_sales_data %>%
  select(revenue, profit, cost_price, volume) 


#  ---  2.  Visualize the correlation matrix

corrplot(corr = cor(cor_data ),
         addCoef.col = "white",
         number.cex = 0.9,
         number.digits = 1,
         diag = FALSE,
         bg = "lightgray",
         outline = "black",
         addgrid.col = "white",
         mar = c(1,1,1,1),
         main = "Correlation Matrix: Revenue, Profit, Cost Price, and Volume"
)


#  ---  3.  Correlation Matrix with psych.  

#####  Select only the numeric columns
numerical_data <- cleaned_sales_data %>%
  select(revenue, profit, volume, cost_price)


#  ---  4. Compute the correlation matrix

correlation_results <- psych::corr.test(
  numerical_data,                   # Dataset containing numeric variables
  method = "pearson",               # Method for correlation (default is Pearson)
  adjust = "none"                   # Adjustment method for p-values
)


#  ---  5. View the correlation matrix

print(correlation_results$r)            # Correlation coefficients (r-values)


#  ---  6.  View the p-values to test significance of correlations

print(correlation_results$p)            # P-values



