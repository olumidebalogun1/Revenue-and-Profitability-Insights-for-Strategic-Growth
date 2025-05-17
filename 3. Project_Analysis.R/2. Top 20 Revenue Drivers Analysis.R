--------------------------------------------------------------------
  
#  Title: "ETL Process: Extracting, Transforming, and Loading Data"
#  Author: "Olumide Balogun"
#  Date: "2024-09-22"
  
-------------------------------------------------------------------
  
# ===============================================================================================

#  ---  Top 20 Revenue Drivers Analysis  ---

#   Which customer types, product types, and market zones rank among the top 20
#   with total revenue surpassing $4.00 million?         


#  --- Strategic Analysis Overview  ---

#  ---  1. Business Challenge:
#   The company seeks to identify its highest-performing customer types, product types, and market zones based 
#   on total revenue, highlighting the top 20 performers surpassing $4.00 million. By understanding these key
#   success factors,leadership can strategically prioritize resources, optimize growth strategies, 
#   and uncover areas for targeted expansion.


#  ---  2. Objective:
#   This question seeks to assess revenue and profitability across customer types, product categories, 
#   and market zones, with the goal of identifying the top 20 performers and enabling data-driven 
#   strategic decisions to enhance growth and business impact.


#  ---  3. Analytical Approach:
#  - Write R Script to calculate total revenue and profitability by customer type, product type, and market zone.
#  - Filter and rank the top 20 performers in each category, ensuring revenue exceeds $4.00 million.
#  - Create a clear visualization  to highlight top-performing segments and zones.
#  - Provide actionable, data-driven recommendations to capitalize on high-performing areas and inform strategic expansion initiatives.

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
summarized_sales_1 <- cleaned_sales_data%>%
  group_by(customer_type, product_type, markets_zone) %>%
  summarise(
    Total_Profit_in_M = round( sum(profit)/ 1e6, 2),
    Total_Revenue_in_M = round( sum(revenue)/ 1e6, 2), 
    .groups = "drop" ) %>%              
  arrange(desc(Total_Revenue_in_M))


#  ---  2. Ranking Top 20 Records Based on Total Revenue  ---

revenue_top_20 <- summarized_sales_1 %>%
  slice_max(Total_Revenue_in_M , n = 20)          


#  ---  3.  Visualizing Top Twenty by Total Revenue by creating table visualization for the top 20 performers by Total Revenue

plot_revenue <- revenue_top_20 %>% 
  gt() %>% 
  tab_header(title = "Top Twenty (20) by Total Revenue ($ Million)") %>%         
  cols_align(align = "left")                           # Aligning all columns to the left for better readability


#  ---  4. Highlighting Key Data Points with Conditional Formatting by applying custom theme 
#       and highlight specific rows and columns with colors for better emphasis

revenue_domain <- range(summarized_sales_1$Total_Revenue_in_M)          

plot_revenue <- plot_revenue %>% 
  gt_theme_pff() %>%          # Applying pre-defined professional theme to the table
  gt_highlight_rows(rows = Total_Revenue_in_M >= 4.00, fill="lightpink") %>%     
  gt_color_rows(columns = "Total_Revenue_in_M", palette = "Pastel1",             
                domain = revenue_domain                         # Specifying domain for consistent color scaling
  )
plot_revenue        

