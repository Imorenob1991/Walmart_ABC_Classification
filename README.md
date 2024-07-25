# Walmart_ABC_Classification
This project involves performing ABC classification on a dataset that containing 1,913 days of historical sales data from 10 Walmart stores, covering 3,039 different SKUs. The objective is to classify the SKUs based on their contribution to total revenue and unit sales. Lets Rock!

## Data Source

First of all, I want to mention that the data was obtained from Kaggle. Kaggle is the world's largest data science community, offering powerful tools and resources to help you achieve your data science goals.

Context: This dataset is openly available for academic purposes. The initial objective of Kaggle was to share historical data and then, through a competition, determine the group that had the best forecast accuracy. In this case, we will use this data for product segmentation. However, it is also an excellent dataset for practicing your forecasting and time series analysis skills.

Link : https://www.kaggle.com/c/m5-forecasting-accuracy/data

## General Understanding of the data from general to specific  - Previous to data Wrangling and Calculations.

1. States: 3 California (CA), Texas (TX), and Wisconsin (WI). /Representation of different zones within the United States.
2. Stores: 10
3. Categories: 3 (FOODS, HOBBIES, HOUSEHOLD)
4. Departments: 7 (FOODS_1, FOODS_2, FOODS_3, HOBBIES_1, HOBBIES_2, HOUSEHOLD_1, HOUSEHOLD_2)
5. SKUs: 3.039
6. Date Range (%Y-%m-%d): Between "2011-01-29" to "2016-06-19"

## DATA CLEANING AND PREPARATION 

1. Initial Data Subset: We will begin our analysis by working with a subset of the data, specifically focusing on March 2011. By starting with this fraction, we can refine our methodology before applying it to the rest of the months or the entire dataset. This approach will streamline our data cleaning and preparation process, making it more efficient and workable.

2. Pivot Sales Columns: Convert the sales columns into a single column using the pivot_longer() function. This transformation will facilitate more straightforward analysis and manipulation of the sales data.

3. Join with Calendar Data: Perform a left join with the calendar data to incorporate date information. This step will help us align the sales data with specific dates, enhancing our temporal analysis.

4. Join with Sell Prices: Perform a left join with the sell_prices dataset to obtain the prices. This will allow us to calculate revenue, which is essential for classifying products based on both unit sales and revenue.

## DATA ANALYSIS AND INTERPRETATION

SCOPE: All Stores (10) and SKUs, with no Filter nor Classifications.
SKUs: 1.557 Total in March 2011 - This represent 51% of the Total SKUs sold between 2011-01-29 to 2016-06-19

### SCOPE Analysis N°2: All the data with no classification. ABC Classification of Units_Sales by Item_id = SKU.













