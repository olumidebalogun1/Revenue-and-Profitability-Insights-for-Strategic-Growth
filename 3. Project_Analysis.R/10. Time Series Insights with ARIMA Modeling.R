--------------------------------------------------------------------
  
#  Title: "ETL Process: Extracting, Transforming, and Loading Data"
#  Author: "Olumide Balogun"
#  Date: "2024-09-22"
  
-------------------------------------------------------------------
  
# ===============================================================================================

#  ---  Forecasting Revenue Trends: Time Series Insights with ARIMA Modeling  ---

#  What are the projected revenue trends for the next 36 months, and how
#  can these insights be leveraged to inform strategic business decisions?         
  

#  --- Strategic Analysis Overview  ---

#  ---  1. Business Challenge:
#   The company aims to accurately forecast revenue trends over the next 36 months. 
#   By anticipating fluctuations and uncovering long-term growth opportunities, leadership can make proactive, 
#   data-driven decisions that enhance financial performance and improve market competitiveness.

#  ---  2. Objective:
#   This analytical question aims to develop a time series forecasting model to project revenue trends over the
#   next three years. The insights will support strategic planning, optimize resource allocation, 
#   improve marketing effectiveness, and drive sustainable business growth.

#  ---  3. Analytical Approach:
#   - Collect and preprocess historical revenue data, ensuring accuracy and completeness.
#   - Develop and fine-tune a time series forecasting model (e.g., ARIMA) to project future revenue.
#   - Identify seasonal patterns, trends, and potential fluctuations in revenue.
#   - Develop visualizations to communicate insights effectively
#   - Provide actionable recommendations on pricing strategies, marketing campaigns, inventory management, and resource allocation based on forecasted revenue patterns.

# ===============================================================================================

#  ---  Loading Necessary Libraries  ---

library(tidyverse)
library(ggplot2)
library(readxl)
library(lubridate)
library(tseries)
library(forecast)


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


#  ---  2.  Monthly Revenue Analysis: Conversion to Millions and Thousands for Clarity

#####   Transforming raw values into more interpretable units (millions for revenue and profit, thousands for volume)
sales_group <- sales_group %>% 
  mutate(Revenue_in_M = round(sum_revenue / 1e6, 2)) %>%         # Converting total revenue to millions ($M) and round to 2 decimal places
  mutate(Profit_in_M = round(sum_profit / 1e6, 2)) %>%           # Converting total profit to millions ($M) and round to 2 decimal places
  mutate(Volume_in_K = round(sum_volume / 1e3, 3)) %>%           # Converting total volume to thousands (K) and round to 3 decimal places
  select(month, Revenue_in_M)                                    
view(sales_group)            


#  ---  3. Creating Time Series Data to Analyse Revenue Trends  ------

Revenue_in_M_ts<- ts(sales_group$Revenue_in_M, start = c(2020,10), end = c(2023,12), frequency = 12) 
Revenue_in_M_ts


#  ---  4.  Decomposition of Revenue into Trend and Seasonal Components

plot(stl(Revenue_in_M_ts, "per"), main = "Revenue Decomposition into Seasonal and Trend Components")


#  ---  5.  Augmented Dickey Fuller Test for Stationarity. 

#####  Checking stationarity 
revenue_adf_test <- adf.test(Revenue_in_M_ts)
print(revenue_adf_test)


#  ---  6. Performing differencing on the series to make it stationary, as the p-value is greater than 0.05

####  Checking for stationarity again (1st order differencing)
revenue_adf_test_diff <- adf.test(diff(diff(Revenue_in_M_ts)))
print(revenue_adf_test_diff)


#  ---  7.  Revenue Trend Forecast using ARIMA Model.

#####  Since the series is stationary, fit ARIMA and specify d = 1 (1st order differencing)
revenue_arima_model <- auto.arima(Revenue_in_M_ts, d = 1)  # 'd=1' means first-order differencing
summary(revenue_arima_model)


#  ---  8.  Forecasting Revenue Trends using ARIMA Model

revenue_arima_model <- auto.arima(Revenue_in_M_ts)
forecast_revenue <- forecast(revenue_arima_model, h=36)
plot(forecast_revenue, main = "Revenue Forecast for the Next 3 Years",
     xlab = "Year_Month", ylab = "Revenue Generated ($ million)")


#  ---  9.  Print the forecasted values (numeric values)

print(forecast_revenue$mean)
