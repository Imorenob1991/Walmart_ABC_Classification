# Walmart_ABC_Classification
This project involves performing an ABC classification on a dataset that containing 1,913 days of historical sales from 10 Walmart stores in three different states of United States. The objective is to classify the SKUs based on their contribution to sales in unit and revenue. Finally, get powerful insights from the analysis and identifying further next steps. Lets Rock!

## Data Source

First of all, I want to mention that the data was obtained from Kaggle. Kaggle is the world's largest data science community, offering powerful tools and resources to help you achieve your data science goals.

Context: This dataset is openly available for academic purposes. The initial objective of Kaggle was to share historical data and then, through a competition, determine the group that had the best forecast accuracy. In this case, we will use this data for product segmentation. However, it is also an excellent dataset for forecasting and time series analysis.

Link : https://www.kaggle.com/c/m5-forecasting-accuracy/data

## General Understanding of the data from general to specific.

1. States: 3 - California (CA), Texas (TX), and Wisconsin (WI). /Representation of different zones within the United States.
2. Stores: 10
3. Categories: 3 (FOODS, HOBBIES, HOUSEHOLD)
4. Departments: 7 (FOODS_1, FOODS_2, FOODS_3, HOBBIES_1, HOBBIES_2, HOUSEHOLD_1, HOUSEHOLD_2)
5. SKUs: 3.039
6. Date Range (%Y-%m-%d): Between "2011-01-29" to "2016-06-19"

## DATA CLEANING AND PREPARATION 

1. Initial Data Subset: We will begin our analysis by working with a subset of the data (March 2011). By starting with this fraction, we can refine our methodology before applying it to the rest of the months or the entire dataset. This approach will streamline our data cleaning and preparation process, making it more efficient and workable.

2. Pivot Sales Columns: Convert the sales columns into a single column using the pivot_longer() function. This transformation will facilitate more straightforward analysis and manipulation of the sales data.

3. Join with Calendar Data: Perform a left join with the calendar data to incorporate date information. This step will help us align the sales data with specific dates, enhancing our temporal analysis.

4. Join with Sell Prices: Perform a left join with the sell_prices dataset to obtain the prices. This will allow us to calculate revenue (Quantity * Price)

## DATA ANALYSIS AND INTERPRETATION

Scope:
 States: 3
 Stores: 10
 Caregories: 3
 Departments: 7
 SKUs: 1.557
 Date Range (%Y-%m-%d): Between "2011-03-01" to "2011-03-31"

SKUs: There were a total of 1,557 SKUs in March 2011, representing 51% of the total SKUs sold between January 29, 2011, and June 19, 2016

### SCOPE Analysis N°1: SKU ABC Classification in tearms of Sales in Units

<img width="670" alt="ImageN°1(Units)" src="https://github.com/user-attachments/assets/eed4343a-517b-48e8-b9b8-5dab41723a9a">

    - A Products: 35.5% of SKUs generate 80% of total sales in units. These are the fast-moving goods in Walmart stores.
    
    - B Products: 30.8% of SKUs generate 15% of total sales in units. These are the regular/medium-moving goods in Walmart stores.
    
    - C Products: 33.7% of SKUs generate 5% of total sales in units. These are the slow-moving goods in Walmart stores.

### SCOPE Analysis N°2: SKU ABC Classification in tearms of Sales in Revenue

<img width="670" alt="ImageN°2(Revenue)" src="https://github.com/user-attachments/assets/4439c822-140f-40bc-a2eb-8bd20a3b3a46">

    - A Revenue Products: 43.7% of SKUs that generate 80% of total sales in Revenue. 
    
    - B Revenue Products: 28.1% of SKUs that generate 15% of total sales in Revenue. 
    
    - C Revenue Products: 28.2% of SKUs that generate 5% of total sales in Revenue. 


## Insights and Recommendations

1. Fast-Moving Goods: These products should be strategically placed on the middle shelves, which are the second most visible zones in the supermarket gondola. This placement ensures high visibility and accessibility for items that have a high turnover rate.

2. Type A Products: The distinction between Type A products in terms of units sold and revenue generated is notable. Higher-priced items, even if they move slower, can contribute significantly to revenue. Therefore, it is recommended to position high-revenue items on the top shelves, which are at eye level, to maximize their visibility and appeal.

3. Low Revenue SKUs: SKUs that account for only 28.2% of total revenue should be placed on the bottom shelves. These items, which contribute less to overall revenue and are less frequently purchased, benefit from being in a zone that is less accessible and visible.

## Next Steps:

  - Correlation Analysis: Investigate if there is a correlation between the shelf position of an item and its classification. This could provide valuable insights into how shelf placement impacts product performance and sales. Further data analysis will be needed to answer this question comprehensively.

  - Strategic Placement: If a correlation is found between shelf position and sales in units, it is advisable to place high-margin SKUs on the top shelves. Best-sellers, in terms of both units and revenue, should be positioned on the middle shelves to leverage their high turnover and ensure they remain easily accessible to customers.











