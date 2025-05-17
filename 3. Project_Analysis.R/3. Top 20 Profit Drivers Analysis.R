--------------------------------------------------------------------
  
#  Title: "ETL Process: Extracting, Transforming, and Loading Data"
#  Author: "Olumide Balogun"
#  Date: "2024-09-22"
  
-------------------------------------------------------------------
  
# ===============================================================================================

#  ---  Top 20 Profit Drivers Analysis  ---

#   Which customer types, product types, and market zones rank among
#   the top 20 with total profits exceeding $0.06 million?


#  --- Strategic Analysis Overview  ---

#  ---  1. Business Challenge:
#   The company seeks to identify the most profitable customer types, product types, and market zones,
#   highlighting the top 20 performers with total profits exceeding $0.06 million. 
#   By understanding where significant profit originates, leadership can optimize resource allocation,
#   evaluate the relationship between sales and profitability, and drive sustainable growth.

#  ---  2. Objective:
#   This question seeks to evaluate profit and revenue insights across customer types, product types,
#   and market zones, with the goal ofidentifying the top 20 performers and enabling informed, 
#   strategic decisions to maximize profitability and business impact.

#  ---  3. Analytical Approach:
#  - Write R Script to calculate total profit and revenue by customer type, product type, and market zone.
#  - Filter and rank the top 20 performers in each category, ensuring profits exceed $0.06 million.
#  - Create a clear visualization to highlight top-performing segments and zones.
#  - Provide actionable, data-driven recommendations to capitalize on high-profit areas and inform strategic expansion initiatives

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


#  ---  1. Summarizing Total Profit and Revenue by Category  ---
summarized_sales_2 <- cleaned_sales_data%>%
  group_by(customer_type, product_type, markets_zone) %>%
  summarise(
    Total_Revenue_in_M = round( sum(revenue)/ 1e6, 2), 
    Total_Profit_in_M = round( sum(profit)/ 1e6, 2), 
    .groups = "drop" ) %>%                                
  arrange(desc(Total_Revenue_in_M))


#  ---  2. Ranking Top 20 Records Based on Total Profit  ---  

top_20_profit <- summarized_sales_2 %>%
  arrange(desc(Total_Profit_in_M)) %>% 
  slice_max(Total_Profit_in_M, n = 20)       


#  --- 3. Visualizing Top Twenty by Profit by creating table visualization for the top 20 performers by profit

plot_profit <- top_20_profit %>% 
  gt() %>% 
  tab_header(title = "Top Twenty (20) by Total Profit ($ Million)") %>%     
  cols_align(align = "left")                            # Aligning columns to the left for better readability


#  ---  4. Highlighting Key Data Points with Conditional Formatting by applying custom theme
#          and highlight specific rows and columns for visual emphasis

revenue_domain <- range(summarized_sales_2$Total_Profit_in_M)      

plot_profit <- plot_profit %>% 
  gt_theme_pff() %>%     # Applying professional table theme for consistent styling
  gt_highlight_rows(rows = Total_Profit_in_M >= 0.06, fill="lightblue") %>%    
  gt_color_rows(columns = "Total_Profit_in_M", palette = "Pastel1",            
                domain = revenue_domain               # Specifying domain for consistent color scaling
  )
plot_profit          
