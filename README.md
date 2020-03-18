# Global Food Dollar Research Project 

This repository is created to share data and code of the global food dollar research project. 

# [1. Computation of Farm Shares](ComputeFoodDollar)

This [section](ComputeFoodDollar) contains the data and SAS script for computing global food dollars. 

- [sqlGFD.zip](https://fedscornell.github.io/GlobalFoodDollar/ComputeFoodDollar/sqlGFD.zip) is the SAS data library. 
- [GFD.sas](https://fedscornell.github.io/GlobalFoodDollar/ComputeFoodDollar/GFD.sas) is the SAS code for computing global food dollars using the [sqlGFD](https://fedscornell.github.io/GlobalFoodDollar/ComputeFoodDollar/sqlGFD.zip) library. 

#### Instructions:

 1. Please uncompress the downloaded data library to have the sqlGFD library in your directory.
 
 2. Specify the directory of the sqlGFD library in the libname statement in the [GFD.sas](https://fedscornell.github.io/GlobalFoodDollar/ComputeFoodDollar/GFD.sas) code.

# [2. Data Preparation for Regression Analysis](Analysis/DataPreparation)

This [section](Analysis/DataPreparation/) contains [data](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/DataPreparation/DataPreparation.zip) and [Stata scripts](Analysis/DataPreparation/DataPreparation.do) to create the dataset for regression analysis. If you prefer to skip the data preparation step, the final dataset is also available at [Here](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/RegressionAnalysis/Data.zip).

- The [DataPreparation](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/DataPreparation/DataPreparation.zip) zipped folder contains all source data needed for this step.

- The [STATA script](Analysis/DataPreparation/DataPreparation.do) is developed to merge data from different sources for regression. 

#### Instructions:

 1. Please download the [DataPreparation](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/DataPreparation/DataPreparation.zip) zipped file and uncompress it to have the "DataPreparation" folder in your working directory.
 
 2. Make sure that the working directory is specified properly in the "cd" command (included in the Stata code).
 
 3. Create a "Data" folder in the working directory to save output data. 

#### Major steps in this Stata code includes:

  a. Reshape [farm share data](ComputeFoodDollar)	

  b. Prepare population, urbanization, GDP, access to electricity data from [World Bank](https://data.worldbank.org/)

  c. Prepare gross production values, agricultural value added and land data from [FAOSTAT](http://www.fao.org/faostat/en/)

  d. merge all data sets.
	
The final [dataset](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/RegressionAnalysis/Data.zip) is also available to download if you prefer to skip the data preparation step. 

# [3. Regression Analysis](Analysis/RegressionAnalysis)

This [section](Analysis/RegressionAnalysis) contains the cleaned [dataset](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/RegressionAnalysis/Data.zip) and [Stata code](Analysis/RegressionAnalysis/GFDRegression.do) of creating regression results (table S4 in the supplementary materials)

- The [Stata dataset](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/RegressionAnalysis/Data.zip) is developed for the regression analysis. 

- [Stata code](Analysis/RegressionAnalysis/GFDRegression.do) can be used to replicate the regression analysis in table S4. 

#### Instructions:

 1. Please download the [zipped file](https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/RegressionAnalysis/Data.zip), uncompress it to have the "Data" folder in your working directory.

 2. Make sure that the working directory is specified properly in the "cd" command (included in the [Stata code](Analysis/RegressionAnalysis/GFDRegression.do).
  
----------------------------------------------------------------------------------------------
# Acknowledgments:  

E, Meemken acknowledges support from the German Research Foundation (DFG-fellowship GZ: ME 5179/1-1). 

The findings and conclusions in this manuscript are those of the authors and should not be construed to represent any official USDA or U.S. Government determination or policy.

# Funding: 

This work was supported by the Cornell SC Johnson College of Business and Cooperative Agreement number 58-4000-8-0051 between Cornell University and the Economic Research Service of the U.S. Department of Agriculture. 

