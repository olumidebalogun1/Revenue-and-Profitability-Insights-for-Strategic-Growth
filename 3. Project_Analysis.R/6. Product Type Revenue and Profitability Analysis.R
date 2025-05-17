--------------------------------------------------------------------
  
#  Title: "ETL Process: Extracting, Transforming, and Loading Data"
#  Author: "Olumide Balogun"
#  Date: "2024-09-22"
  
  -------------------------------------------------------------------
  
# ===============================================================================================

#  ---   Product Type Revenue and Profitability Analysis.

#   How do revenue and profit vary across different product types?         


#  --- Strategic Analysis Overview  ---

#  ---  1. Business Challenge:
#   The company seeks to understand how revenue and profit vary across different product types, 
#   identifying which products are most profitable and which are underperforming. 
#   By gaining these insights, leadership can optimize resources, marketing strategies,
#   and inventory management to drive growth and reduce costs.

#  ---  2. Objective:
#   This analysis aims to evaluate revenue and profitability performance by product type,
#   providing actionable insights to support strategic decision-making and improve overall
#   business efficiency.

#  ---  3. Analytical Approach:
#  - Write R Script to calculate and compare revenue and profitability metrics for each product type.
#  - Identify top-performing and under-performing product types based on revenue and profit margins.
#  - Perform statistical significance tests to assess differences in financial performance by product type.
#  - Create clear visualizations (bar charts) to illustrate trends and patterns.
#  - Provide actionable, data-driven recommendations to capitalize on high-performing products 
#    and address inefficiencies, supporting strategic business growth initiatives.

# ===============================================================================================

#  ---  Loading Necessary Libraries  ---

library(tidyverse)
library(ggplot2)
library(readxl)
library(lubridate)
library(patchwork)
library(ggprism)

#  ---  Importing Dataset from sales_data_processed.csv  ---

#   The file sales_data_processed.csv contains the cleaned and processed sales data, 
#   exported as the final output of the ETL (Extract, Transform, Load) process.

cleaned_sales_data <- read.csv("processed_sales_data.csv")

head(cleaned_sales_data)


#  --- 1.  Evaluation of Revenue Across Product Types.

#####   Revenue Performance Across Product Types. 
product_revenue <- cleaned_sales_data %>%
  group_by(product_type) %>%        # Grouping the data by product type
  summarise(total_revenue_in_M = round((sum(revenue))/ 1e6, 2))    


#  --- 2.  Bar plot of total revenue across Product Type.
r_p <- ggplot(product_revenue, aes(x = reorder(product_type, -total_revenue_in_M), y = total_revenue_in_M)) +    # Reordering product types by revenue
  geom_bar(stat = "identity", fill = "tomato") +             
  geom_text(aes(label = paste0(total_revenue_in_M,"M")),        # Adding revenue labels to each bar
            position = position_dodge(width = 0.9), 
            vjust = -0.4, size = 2.5) +       # Adjusting the text position and size for clarity
  labs(title = "Total Revenue by Product Type", x = "Product Type", y = "Total Revenue ($ Million)") +              
  theme_classic()   
r_p                              # Displaying the plot


#  --- 3.  Statistical Test: Kruskal-Wallis Test  

####  Performing the Kruskal-Wallis test on Revenue by Product Type
kruskal_test_product <- kruskal.test(revenue ~ product_type, data = cleaned_sales_data)     
kruskal_test_product              # Displaying the result of the test


#  --- 4.  Evaluation of Profitability Across Product Types

####  Profit Performance Across Product Types
product_profit <- cleaned_sales_data %>%
  group_by(product_type) %>%
  summarise(total_profit_in_M = round((sum(profit)) / 1e6, 2))      # Summarizing total profit by product type


#  --- 5.  Bar Plot of Total Profit across Product Type  ------

p_p <- ggplot(product_profit, aes(x = reorder(product_type, -total_profit_in_M), y = total_profit_in_M)) +
  geom_bar(stat = "identity", fill = "steelblue") +        
  geom_text(aes(label = paste0(total_profit_in_M, "M")), 
            position = position_dodge(width = 0.9), 
            vjust = -0.4, size = 2.5) +      
  labs(title = "Total Profit by Product Type", x = "Product Type", y = "Total Profit ($ Million)") + 
  theme_classic()       
p_p                           # Displaying the plot


#  ---  6.  Statistical Test: Kruskal-Wallis Test  

#### Performing the Kruskal-Wallis Test on Profit by Product Type
kruskal_test_product_profit <- kruskal.test(profit ~ product_type, data = cleaned_sales_data)   
kruskal_test_product_profit                      # Displaying test results


#  ---  7.  Combining and Displaying the revenue and Profit Plots 

combined_plot_2 <- r_p/p_p      
combined_plot_2                   
