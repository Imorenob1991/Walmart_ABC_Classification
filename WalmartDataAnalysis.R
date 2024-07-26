# Walmart Sales Goods Data Analysis

## First Step is to activate all the packages that we will need to use

library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)

## Importing our data-sets and general exploratory analysis

sell_prices <- read_csv("sell_prices.csv")
sales_train_validation <- read_csv("sales_train_validation.csv")
### sales_train_evaluation <- read_csv("sales_train_evaluation.csv")
calendar<- read_csv("calendar.csv")
### sample_submission <- read_csv("sample_submission.csv")

## Original description of data-sets

## calendar.csv - Contains information about the dates on which the products are sold.
glimpse(calendar) # Key is "d" attribute

## sales_train_validation.csv - Contains the historical daily unit sales data per product and store [d_1 - d_1913]
### It would be easier to work with the Unit Sales only one Columns (Now we have 1.913), but we will have a huge Data-set. Lets start with one month and then reply the query to the rest of the data-set.

## sample_submission.csv - The correct format for submissions. Reference the Evaluation tab for more info.
### Is the format for the output of the initial assigment, in this analysis will be omitted.

## sell_prices.csv - Contains information about the price of the products sold per store and date.
### After wrangling the sales_train_validation, we can add this information of prices, to obtain revenue.
glimpse(sell_prices) # Key is a join of three columns (store_id + item_id + wm_yr_wk)

## sales_train_evaluation.csv - Includes sales [d_1 - d_1941] (labels used for the Public leader board)
### In this case, we will work only with the database sales_train_validation.csv 

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

### Now we have to determine the D_Columns that correspond to Marchh 2011

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

write_csv(sales_train_validation_March_2011,"March_2011_Data_Frame.csv")

## 3. DATA ANALYSIS AND INTERPRETATION

### SCOPE Analysis N°1: All the data with no classification. ABC Classification of QUANTITY by Item_id = SKU.

ABC_Classifiction_Units <- sales_train_validation_March_2011 %>%  group_by(item_id) %>% 
  summarise(Total_Unit_Sales = sum(Unit_Sales, na.rm = TRUE)) %>%
  mutate(Percentage_Unit_Sales = Total_Unit_Sales/sum(Total_Unit_Sales)*100) %>% 
  arrange(desc(Total_Unit_Sales)) %>% 
  mutate(Acum_Precentage_Unit_Sales = cumsum(Percentage_Unit_Sales)) %>% 
  mutate(ABC_Classification = ifelse(Acum_Precentage_Unit_Sales <= 80, "A", 
                                 ifelse(Acum_Precentage_Unit_Sales <= 95 , "B", "C")))

Table_ABC_Classification_Units1 <- ABC_Classifiction_Units %>% group_by(ABC_Classification) %>% 
  summarise(SKUs = n(),
            Unit_Sale = sum(Total_Unit_Sales),
            Percentage_Sales = sum(Percentage_Unit_Sales)) %>% 
  mutate(Percentage_SKUs = SKUs/sum(SKUs)*100) %>% 
  mutate(Cumulative_SKUs1 = cumsum(Percentage_SKUs),
         Cumulative_Sales1 = cumsum(Percentage_Sales))

zero_point <- data.frame(ABC_Classification = "", SKUs = 0, Unit_Sale = 0, Percentage_Sales = 0, Percentage_SKUs = 0, Cumulative_SKUs1 = 0, Cumulative_Sales1 = 0)

Table_ABC_Classification_Units1 <- bind_rows(zero_point, Table_ABC_Classification_Units1)

### Plotting ABC_Classification_Units_All_Stores_All_SKUs

ggplot(Table_ABC_Classification_Units1, aes(x = Cumulative_SKUs1, y = Cumulative_Sales1, label = ABC_Classification)) +
  geom_point(size = 3) +  # Scatter plot points
  geom_text(vjust = -0.5, hjust = 0.8, color = "black", fontface = "bold") +
  geom_smooth(method = "lm", formula = y ~ poly(x, 3), se = FALSE, color = "grey") +
  labs(title = "ABC_Classification_Total_SKU_STORES_UNITS",
       x = "Cumulative_SKU (%)",
       y = "Cumulative_Sales (%)") +
  scale_x_continuous(limits = c(0, 110), breaks = seq(0, 100, by = 10)) +  # Set x-axis limit and breaks
  scale_y_continuous(limits = c(0, 110), breaks = seq(0, 100, by = 10)) +  # Set y-axis limit and breaks
  theme_minimal() +
  annotate("point", x = 0, y = 0, size = 3, color = "black") +  # Add (0,0) point
  annotate("text", x = 0, y = 0, label = "(0,0)", vjust = -0.5, hjust = 0.5, color = "grey", fontface = "bold")  # Label for (0,0) point

### SCOPE Analysis N°2: All the data with no classification. ABC Classification of SALES by Item_id = SKU.

length(ABC_Classifiction_Sales1$item_id)

length(ABC_Classifiction_Sales1$item_id)/SKUs_df


ABC_Classifiction_Sales1 <- sales_train_validation_March_2011 %>%  group_by(item_id) %>% 
  summarise(Total_Revenue_Sales = sum(revenue, na.rm = TRUE)) %>%
  mutate(Percentage_Revenue_Sales = Total_Revenue_Sales/sum(Total_Revenue_Sales)*100) %>% 
  arrange(desc(Total_Revenue_Sales)) %>% 
  mutate(Acum_Precentage_Revenue_Sales = cumsum(Percentage_Revenue_Sales)) %>% 
  mutate(ABC_Classification = ifelse(Acum_Precentage_Revenue_Sales <= 80, "A", 
                                     ifelse(Acum_Precentage_Revenue_Sales <= 95 , "B", "C")))

Table_ABC_Classification_Revenue1 <- ABC_Classifiction_Sales1 %>% group_by(ABC_Classification) %>% 
  summarise(SKUs = n(),
            Revenue_Sale = sum(Total_Revenue_Sales),
            Percentage_Sales = sum(Percentage_Revenue_Sales)) %>% 
  mutate(Percentage_SKUs = SKUs/sum(SKUs)*100) %>% 
  mutate(Cumulative_SKUs1 = cumsum(Percentage_SKUs),
         Cumulative_Sales1 = cumsum(Percentage_Sales))

colnames(Table_ABC_Classification_Revenue1)

zero_point2 <- data.frame(ABC_Classification = "", SKUs = 0, Revenue_Sale = 0, Percentage_Sales = 0, Percentage_SKUs = 0, Cumulative_SKUs1 = 0, Cumulative_Sales1 = 0)

Table_ABC_Classification_Revenue1 <- bind_rows(zero_point2, Table_ABC_Classification_Revenue1)

### Plotting ABC_Classification_Revenue_All_Stores_All_SKUs

ggplot(Table_ABC_Classification_Revenue1, aes(x = Cumulative_SKUs1, y = Cumulative_Sales1, label = ABC_Classification)) +
  geom_point(size = 3) +  # Scatter plot points
  geom_text(vjust = -0.5, hjust = 0.8, color = "black", fontface = "bold") +
  geom_smooth(method = "lm", formula = y ~ poly(x, 3), se = FALSE, color = "grey") +
  labs(title = "ABC_Classification_Total_SKU_STORES_REVENUE",
       x = "Cumulative_SKU (%)",
       y = "Cumulative_Sales (%)") +
  scale_x_continuous(limits = c(0, 110), breaks = seq(0, 100, by = 10)) +  # Set x-axis limit and breaks
  scale_y_continuous(limits = c(0, 110), breaks = seq(0, 100, by = 10)) +  # Set y-axis limit and breaks
  theme_minimal() +
  annotate("point", x = 0, y = 0, size = 3, color = "black") +  # Add (0,0) point
  annotate("text", x = 0, y = 0, label = "(0,0)", vjust = -0.5, hjust = 0.5, color = "grey", fontface = "bold")  # Label for (0,0) point























