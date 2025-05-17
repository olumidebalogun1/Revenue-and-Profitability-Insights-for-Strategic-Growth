--------------------------------------------------------------------
  
#  Title: "ETL Process: Extracting, Transforming, and Loading Data"
#  Author: "Olumide Balogun"
#  Date: "2024-09-22"
  
-------------------------------------------------------------------
  
# ===============================================================================================

#  ---  Revenue Over Time  ---

#  Is there a clear upward or downward trend in revenue performance over time?         


#  --- Strategic Analysis Overview  ---

#  ---  1. Business Challenge:
#   The company seeks to understand long-term revenue performance, identifying whether there is a clear upward or
#   downward trend over time.By analysing these trends, leadership can assess business growth sustainability, 
#   spot early signs of decline, and make strategic decisions to optimize performance.

#  ---  2. Objective:
#   This question aims to evaluate revenue performance over time, identify trends to support proactive
#   decision-making, ensure sustained growth, and address potential issues before they impact overall performance

#  ---  3. Analytical Approach:
#   - Write R Script to calculate and visualize revenue performance over time.
#   - Use time series analysis to identify long-term trends, seasonality, and anomalies.
#   - Create a clear visualization (line charts) to illustrate performance trajectories.
#   - Provide actionable, data-driven recommendations to capitalize on positive trends 
#     and mitigate the impact of declining performance.

# ===============================================================================================


#  ---  Loading Necessary Libraries  ---

library(tidyverse)
library(ggplot2)
library(readxl)
library(lubridate)


#  ---  Importing Dataset from sales_data_processed.csv  ---

#   The file sales_data_processed.csv contains the cleaned and processed sales data, 
#   exported as the final output of the ETL (Extract, Transform, Load) process.

cleaned_sales_data <- read.csv("processed_sales_data.csv")

head(cleaned_sales_data)


#  ---  1. Grouping Cleaned Sales Data by Year and Month by summarizing revenue, profit, and volume data at the monthly level

sales_group <- cleaned_sales_data %>% 
  group_by(year, month) %>%             
  summarise(
    sum_revenue = sum(revenue),         
    sum_profit = sum(profit),           
    sum_volume = sum(volume),           
    .groups = "drop"                            
  )


#  -- 2.Monthly Revenue Analysis: Conversion to Millions and Thousands for Clarity

#####   Transforming raw values into more interpretable units (millions for revenue and profit, thousands for volume)
sales_group <- sales_group %>% 
  mutate(Revenue_in_M = round(sum_revenue / 1e6, 2)) %>%         # Converting total revenue to millions ($M) and round to 2 decimal places
  mutate(Profit_in_M = round(sum_profit / 1e6, 2)) %>%           # Converting total profit to millions ($M) and round to 2 decimal places
  mutate(Volume_in_K = round(sum_volume / 1e3, 3)) %>%           # Converting total volume to thousands (K) and round to 3 decimal places
  select(month, Revenue_in_M)                                    
view(sales_group)            


#  ---  3. Creating Time Series Data to Analyse Revenue Trends

Revenue_in_M_ts<- ts(sales_group$Revenue_in_M, start = c(2020,10), end = c(2023,12), frequency = 12) 
Revenue_in_M_ts


#  ---  4. Visualizing Monthly Revenue Trends with Time Series Plot
####  Revenue Over Time and Adding mean line and data points
plot(Revenue_in_M_ts, xaxt = "n", xlab = "Year_Month", ylab = "Revenue ($ Millions)", 
     type = "l", lwd = 2, main = "Total Revenue per Month", col = "red")


time_labels <- time(Revenue_in_M_ts)
month_year_labels <- format(
  as.Date(paste(floor(time_labels), (time_labels - floor(time_labels)) * 12 + 1, "01", sep = "-")), "%b-%Y"
)
axis(1, at = time_labels, labels = month_year_labels, las = 2, cex.axis = 0.8)


abline(h = mean(Revenue_in_M_ts), col = "blue", lty = 2)
points(Revenue_in_M_ts, pch = 16, col = "steelblue", cex = 0.7)
grid(col = "gray", lty = "dotted")
