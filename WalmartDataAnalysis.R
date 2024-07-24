
# Walmart Sales Goods Data Analysis

## First Step is to activate all the packages that we will need to use

library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)

## Importing our data-sets and general exploratory analysis

sell_prices <- read_csv("sell_prices.csv")
sales_train_validation <- read_csv("sales_train_validation.csv")
sales_train_evaluation <- read_csv("sales_train_evaluation.csv")
calendar<- read_csv("calendar.csv")
sample_submission <- read_csv("sample_submission.csv")

## Original description of data-sets

## calendar.csv - Contains information about the dates on which the products are sold.
glimpse(calendar) # Key is "d" attribute

## sales_train_validation.csv - Contains the historical daily unit sales data per product and store [d_1 - d_1913]
### It would be easier to work with the Unit Sales only one Columns (Now we have 1.913), but we will have a huge Data-set. Lets start with one month and then reply the query to the rest of the dataset.

## sample_submission.csv - The correct format for submissions. Reference the Evaluation tab for more info.
### Is the format to generate the forecast, in this analysis will be omitted.

## sell_prices.csv - Contains information about the price of the products sold per store and date.
### After wrangling the sales_train_validation, we can add this information of prices, to obtain revenue.
### We can make ABC Curves with unit sales and revenue, and then compare the results.

glimpse(sell_prices) # Key is a join of three columns (store_id + item_id + wm_yr_wk)

## sales_train_evaluation.csv - Includes sales [d_1 - d_1941] (labels used for the Public leader board)

## 1. GENERAL UNDERSTANDING OF THE DATA

### TOTAL SKUs
SKUs_df <- length(table(sales_train_validation$item_id)) # Total of 3.049 SKUS

### TOTAL Stores 
length(table(sales_train_validation$store_id)) # Total of 10 Stores

### Total Department or categories ID
Departments <- table(sales_train_validation$dept_id)
DF_Departments <- data.frame(Departments)

### FOODS_(1:3) + HOBBIES(1:2) + HOUSEHOLD(1:2) - Total 7 Subcategories or Departments

Categories <- table(sales_train_evaluation$cat_id)

### FOODS + HOBBIES + HOUSEHOLD - Total 3 Categories.

### States: CA(California) - TX(Texas) - WI(Wisconsin)

States <- table(sales_train_evaluation$state_id)

### Dates Range
min(calendar$date)
max(calendar$date)

## 2. DATA CLEANING AND PREPARATION

### To the initial analysis, we are going to filter 1 Month. Actually, we have 1.913 days that represent approximately 64 months
### We are going to choose March of 2011

Calendar_March_2011 <- calendar %>% filter(date >= "2011-03-01" & date <="2011-03-31" )

### Now we have to determine the D_Columns to filter

Calendar_March_2011$d
  
sales_train_validation_March_2011 <- sales_train_validation %>%
  select(id, item_id, dept_id, cat_id, store_id, state_id,
         d_32, d_33, d_34, d_35, d_36, d_37, d_38, d_39, d_40, d_41, d_42,
         d_43, d_44, d_45, d_46, d_47, d_48, d_49, d_50, d_51, d_52, d_53,
         d_54, d_55, d_56, d_57, d_58, d_59, d_60, d_61, d_62)

### With pivot table (Pivot_longer) convert all the Columns Days into one Attribute

sales_train_validation_March_2011 <- sales_train_validation_March_2011 %>%
  pivot_longer(cols = starts_with("d_"),
               names_to = "day",
               values_to = "Unit_Sales") %>% 
  filter(Unit_Sales > 0)

### Join with Calendar Data Frame to obtain more information about day week and week

colnames(sales_train_validation_March_2011)

sales_train_validation_March_2011 <- sales_train_validation_March_2011 %>%
  left_join(Calendar_March_2011, by = c("day" = "d")) %>% 
  select(id,item_id,dept_id,cat_id,store_id,state_id,day,Unit_Sales,date,wm_yr_wk,weekday,wday,month,year)

### Finally, we are going to add the sell_price of each product and calculate Revenue (Quantity*Price). To be able to make a classification based on units and sales.

colnames(sell_prices)

sales_train_validation_March_2011 <- sales_train_validation_March_2011 %>%
  left_join(sell_prices, by = c("store_id", "item_id", "wm_yr_wk")) %>%
  mutate(revenue = Unit_Sales * sell_price)

### Now we have to check if we have NA and the final structure of our dataframe. Check if the datatypes are right.

glimpse(sales_train_validation_March_2011) # OK with all the date types

sum(is.na(sales_train_validation_March_2011$Unit_Sales)) # No NA
sum(is.na(sales_train_validation_March_2011$sell_price)) # No NA
sum(is.na(sales_train_validation_March_2011$revenue)) # No NA


















