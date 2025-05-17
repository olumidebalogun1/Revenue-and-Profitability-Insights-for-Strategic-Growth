--------------------------------------------------------------------
  
#  Title: "ETL Process: Extracting, Transforming, and Loading Data"
#  Author: "Olumide Balogun"
#  Date: "2024-09-22"
  
-------------------------------------------------------------------
  
# ===============================================================================================

#  ---  Customer Segmentation Using Clustering Technique  ---

#   Which customer segments, based on clustering, contribute the most to overall revenue and sales volume?       


#  --- Strategic Analysis Overview  ---

#  ---  1. Business Challenge:
#   The company aims to identify high-value customer segments to optimize resource allocation,
#   tailor marketing strategies, and boost engagement. Understanding purchasing patterns enables
#   targeted actions that enhance profitability and support sustainable growth.

#  ---  2. Objective of the Question :
#   This analysis aims to leverage clustering techniques to segment customers based on purchasing behavior,
#   revenue contribution, and sales volume. The resulting insights will inform targeted marketing,
#   improve customer retention, and support strategic decisions to boost profitability.

#  ---  3. Analytical Approach:
#   - Write R Script to perform customer segmentation using clustering algorithms (e.g., K-Means, Hierarchical Clustering, or DBSCAN).
#   - Analyze the characteristics of each segment to identify high-value and underperforming customer groups.
#   - Develop visualizations to illustrate segment differences and revenue contributions.
#   - Provide actionable recommendations on targeted marketing, personalized engagement strategies,
#     and resource optimization to enhance profitability and business growth.


# ===============================================================================================

#  ---  Loading Necessary Libraries  ---

library(tidyverse)
library(ggplot2)
library(readxl)
library(lubridate)
library(cluster)


#  ---  Importing Dataset from sales_data_processed.csv  ---

#   The file sales_data_processed.csv contains the cleaned and processed sales data, 
#   exported as the final output of the ETL (Extract, Transform, Load) process.

cleaned_sales_data <- read.csv("processed_sales_data.csv")

head(cleaned_sales_data)


#  ---  1.  Grouping by Customer Name and Calculating Total Revenue and Volume

#####  This block aggregates total revenue and volume for each customer and calculates additional metrics such as average volume value, revenue contribution percentage, and cumulative percentage.
revenue_clustering <- cleaned_sales_data %>%
  group_by(custmer_name  ) %>% 
  summarise(Total_Revenue_in_M = round(sum(revenue)/1e6, 2),
            Total_Volume_in_K = round(sum(volume)/1e3, 2), .groups = "drop") %>% 
  arrange(desc(Total_Revenue_in_M)) %>% 
  mutate(Average_Volume_Value = round(Total_Revenue_in_M/Total_Volume_in_K, 2)) %>% 
  mutate(Total_Revenue_percent = round(Total_Revenue_in_M *100/sum(Total_Revenue_in_M), 2)) %>% 
  mutate(Cum_percent = round(cumsum(Total_Revenue_percent), 2)) %>% 
  select(custmer_name , Total_Revenue_in_M, Total_Volume_in_K , 
         Average_Volume_Value , Total_Revenue_percent, Cum_percent) %>% 
  arrange(desc(Total_Revenue_in_M))

head(revenue_clustering)

# view(revenue_clustering)


#  ---  2.  Clustering Model for Customer Segmentation 

#####   K-Means Clustering 
kmeans_result <- kmeans(revenue_clustering[, c("Total_Revenue_in_M", "Total_Volume_in_K")], centers = 3)


#  ---  3.  Assigning Cluster Labels. Adding a new column to the dataset to indicate which cluster each customer belongs to.
revenue_clustering$cluster <- kmeans_result$cluster


#  ---  4.  Visualising K-Means Clustering Results

#####   Creating a scatter plot to visualize customer segments based on revenue and volume.
#####   Points are colored according to their assigned cluster.
plot(
  revenue_clustering$Total_Revenue_in_M,    # X-axis: Total Revenue
  revenue_clustering$Total_Volume_in_K,     # Y-axis: Total Volume
  col = revenue_clustering$cluster,         # Color based on cluster assignment
  main = "Customer Segmentation using Clustering Model",  # Plot title
  xlab = "Total Revenue ($ Million)",       # X-axis label
  ylab = "Total Volume (Thousand)",          # Y-axis label
  pch = 19
)
