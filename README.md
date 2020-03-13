# Global Food Dollar Research Project 

#### This repository is created to share data and code of the global food dollar research project. 

# 1. [Computation of Farm Shares](ComputeFoodDollar)

This [folder](ComputeFoodDollar) contains the data and SAS script for computing global food dollars. 

- [sqlGFD.zip](ComputeFoodDollar\sqlGFD.zip) is the SAS data library. 
- [GFD.sas](ComputeFoodDollar\GFD.sas) is the SAS code for computing global food dollars using the [sqlGFD](ComputeFoodDollar\sqlGFD.zip) library. 

#### Instructions:

 1. Please uncompress the downloaded data library to have the sqlGFD library in your directory.
 
 2. Specify the directory of the sqlGFD library in the libraname statement in the [GFD.sas](ComputeFoodDollar\GFD.sas) code.

# 2. [Data Preparation for Regression Analysis](Analysis/DataPreparation)

This [folder](Analysis/DataPreparation/) contains [data](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/DataPreparation/DataPreparation.zip) and [Stata scripts](DataPreparation.do) to create the dataset for regression analysis. If you prefer to skip the data preparation step, the final dataset is also available at [Here](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/RegressionAnalysis/Data.zip).

- The [DataPreparation](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/DataPreparation/DataPreparation.zip) zipped folder contains all source data needed for this step.

- The [STATA script](Analysis/DataPreparation/DataPreparation.do) is developed to merge data from different sources for regression. 

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

# 3. [Regression Analysis](Analysis/RegressionAnalysis)

This [folder](Analysis/RegressionAnalysis) contains the cleaned [dataset](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/RegressionAnalysis/Data/farm%20share%2C%20WB%2C%20FAO.dta) and [Stata code](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/RegressionAnalysis/Data.zip) of creating regression results (table S4 in the supplementary materials)

- [dataset](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/RegressionAnalysis/Data/farm%20share%2C%20WB%2C%20FAO.dta) is the STATA dataset for the regression. 

- [STATA code](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/RegressionAnalysis/Data.zip) can be used to replicate the regression analysis. 

#### Instructions:

 1. Please download the [zipped file](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/RegressionAnalysis/Data/farm%20share%2C%20WB%2C%20FAO.dta), uncompress it to have the "Data" folder in your working directory.

 2. Make sure that the working directory is specified properly in the "cd" command (included in the [STATA code](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/RegressionAnalysis/Data.zip)).