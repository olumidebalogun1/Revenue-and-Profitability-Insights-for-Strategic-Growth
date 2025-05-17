--------------------------------------------------------------------
  
#  Title: "ETL Process: Extracting, Transforming, and Loading Data"
#  Author: "Olumide Balogun"
#  Date: "2024-09-22"
  
-------------------------------------------------------------------
  
# ===============================================================================================

#  ---  Revenue Performance Analysis: Identifying Key Drivers Through Feature Importance & Regression  ---

#   What key drivers contribute to revenue performance?        


#  --- Strategic Analysis Overview  ---

#  ---  1. Business Challenge:
#   The company aims to identify the key drivers that significantly influence revenue performance.
#   Understanding these factors will enable leadership to optimize strategies, allocate resources more effectively, 
#   and make data-driven decisions that enhance sales performance and drive overall business growth.

#  ---  2. Objective of the Question :
#   This analytical question aims to identify the most influential factors contributing to revenue outcomes
#   through feature importance analysis and regression modeling. The insights gained will help prioritize
#   strategic initiatives, enhance marketing efforts, and improve the accuracy of financial forecasting.

#  ---  3. Analytical Approach:
#   - Write R Script to perform feature importance analysis using machine learning models (e.g., Random Forest and XGBoost).
#   - Identify and rank the top drivers of revenue, highlighting their significance and direction of impact.
#   - Assess model accuracy and significance through metrics such as R-squared, p-values, and confidence intervals.
#   - Create visualizations to communicate key insights clearly.
#   - Provide actionable recommendations to leverage positive drivers and mitigate negative influences, supporting data-backed decision-making for revenue optimization.

# ===============================================================================================

#  ---  Loading Necessary Libraries  ---

library(tidyverse)
library(ggplot2)
library(readxl)
library(lubridate)
library(xgboost)
library(Matrix)


#  ---  Importing Dataset from sales_data_processed.csv  ---

#   The file sales_data_processed.csv contains the cleaned and processed sales data, 
#   exported as the final output of the ETL (Extract, Transform, Load) process.

cleaned_sales_data <- read.csv("processed_sales_data.csv")

head(cleaned_sales_data)


#  ---  1.  Convert categorical variables into factors

cleaned_sales_data$product_type <- as.factor(cleaned_sales_data$product_type)
cleaned_sales_data$customer_type <- as.factor(cleaned_sales_data$customer_type)
cleaned_sales_data$markets_state <- as.factor(cleaned_sales_data$markets_state)

str(cleaned_sales_data)


#  ---  2.  Preparing data

revenue_matrix <- model.matrix(revenue ~ customer_type + product_type + 
                                 markets_state + volume + cost_price + profit + profit_margin, data = cleaned_sales_data)
revenue_target <- cleaned_sales_data$revenue


#  ---  3. Using XGBoost Model

##### Training the XGBoost model
xgb_model <- xgboost(data = as.matrix(revenue_matrix), label = revenue_target, 
                     nrounds = 50, objective = "reg:squarederror")


#  ---  5.  Feature Importance Plot with XGBoost Mode

importance_matrix <- xgb.importance(model = xgb_model)
xgb.plot.importance(importance_matrix, main = "Feature Importance for Revenue Using the XGBoost Model")


#  ---  6.  Variables Significantly Influencing Revenue Using a Regression Model. 

#### The Key Drivers of Revenue using multiple linear regression model.
revenue_model <- lm(revenue ~ cost_price + profit + profit_margin + volume + customer_type + product_type + 
                      markets_state + markets_zone  , data = cleaned_sales_data)
summary(revenue_model)


