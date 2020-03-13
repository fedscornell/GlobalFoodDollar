*****************************************************************************
* This script is developed for the global food dollar project

* This STATA code is developed for regression analysis.
* The farm share, WB, FAO.dta is available at:
* https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/RegressionAnalysis/Data/farm%20share%2C%20WB%2C%20FAO.dta

* The STATA dataset "farm share, WB, FAO.dta" can be replicated using the STATA code and datasets in 
* https://fedscornell.github.io/GlobalFoodDollar/Analysis/DataPreparation/

* Regression 
*****************************************************************************
set more off
clear all

cd "Your directory here. This folder should contain the uncompressed DataPreparation folder"
global data ".\Data" 

use  "$data\farm share, WB, FAO.dta"
sum

tab indicator

*The variable "indicator" indicates the type of estimate and is coded as:
*1 for "food" 
*2 for "food_tobacco" 
*3 for "foodservice_accommodation" 

*Generate new variables to rescale / take logs
gen gdp_pc_ppp_th = gdp_pc_ppp/1000
label var gdp_pc_ppp_th "GDP per capita in 1000 (PPP), (2011 constant)"
gen ln_gdp_pc_ppp = ln(gdp_pc_ppp)
label var ln_gdp_pc_ppp "Ln GDP pc PPP (2011 constant)"
gen population_m = population/1000000
label var population_m "Population, total in million"
gen ln_population = ln(population)
			label var ln_population "Ln population"
	
*Generate Productivity Measure	
gen productivity_r = gross_production_value/agriculture_land_total
label var productivity "Productivity Raw (gross production value(constant million US)/agriculture land(1000 ha))"

*Rescale Productivity
gen productivity = productivity_r/100
	label var productivity "Productivity scaled (gross production value(constant 100 million US)/agriculture land(1000 ha))"

* Rescale Year : Recode 2005-2015 to 1-11
rename year year_raw
gen year = year_raw

recode year (2005=1) (2006=2) (2007=3) (2008=4) (2009=5) (2010=6) (2011=7) (2012=8) (2013=9) (2014=10) (2015=11)

*Drop Ireland, Turkey, and Luxembourg
sum farm_share if country == "Ireland"
drop if country == "Ireland"
sum farm_share if country == "Turkey"
drop if country == "Turkey"
sum farm_share if country == "Luxembourg"
drop if country == "Luxembourg"
	
*Descriptive statistics
*****************************************************************************
sum farm_share if indicator == 1
sum farm_share if indicator == 2
sum farm_share if indicator == 3
global all gdp_pc_ppp_th population_m electricity urbanization ///
gross_production_value productivity agriculture_land_total ag_employment
sum $all
sum $all	 if indicator == 1 | indicator ==2

* Descriptive statistics of year 2015 used in Manuscript
*****************************************************************************
sum farm_share if indicator == 1 & year == 2015
sum farm_share if indicator == 2 & year == 2015
sum farm_share if indicator == 3 & year == 2015


*Generate weights. Only needed for regressions of "food and food&tobacco"
*****************************************************************************
*This variable will be coded as 1 if we have only one estimate per country
*and as 1/2 if we have two estimates

gen indicator_2 = indicator
replace indicator_2 = 0 if indicator_2 == 3
replace indicator_2 = 1 if indicator_2 == 2
tab indicator_2

*Browse country year indicator indicator_2
egen weight_FFT = sum(indicator_2), by (country year)
replace weight_FFT = . if weight_FFT ==0
replace weight_FFT = 1 if weight_FFT ==1
replace weight_FFT = 1/2 if weight_FFT ==2
tab weight_FFT

*Browse country year indicator indicator_2 weight
replace weight_FFT = . if  indicator== 3
tab weight_FFT

*Browse country year indicator indicator_2 weight
tab weight_FFT
label var weight_FFT "Weight for food and food & tobacco regressions"
drop indicator_2

gen indicator_2 = indicator
replace indicator_2 = 1 if indicator_2 == 3
replace indicator_2 = 1 if indicator_2 == 2
tab indicator_2
egen weight_FFTFSA = sum(indicator_2), by (country year)
tab weight_FFTFSA
tab weight_FFTFSA

replace weight_FFTFSA = . if weight_FFTFSA == 0
replace weight_FFTFSA = 1 if weight_FFTFSA == 1
replace weight_FFTFSA = 1/2 if weight_FFTFSA == 2
replace weight_FFTFSA = 1/3 if weight_FFTFSA == 3
tab weight_FFTFSA

*Browse country year indicator indicator_2 weight_FFTA
tab weight_FFTFSA
tab weight_FFT
label var weight_FFTFSA "Weight for food and food&tobacco and food services & accommodation regressions"
drop indicator_2


*****************************************************************************
/*Regressions with: 

(1) indicator FE
(2) indicator, country FE
(3) indicator, country, year FE
(4) indicator, country, FE & year trend

(1)-(3) include indicator dummy variable
***(1.1)-(3.1) only if indicator == 1 (only food)
***(1.2)-(3.2) only if indicator == 2 (only food & tobacco)
***(1.3)-(3.3) only if indicator == 3 (only food & accommodation)

robust standard errors clustered at country level
*/
*****************************************************************************


*Run regressions for GDP, Productivity
global x ln_gdp_pc_ppp productivity 
est clear


********* Food, Food & Tobacco, Food Service & Accommodation***********
*(1)
reg farm_share $x i.indicator [iweight=weight_FFTFSA], cluster (id) robust
eststo a1

/*Predicted values for food only and food&tobacco: Indicator FE Model
Predict pfta_fs1
Label var pfta_fs1 "Food, Tobacco, Accommodation Indicator FE"
	*/


*(2)
reg farm_share $x i.indicator i.id [iweight=weight_FFTFSA], cluster(id)robust
	eststo b1
	
/*Predicted values for food only and food&tabacco: Indicator and Country FE Model
Predict pfta_fs2
Label var pfta_fs2 "Food, Tobacco, Accommodation Indicator & Country FE"
	*/

*(3)
reg farm_share $x i.indicator i.id i.year [iweight=weight_FFTFSA], cluster (id)robust
	eststo c1
		
/*Predicted values for food only and food&tabacco: Indicator, Country, Year FE Model
Predict pfta_fs3
Label var pfta_fs3 "Food, Tobacco, Accommodation Indicator, Country, Year FE Model"
	*/

*(4)
reg farm_share $x year i.indicator i.id [iweight=weight_FFTFSA], cluster (id) robust
eststo d1
			
/*Predicted values for food only and food&tabacco: Indicator, Country, Year FE Model
Predict pfta_fs4
Label var pfta_fs4 "Food, Tobacco, Accommodation Indicator, Country FE, Year Trend Model"
	*/	
	
	
********* Food Only and Food & Tobacco *********
*(1.1)
*Might need to install the estout package. Uncomment the following command if needed.
*ssc install estout, replace
reg farm_share $x i.indicator if indicator == 1 | indicator == 2 [iweight=weight_FFT], cluster (id) robust 
eststo a

/*Predicted values for food only and food&tobacco: Indicator FE Model
Predict pft_fs1 if indicator == 1 | indicator == 2
Label var pft_fs1 "Food and Tobacco Indicator FE"
	*/

*(2.1)
reg farm_share $x i.indicator i.id if indicator == 1 | indicator == 2 [iweight=weight_FFT], cluster (id)robust
	eststo b	

/*Predicted values for food only and food&tobacco: Indicator and Country FE Model
Predict pft_fs2 if indicator == 1 | indicator == 2
Label var pft_fs2 "Food and Tobacco Indicator & Country FE"
	*/


*(3.1)
reg farm_share $x i.indicator i.id i.year if indicator == 1 | indicator == 2 [iweight=weight_FFT], cluster (id)robust
eststo c

/*Predicted values for food only and food&tobacco: Indicator, Country, Year FE Model
Predict pft_fs3 if indicator == 1 | indicator == 2
Label var pft_fs3 "Food and Tobacco Indicator, Country, Year FE"
*/

*(4.1)
reg farm_share $x year i.indicator i.id if indicator == 1 | indicator == 2 [iweight=weight_FFT], cluster (id)robust
eststo d
/*Predicted values for food only and food&tobacco: Indicator, Country, FE, and Year Trend Model
Predict pft_fs4 if indicator == 1 | indicator == 2
	Label var pft_fs4 "Food and Tobacco Indicator, Country FE, Year Trend"
	*/
	

esttab  a1 b1 c1 d1 a b c d using results.csv, nogaps compress label ///
nobaselevels b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) replace


***Correlation between explanatory variables
global exp_vars farm_share ln_gdp_pc_ppp productivity ln_population urbanization  electricity  ag_employment
correlate $exp_vars 
correlate  $exp_vars if indicator==1 | indicator ==2 


*Number of Countries with Farm Shares
*Might need to install the unique package. Uncomment the following command if needed.
*ssc install unique
unique country if indicator==1
unique country if indicator==2
unique country if indicator==3
unique country if indicator==1 | indicator==2


* Country-Year pairs for food only and food&tobacco
tab country year if indicator ==1 | indicator==2

***Descriptive statistics of predicted farm shares
sum pft* if indicator==1
sum pft* if indicator==2
sum pft* if indicator==3

drop _est*
save "$data\farm share, WB, FAO, w predict.dta", replace


keep country year indicator farm_share pft*
save "$data\farm_share predict.dta"
