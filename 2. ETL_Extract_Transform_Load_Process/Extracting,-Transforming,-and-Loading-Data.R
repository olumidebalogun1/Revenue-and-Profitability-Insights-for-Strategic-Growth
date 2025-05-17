--------------------------------------------------------------------
  
#  Title: "ETL Process: Extracting, Transforming, and Loading Data"
#  Author: "Olumide Balogun"
#  Date: "2024-09-22"
  
-------------------------------------------------------------------
  
# ===============================================================================================  

#   Performing ETL (Extract, Transform, and Load)
  
#   This section outlines the ETL process used to prepare the data for analysis. It involves:
  
#   1. Extracting raw datasets from various sources (e.g., customer, product, transactions, and market data),
  
#   2. Transforming the data by merging sources, correcting data types, handling missing values,
#      and removing duplicates to ensure consistency and accuracy.
  
#   3. And finally, Loading the cleaned and structured data into the analysis environment for further
#      exploration and modeling.

# ===============================================================================================  

  
#  ---  Loading Necessary Libraries  ---
library(tidyverse)
library(ggplot2)
library(readxl)
library(lubridate)


#  ---  Importing Datasets  ---
Sales_Transactions <- read_excel("C:/Dataset/Sales _Transactions.xlsx")
View(Sales_Transactions)        

Sales_Customers <- read_excel("C:/Dataset/Sales_Customers.xlsx")
View(Sales_Customers)  

Sales_Markets <- read_excel("C:/Dataset/Sales_Markets.xlsx")
View(Sales_Markets)        

Sales_products <-read_excel("C:/Dataset/Sales_products.xlsx")
View(Sales_products)


#  ---  Joining Extracted Tables Together  ---

##### Performing simultaneous left joins
sales_data <- Sales_Transactions %>%
  left_join(Sales_Customers, by = "customer_code") %>%
  left_join(Sales_Markets, by = "market_code") %>%
  left_join(Sales_products, by = "product_code")                          
view(sales_data )


# ---  Data Cleaning  ---

#####  1. Checking for Missing Data
total_missing_values <- sum(is.na(sales_data))
print(paste("Total missing values in the dataset:", total_missing_values))

#####  2. Removing missing data & Checking for missing data again
sales_data <- sales_data %>% 
  na.omit(sales_data)

sum(is.na(sales_data))                                 


#####  3. Checking the structure of the dataset
str(sales_data)


#####  4. Updating Column Names by Renaming market_name to markets_state, sales_amount to revenue, and sales_qty to volume to enhance clarity, consistency, and alignment with business best practise. 
sales_data <- sales_data %>%
  rename(
    markets_state = markets_name,              # Renamin market_name to markets_state
    revenue = sales_amount,                    # Renaming sales_amount to revenue
    volume = sales_qty                         # Renaming sales_qty to volume
  )

head(sales_data)


#####  5. Removing duplicate rows
sales_data <- sales_data %>% 
  distinct()


#####  6. Converting order_date to date format and extract year/month.
sales_data$order_date <- as.Date(sales_data$order_date, format = "%Y-%m-%d")      # Converting date
sales_data$year <- format(sales_data$order_date, "%Y")                            # Extracting Year
sales_data$month <- format(sales_data$order_date, "%Y-%m")                        # Extracting Year and Month


#####  7. Calculating and displaying the number of rows and columns in sales_data. 
num_rows <- nrow(sales_data)
print(paste("Number of rows:", num_rows))

num_columns <- ncol(sales_data)
print(paste("Number of columns:", num_columns))

print(paste("The Sales_dataset has", num_rows, "rows and",num_columns , "columns."))


#  ---  Exploratory Data Analysis 1 (EDA) - statistical summary  ---

###  Generating a statistical summary for specific columns in sales_data.

#####  1. Columns to Summarize
selected_columns <- c("volume", "revenue", "cost_price", "profit", "profit_margin")


#####  2. Viewing Summary of Selected Columns
sales_data %>%
  select(all_of(selected_columns)) %>%
  summary()


#  ---  Exporting Cleaned Data to CSV  ---
write.csv(sales_data, "processed_sales_data.csv", row.names=FALSE)
