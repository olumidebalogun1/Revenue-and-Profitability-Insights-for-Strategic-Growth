--------------------------------------------------------------------
  
#  Title: "ETL Process: Extracting, Transforming, and Loading Data"
#  Author: "Olumide Balogun"
#  Date: "2024-09-22"
  
-------------------------------------------------------------------
  
# ===============================================================================================

#  ---  Annual Growth Summary  ---
  
#   Did any years experience negative or stagnant growth? Furthermore,
#   are there any significant differences in the data?          
  
  
#  --- Strategic Analysis Overview  ---  
  
#  ---   1. Business Challenge:
#   The company seeks to understand its annual revenue, profit, and volume performance over time, 
#   identifying whether any years experienced negative or stagnant growth. By pinpointing periods
#   of under performance or stagnation and assessing the significance of variations in key metrics,
#   leadership can proactively address potential weaknesses and capitalize on growth opportunities.

#  ---   2. Objective:
#   This question aims to evaluate annual revenue, profit, and volume performance along with percentage growth.
#   The insights gained will support strategic decisions by identifying periods of underperformance, detecting 
#   trends, and guiding corrective actions for sustainable business growth.

#  ---  3. Analytical Approach:
#  - Write R Script to calculate annual revenue, profit, and volume, along with year-over-year percentage growth.
#  - Identify years of negative or stagnant growth and assess the magnitude of these variations.
#  - Create a clear visualization to illustrate annual performance trends and discrepancies.
#  - Provide actionable, data-driven recommendations to mitigate periods of underperformance and enhance strategic planning.

# ===============================================================================================
   
#  ---  Loading Necessary Libraries  ---
library(tidyverse)
library(ggplot2)
library(readxl)
library(lubridate)
library(RColorBrewer)
library(gtExtras)


#  ---  Importing Dataset from sales_data_processed.csv  ---

#   The file sales_data_processed.csv contains the cleaned and processed sales data,
#   exported as the final output of the ETL (Extract, Transform, Load) process.

cleaned_sales_data <- read.csv("processed_sales_data.csv")

head(cleaned_sales_data)


#  ---  1. Calculating the Annual Total Revenue , Profit, and Volume Summary by grouping 
#       the Cleaned Sales Data by year and computing the annual aggregates for revenue, profit, and volume.

Annual_Summary <- cleaned_sales_data %>%
  group_by(year) %>%      # Grouping the dataset by the 'year' column
  summarise(
    Total_Revenue = round(sum(revenue) / 1e6, 2),      # Calculating total revenue in millions ($M), rounded to 2 decimal places
    Total_Profit = round(sum(profit) / 1e6, 2),        # Calculating total profit in millions ($M), rounded to 2 decimal places
    Total_Volume = round(sum(volume) / 1e3, 2)         # Calculating total volume in thousands (K), rounded to 2 decimal places
  )


#  ---  2. Analysing Annual Performance with Revenue, Profit, and Volume Growth.

Annual_Summary <- Annual_Summary %>%
  arrange(year) %>%
  mutate(
    Pct_diff_Revenue = paste0(round((Total_Revenue  - lag(Total_Revenue )) / lag(Total_Revenue ) * 100, 2), "%"),
    Pct_diff_Profit = paste0(round((Total_Profit  - lag(Total_Profit))  / lag(Total_Profit ) * 100, 2), "%"),
    Pct_diff_Volume = paste0(round((Total_Volume  - lag(Total_Volume))  / lag(Total_Volume)  * 100, 2), "%")
  )


#  ---  3. Visualizing Annual Revenue , Profit, and Volume Performance with Growth Trends by
#       Creating table to display annual performance metrics and growth trends.

Plot_Annual_Summary <- Annual_Summary %>% 
  gt() %>% 
  tab_header(title = "Annual Performance: Revenue ($ Million), Profit ($ Million), 
             and Volume (Thousand) with Percentage Growth") %>%          
  cols_align(align = "left")                                              
Plot_Annual_Summary                                  


#  ---  4. Highlighting Key Data Points with Conditional Formatting to enhance the table visualization by applying themes and highlighting important data points

plot_annual_performance <- Plot_Annual_Summary %>% 
  gt_theme_pff() %>%                                                         
  gt_highlight_rows(column = Total_Revenue, fill="lightpink") %>%            
  gt_highlight_rows(column = Total_Profit, fill="lightblue") %>%             
  gt_highlight_rows(column = Pct_diff_Revenue, fill="lightpink") %>%         
  gt_highlight_rows(column = Pct_diff_Profit, fill="lightblue") %>%          
  gt_highlight_rows(rows = Pct_diff_Revenue < 0, fill="steelblue")           

plot_annual_performance         

