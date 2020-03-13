# Global Food Dollar Research Project 

This folder contains [datasets](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/DataPreparation/DataPreparation.zip) and [STATA scripts](DataPreparation.do) for preparing regression dataset. The final dataset is also available at [Here](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/RegressionAnalysis/Data.zip).

- You can download The [DataPreparation zipped folder](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/DataPreparation/DataPreparation.zip) from: 
[https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/DataPreparation/DataPreparation.zip](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/DataPreparation/DataPreparation.zip "https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/DataPreparation/DataPreparation.zip")

- [The STATA script](DataPreparation.do) is developed to merge data from different sources for regression. Major steps in this STATA code includes:
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
	
#### [[Back to Parent directory]](https://fedscornell.github.io/GlobalFoodDollar/)