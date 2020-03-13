# Global Food Dollar Research Project 

This repository is created to share data and code of the global food dollar research project. 

# 1. [To Compute Food Dollars:](ComputeFoodDollar)

This [folder](ComputeFoodDollar) contains data and SAS scripts for computing global food dollars. 

- [sqlGFD.zip](ComputeFoodDollar\sqlGFD.zip) is the SAS data library. Please download the zip file and uncompress it. 

- [GFD.sas](ComputeFoodDollar\GFD.sas) is the SAS code for computing global food dollars. 

# 2. [To Prepare Data for Regression Analysis:](Analysis/DataPreparation)


This [folder](Analysis/DataPreparation/) contains [datasets](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/DataPreparation/DataPreparation.zip) and [STATA scripts](DataPreparation.do) for preparing regression dataset. The final dataset is also available at [Here](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/RegressionAnalysis/Data.zip).

- You can download The [DataPreparation zipped folder](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/DataPreparation/DataPreparation.zip) from: 
[https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/DataPreparation/DataPreparation.zip](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/DataPreparation/DataPreparation.zip "https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/DataPreparation/DataPreparation.zip")

- [The STATA script](Analysis/DataPreparation/DataPreparation.do) is developed to merge data from different sources for regression. Major steps in this STATA code includes:
	1. Farm share data	
	*Import sheets "Food", "Food & Tobacco", "Foodservice and accommodation", and "Food, Tobacco, accommodation"		
	*Reshape data		
	*Generate an indicator var that is coded 1 for food, 2 for food&tobacco, and 3 for food&accommodation		
	*Merge all farmshare data sets
	

	2. World Bank data
	*Import data form excel
	*Reshape data
	*Assign same country id as in farm share data
	*Merge all data sets		

	3. FAO Stat data
	*Import data form excel
	*Assign same country id as in farm share data
	*Merge all data sets
				
	4. Merge all data sets: save as "$data\farm share, WB, FAO.dta" for regression.

This [folder](Analysis/DataPreparation) contains datasets and STATA scripts for generating data of regression analysis. The [STATA script](Analysis/DataPreparation/Data Preparation.do) and [STATA datasets](Analysis/DataPreparation/DataPreparation.zip) can be used to replicate the dataset for [regression analysis](Analysis/RegressionAnalysis). The final dataset  is also available to download if you prefer to skip the data preparation step. 

# 3. [To Replicate the Regression Analysis:](Analysis/RegressionAnalysis)

This folder contains the cleaned [dataset](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/RegressionAnalysis/Data/farm%20share%2C%20WB%2C%20FAO.dta) and [STATA code](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/RegressionAnalysis/Data.zip) of regression analysis of the global food dollar research project. 


- [dataset](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/RegressionAnalysis/Data/farm%20share%2C%20WB%2C%20FAO.dta) is the STATA dataset for the regression. Please download the zipped file and uncompress it to have the "Data" folder on your local. 

- [STATA code](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/RegressionAnalysis/Data.zip) can be used to replicate the regression analysis.