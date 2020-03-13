# Data Preparation for Regression Analysis

This folder contains [data](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/DataPreparation/DataPreparation.zip) and [Stata scripts](DataPreparation.do) to create the dataset for regression analysis. If you prefer to skip the data preparation step, the final dataset is also available at [Here](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/RegressionAnalysis/Data.zip).

- The [DataPreparation](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/DataPreparation/DataPreparation.zip) zipped folder contains all source data needed for this step.

- The [STATA script](DataPreparation.do) is developed to merge data from different sources for regression. 

#### Instructions:

 1. Please download the [DataPreparation](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/DataPreparation/DataPreparation.zip) zipped file and uncompress it to have the "DataPreparation" folder in your working directory.
 
 2. Make sure that the working directory is specified properly in the "cd" command (included in the Stata code).
 
 3. Create a "Data" folder in the working directory to save output data. 

#### Major steps in this STATA code includes:

  a. Reshape [farm share data](ComputeFoodDollar)	

  b. Prepare population, urbanization, GDP, access to electricity data from [World Bank](https://data.worldbank.org/)

  c. Prepare gross production values, agricultural value added and land data from [FAOSTAT](http://www.fao.org/faostat/en/)

  d. merge all data sets.
	
The final [dataset](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/RegressionAnalysis/Data.zip) is also available to download if you prefer to skip the data preparation step. 




	
#### [[Back to Parent directory]](https://fedscornell.github.io/GlobalFoodDollar/)