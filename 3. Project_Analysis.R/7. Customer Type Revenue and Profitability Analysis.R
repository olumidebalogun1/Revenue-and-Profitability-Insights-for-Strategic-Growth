--------------------------------------------------------------------
  
#  Title: "ETL Process: Extracting, Transforming, and Loading Data"
#  Author: "Olumide Balogun"
#  Date: "2024-09-22"
  
  -------------------------------------------------------------------
  
# ===============================================================================================

#  ---  Customer Type Revenue and Profitability Analysis  ---

#   How do revenue and profit vary across different customer types?         


#  --- Strategic Analysis Overview  ---

#  ---  1. Business Challenge:
#   The company seeks to uncover how revenue and profit contributions vary across different customer types.
#   By understanding these patterns, leadership can make informed decisions to allocate resources, 
#   optimize marketing strategies, and drive targeted initiatives for customer retention and revenue growth.

#  ---  2. Objective of the Question :
#   This analysis aims to evaluate revenue and profitability performance by customer type, providing 
#   actionable insights to support strategic business growth and enhance customer relationship management.

#  ---  3. Analytical Approach:
#   - Write R Script to calculate and compare revenue and profitability metrics for each customer type.
#   - Identify top-performing and under-performing customer segments based on revenue and profit margins.
#   - Perform statistical significance tests to assess differences in financial performance by customer type.
#   - Create clear visualizations (bar charts) to illustrate trends and patterns.
#   - Provide actionable, data-driven recommendations to capitalize on high-performing customer segments and
#     address inefficiencies, supporting strategic business growth initiatives.

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


#  ---  1. Evaluation of Revenue Across Customer Types.  

#####  Revenue Performance Across Customer Types  
#####  Grouping Cleaned_Sales_Data by customer type and calculate the total revenue in millions
customer_sales <- cleaned_sales_data %>%
  group_by(customer_type) %>%
  summarise(total_revenue_in_M = round((sum(revenue)) / 1e6, 2))


#  ---   2. Visualizing Total Revenue by Customer Type by reating bar plot to show total revenue for each customer type

r_c <- ggplot(customer_sales, aes(x = reorder(customer_type, -total_revenue_in_M), y=total_revenue_in_M)) + geom_bar(stat = "identity", fill = "tomato") +            
  geom_text(aes(label = paste0(total_revenue_in_M, "M")),    
            position = position_dodge(width = 0.9), 
            vjust = -0.4, size = 3) +               # Adjusting label size and vertical position
  labs(
    title = "Total Revenue by Customer Type",       
    x = "Customer Type",  # Label for x-axis,       
    y = "Total Revenue ($ Million)"              
  ) +
  theme_classic()     
r_c                                     


#  --- 3.  Statistical Test: Kruskal-Wallis Test

#####  Performing the Kruskal-Wallis test to assess if revenue vary significantly across customer types
kruskal_test_customer <- kruskal.test(revenue ~ customer_type, data = cleaned_sales_data)
kruskal_test_customer                     # Displaying test results


#  --- 4.  Evaluation of Profitability Across Customer Types

#####  Profit Performance Across Customer Types 
#####  Grouping Cleaned Sales Data by customer type and calculate total profit in millions
customer_profit <- cleaned_sales_data %>%
  group_by(customer_type) %>%
  summarise(total_profit_in_M = round((sum(profit)) / 1e6, 2))


#  ---  5. Visualizing Total Profit by Customer Type by creating bar plot to show total profit for each customer type

p_c <- ggplot(customer_profit, aes(x = reorder(customer_type, -total_profit_in_M), y = total_profit_in_M)) +
  geom_bar(stat = "identity", fill = "steelblue") +                 # Bar plot with steel-blue bars
  geom_text(aes(label = paste0(total_profit_in_M, "M")),    
            position = position_dodge(width = 0.9), 
            vjust = -0.4, size = 3) +                               # Adjust label size and vertical position
  labs(
    title = "Total Profit by Customer Type",     
    x = "Customer Type",                         
    y = "Total Profit ($ Million)"               
  ) +
  theme_classic()           
p_c                                       


#  ---  6. Statistical Test: Kruskal-Wallis Test

#####  Performing the Kruskal-Wallis test to assess if profit varies significantly across customer types
kruskal_test_customer_profit <- kruskal.test(profit ~ customer_type, data = cleaned_sales_data)
kruskal_test_customer_profit                     # Displaying test results


#  ---  7.  Combined Visualization: Revenue and Profit by Customer Type  

combined_plot_3 <- r_c + p_c
combined_plot_3                            # Displaying the combined plots
