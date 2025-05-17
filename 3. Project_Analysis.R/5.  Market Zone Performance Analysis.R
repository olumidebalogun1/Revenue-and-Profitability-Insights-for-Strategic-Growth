--------------------------------------------------------------------
  
#  Title: "ETL Process: Extracting, Transforming, and Loading Data"
#  Author: "Olumide Balogun"
#  Date: "2024-09-22"
  
-------------------------------------------------------------------
  
# ===============================================================================================

#  ---  Market Zone Performance Analysis  ---

#    How do revenue and profitability differ across various market zones?        


#  --- Strategic Analysis Overview  ---

#  ---  1. Business Challenge:
#   The company aims to compare revenue and profitability across various market zones, 
#   identifying both high-performing and underperforming areas. By understanding these differences,
#   leadership can optimize resource allocation, refine marketing strategies, 
#   and focus sales efforts to drive business growth and enhance overall profitability.

#  ---  2. Objective:
#   This analysis aims to evaluate revenue and profitability performance across different market zones,
#   providing actionable insights to support strategic decision-making and optimize business operations.

#  ---  3. Analytical Approach:
#   - Write R Script to calculate and compare revenue and profitability metrics by market zone.
#   - Identify high-performing and under-performing zones based on revenue and profit margins.
#   - Perform statistical significance tests to assess differences in key financial metrics.
#   - Create clear visualizations (bar charts) to highlight performance patterns across market zones.
#   - Provide actionable, data-driven recommendations to capitalize on strengths, address inefficiencies, and guide targeted business growth initiatives.

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


#  ---   1.  Revenue and Profit by Market Zone

zone_performance <- cleaned_sales_data %>%
  group_by(markets_zone) %>%        
  summarise(total_revenue_in_M = round((sum(revenue))/ 1e6, 2),    
            total_profit_in_M = round((sum(profit))/ 1e6, 2))      


#  ---  2.  Evaluation of Revenue Across Market Zone.  

#####   Bar plot of total revenue by Market Zone  
r_m <- ggplot(zone_performance, aes(x = reorder(markets_zone,-total_revenue_in_M), y = total_revenue_in_M)) +
  geom_bar(stat = "identity", fill = "tomato") +
  geom_text(aes(label = paste0(total_revenue_in_M,"M")), 
            position = position_dodge(width = 0.9), 
            vjust = -0.4, size = 2.5) +                       # Adjusting size and position of text
  labs(title = "Total Revenue by Market Zone", x = "Market Zone", y = "Total Revenue ($ Million)") +
  theme_classic()
r_m                                        


#  --- 3.  Statistical Test: Kruskal-Wallis Test  

####   Analyzing Revenue by Market Zone
####   The Kruskal-Wallis test evaluates if there are significant differences in revenue across different market zones
kruskal_test_market_sales <- kruskal.test(revenue ~ markets_zone, data = cleaned_sales_data)
kruskal_test_market_sales                  # Displaying the results of the Kruskal-Wallis test


#  ---  4. Evaluation of Profitability  Across Market Zone.  

####   Bar plot of total profit by Market Zone  
p_m <- ggplot(zone_performance, aes(x = reorder(markets_zone,-total_profit_in_M), y = total_profit_in_M)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  geom_text(aes(label = paste0(total_profit_in_M,"M")), 
            position = position_dodge(width = 0.9), 
            vjust = -0.4, size = 2.5) +    # Adjusting size and position of text
  labs(title = "Total Profit by Market Zone", x = "Market Zone", y = "Total Profit ($ Million)") +
  theme_classic()
p_m   



#  --- 5. Statistical Test: Kruskal-Wallis Test 

####   Performing the Kruskal-Wallis test on Profit by Market Zone
####   This test checks if there are significant differences in Profit across different market zones
kruskal_test_market_profit <- kruskal.test(profit ~ markets_zone, data = cleaned_sales_data)
kruskal_test_market_profit          


#  ---  6.  Combining and Displaying the plots  
combined_plot_1 <- r_m/p_m        # Combining the revenue plot (r_m) and profit plot (p_m)
combined_plot_1                   # Displaying the combined plot

