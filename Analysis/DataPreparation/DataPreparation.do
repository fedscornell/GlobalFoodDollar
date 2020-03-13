*****************************************************************************
* This script is developed for the global food dollar project.

* This STATA code is developed to merge data from different sources for regression analysis.
* The "DataPreparation" folder contains all source data needed for this step. 
* The zipped folder is available at: 
* https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/Analysis/DataPreparation/DataPreparation.zip
* 1. Please download the zipped file and uncompress it to have the "DataPreparation" folder in your working directory.
* 2. Make sure that the working directory is sepcified properly use the "cd" command (included below).
* 3. Create a "Data" folder in the working directory to save data

* Major steps in this STATA code includes:

*1) Farm share data	
	*Import sheets "Food", "Food & Tobacco", "Foodservice and accommodation", and "Food, Tobacco, accommodation"		
	*Reshape data		
	*Generate an indicator var that is coded 1 for food, 2 for food&tobacco, and 3 for food&accommodation		
	*Merge all farmshare data sets

*2) World Bank data
	*Import data form excel
	*Reshape data
	*Assign same country id as in farm share data
	*Merge all data sets		

*3) FAO Stat data
	*Import data form excel
	*Assign same country id as in farm share data
	*Merge all data sets
				
*4) Merge all data sets: save as "$data\farm share, WB, FAO.dta"


********************************************************************************
		
set more off
clear all
*******************Edit Directory Here******************************************
cd "Your directory here. This folder should contain the uncompressed DataPreparation folder"
********************************************************************************
global data ".\DataPreparation" 	/* "DataPreparation" is downloaded and uncompressed folder*/
global dataOutput ".\Data" 			/* This folder will contain the output data*/


*1
********************************************************************************
*Import farm share data from excel file 
*sheets "Food", "Food & Tobacco", "Foodservice and accommodation", and
*"Food, Tobacco, accommodation"
********************************************************************************
*Food
clear
import excel "$data\Farm share.xlsx", sheet("Food") firstrow
drop M
*Generate an indicator var that is coded 1 for food, 2 for food&tobacco, 
*and 3 for food&accommodation
gen indicator = 1
label var indicator "Type of estimate"
reshape long y_, i(country) j(year)
*drop if y_==.
save "$data\Food.dta", replace

*Food & Tobacco
clear
import excel "$data\Farm share.xlsx", sheet("Food and Tobacco") firstrow
drop M
gen indicator = 2
label var indicator "Type of estimate"
reshape long y_, i(country) j(year)
*drop if y==.
save "$data\Food and Tobacco.dta", replace

*Food & Accommodation
clear
import excel "$data\Farm share.xlsx", sheet("Foodservice and Accommodation") firstrow
drop M-Z
*drop if country==””
gen indicator = 3
label var indicator "Type of estimate"
drop if y_2005 ==. & y_2006 ==. & y_2007 ==. & y_2008 ==. & y_2009==. & y_2010 == . ///
& y_2011 ==. & y_2012 ==. & y_2013 == . & y_2014 ==. & y_2015 ==.
reshape long y_, i(country) j(year)
save "$data\Foodservice and accommodation.dta", replace


*Merge farm share data sets
********************************************************************************
use "$data\Food.dta", clear
append using "$data\Food and Tobacco.dta" 
append using "$data\Foodservice and accommodation.dta"

tab indicator
label define indicator_label 1 "food" 2"food_tobacco" 3 "foodservice_accommodation" 4"food_tob_acc"
label values indicator indicator_label
tab indicator

*tab country and assign ID to each country
sort country
egen id = group(country)

order id country indic
*by country: gen n = _n
*bro country id if n == 1
rename y_ farm_share
label var farm_share "Farm share"
label var year "Year"
save "$data\farmshare.dta", replace


*2
********************************************************************************
*Import World Bank data
*Data downloaded from https://data.worldbank.org/
********************************************************************************
*Population
clear 
import excel "$data\Population.xls", sheet("Population") firstrow
reshape long y_, i(CountryName) j(year)
label var y_ "Population, total"
rename y_ population
drop IndicatorName
drop CountryCode
drop IndicatorCode
label var year "Year"
save "$data\Population.dta", replace

*Urbanization
clear 
import excel "$data\Urbanization.xls", sheet("Urbanization") firstrow
reshape long y_, i(CountryName) j(year)
label var y_ "Urbanization (% of total population)"
rename y_ urbanization
drop IndicatorName
drop CountryCode
drop IndicatorCode
label var year "Year"
save "$data\Urbanization.dta", replace

*GDP per capita (PPP) (constant 2011)
clear
import excel "$data\GDP per capita (PPP).xls", sheet("GDP pc ppp") firstrow
reshape long y_, i(CountryName) j(year)
label var y_ "GDP per capita (PPP)"
rename y_ gdp_pc_ppp
drop IndicatorName
drop CountryCode
drop IndicatorCode
label var year "Year"
save "$data\GDP per capita (PPP).dta", replace

*Access to electricity (% of population)
clear 
import excel "$data\Access to electricity.xls", sheet("Electricity") firstrow
reshape long y_, i(CountryName) j(year)
label var y_ "Access to electricity (% of population)"
rename y_ electricity
drop IndicatorName
drop CountryCode
drop IndicatorCode
label var year "Year"
save "$data\Access to electricity.dta", replace


*Merge all WB data sets
use "$data\Population.dta", clear
merge 1:1 CountryName year using "$data\Urbanization.dta"
drop _merge
merge 1:1 CountryName year using "$data\GDP per capita (PPP).dta"
drop _merge
merge 1:1 CountryName year using "$data\Access to electricity.dta"
drop _merge
label var year "Year"


*Generate id that is equivalent to farmshare country ids 

rename CountryName country
gen id = .

replace id =	1	if country	==	"Argentina"
replace id =	2	if country	==	"Australia"
replace id =	3	if country	==	"Austria"
replace id =	4	if country	==	"Belgium"
replace id =	5	if country	==	"Brazil"
replace id =	6	if country	==	"Brunei Darussalam"
replace id =	7	if country	==	"Bulgaria"
replace id =	8	if country	==	"Cambodia"
replace id =	9	if country	==	"Canada"
replace id =	10	if country	==	"Chile"
replace id =	11	if country	==	"China" //"China (People's Republic of)"
replace id =	12	if country	==	"Chinese Taipei" //Note - no obs on Chinese Taipei
replace id =	13	if country	==	"Colombia"
replace id =	14	if country	==	"Costa Rica"
replace id =	15	if country	==	"Croatia"
replace id =	16	if country	==	"Cyprus"
replace id =	17	if country	==	"Czech Republic"
replace id =	18	if country	==	"Denmark"
replace id =	19	if country	==	"Estonia"
replace id =	20	if country	==	"Finland"
replace id =	21	if country	==	"France"
replace id =	22	if country	==	"Germany"
replace id =	23	if country	==	"Greece"
replace id =	24	if country	==	"Hong Kong SAR, China" //"Hong Kong, China"
replace id =	25	if country	==	"Hungary"
replace id =	26	if country	==	"Iceland"
replace id =	27	if country	==	"India"
replace id =	28	if country	==	"Indonesia"
replace id =	29	if country	==	"Ireland"
replace id =	30	if country	==	"Israel"
replace id =	31	if country	==	"Italy"
replace id =	32	if country	==	"Japan"
replace id =	33	if country	==	"Kazakhstan"
replace id =	34	if country	==	"Korea, Rep."
replace id =	35	if country	==	"Latvia"
replace id =	36	if country	==	"Lithuania"
replace id =	37	if country	==	"Luxembourg"
replace id =	38	if country	==	"Malaysia"
replace id =	39	if country	==	"Malta"
replace id =	40	if country	==	"Mexico"
replace id =	41	if country	==	"Morocco"
replace id =	42	if country	==	"Netherlands"
replace id =	43	if country	==	"New Zealand"
replace id =	44	if country	==	"Norway"
replace id =	45	if country	==	"Peru"
replace id =	46	if country	==	"Philippines"
replace id =	47	if country	==	"Poland"
replace id =	48	if country	==	"Portugal"
replace id =	49	if country	==	"Romania"
replace id =	50	if country	==	"Russian Federation"
replace id =	51	if country	==	"Saudi Arabia"
replace id =	52	if country	==	"Singapore"
replace id =	53	if country	==	"Slovak Republic"
replace id =	54	if country	==	"Slovenia"
replace id =	55	if country	==	"South Africa"
replace id =	56	if country	==	"Spain"
replace id =	57	if country	==	"Sweden"
replace id =	58	if country	==	"Switzerland"
replace id =	59	if country	==	"Thailand"
replace id =	60	if country	==	"Tunisia"
replace id =	61	if country	==	"Turkey"
replace id =	62	if country	==	"United Kingdom"
replace id =	63	if country	==	"United States"
replace id =	64	if country	==	"Vietnam" // "Viet Nam"
tab id
drop if id ==.
sum id

save "$data\WB data.dta", replace


*3
********************************************************************************
*Import FAO stat data
*Data downloaded from http://www.fao.org/faostat/en/#home
********************************************************************************

*Gross Production Value (constant 2004-2006 million US$)
clear 
import excel "$data\Value ag production.xls", sheet("fao_value-ag-production") firstrow

label var Value "Gross Production Value (constant 2004-2006 million US$)"
rename Value gross_production_value
rename Area country
rename Year year

drop AreaCode
drop ElementCode
drop Element
drop ItemCode
drop Item
drop YearCode
drop Unit
drop Flag
drop FlagDescription
label var year "Year"
label var gross_production_value "Gross Production Value (constant 2004-2006 million US$)"
save "$data\Gross Production Value).dta", replace

 *Agriculture Land (1000 ha): Item Code 6610: Agricultural Land: Land used for cultivation of crops and animal husbandry. The total of areas under ''Cropland'' and ''Permanent meadows and pastures.''. 

clear 
import excel "$data\agriculture_land_total.xls", sheet("agriculture_land_total") firstrow

label var Value "Agriculture Land (1000 ha)"
rename Value agriculture_land_total
rename Area country
rename Year year

drop AreaCode
drop ElementCode
drop Element
drop ItemCode
drop Item
drop YearCode
drop Unit
drop DomainCode
drop Domain

label var year "Year"
label var agriculture_land_total "Agriculture Land (1000 ha))"
save "$data\Agriculture land total.dta", replace



*Agriculture value added per worker (constant 2005 US$) 
clear
import excel "$data\Ag employment.xls", sheet("fao_agemployment") firstrow
label var Value "Agriculture value added per worker (constant 2005 US$)"
rename Value ag_employment
rename Area country
rename Year year
drop DomainCode
drop Domain
drop IndicatorCode
drop AreaCode
drop Indicator
drop SourceCode
drop FAOSource
drop YearCode
drop Unit
drop Flag
drop FlagDescription
drop Note

label var year "Year"
label var ag_employment "Agriculture value added per worker (constant 2005 US$)"
save "$data\Agriculture value added per worker.dta", replace

*Merge all FAO Stat data sets
use  "$data\Gross Production Value).dta", clear
merge 1:1 country year using "$data\Agriculture value added per worker.dta"
drop _merge
merge 1:1 country year using "$data\Agriculture land total.dta"
drop _merge
label var year "Year"


*Generate id that is equivalent to farmshare country ids
*Rename CountryName as country
gen id = .
replace id =	1	if country	==	"Argentina"
replace id =	2	if country	==	"Australia"
replace id =	3	if country	==	"Austria"
replace id =	4	if country	==	"Belgium"
replace id =	5	if country	==	"Brazil"
replace id =	6	if country	==	"Brunei Darussalam"
replace id =	7	if country	==	"Bulgaria"
replace id =	8	if country	==	"Cambodia"
replace id =	9	if country	==	"Canada"
replace id =	10	if country	==	"Chile"
replace id =	11	if country	==	"China" //"China (People's Republic of //
*Note - Distinction made between China and China, mainland
replace id =	12	if country	==	"Chinese Taipei" //Not in data set
replace id =	13	if country	==	"Colombia"
replace id =	14	if country	==	"Costa Rica"
replace id =	15	if country	==	"Croatia"
replace id =	16	if country	==	"Cyprus"
replace id =	17	if country	==	"Czechia" //"Czech Republic"
*Czech Republic - No obs for ag employment value
replace id =	18	if country	==	"Denmark"
replace id =	19	if country	==	"Estonia"
replace id =	20	if country	==	"Finland"
replace id =	21	if country	==	"France"
replace id =	22	if country	==	"Germany"
replace id =	23	if country	==	"Greece"
replace id =	24	if country	==	"China, Hong Kong SAR" //"Hong Kong, China"
replace id =	25	if country	==	"Hungary"
replace id =	26	if country	==	"Iceland"
replace id =	27	if country	==	"India"
replace id =	28	if country	==	"Indonesia"
replace id =	29	if country	==	"Ireland"
replace id =	30	if country	==	"Israel"
replace id =	31	if country	==	"Italy"
replace id =	32	if country	==	"Japan"
replace id =	33	if country	==	"Kazakhstan"
replace id =	34	if country	==	"Republic of Korea" //"Korea, Rep."
replace id =	35	if country	==	"Latvia"
replace id =	36	if country	==	"Lithuania"
replace id =	37	if country	==	"Luxembourg"
replace id =	38	if country	==	"Malaysia"
replace id =	39	if country	==	"Malta"
replace id =	40	if country	==	"Mexico"
replace id =	41	if country	==	"Morocco"
replace id =	42	if country	==	"Netherlands"
replace id =	43	if country	==	"New Zealand"
replace id =	44	if country	==	"Norway"
replace id =	45	if country	==	"Peru"
replace id =	46	if country	==	"Philippines"
replace id =	47	if country	==	"Poland"
replace id =	48	if country	==	"Portugal"
replace id =	49	if country	==	"Romania"
replace id =	50	if country	==	"Russian Federation"
replace id =	51	if country	==	"Saudi Arabia"
replace id =	52	if country	==	"Singapore"
replace id =	53	if country	==	"Slovakia" //Slovak Republic"
replace id =	54	if country	==	"Slovenia"
replace id =	55	if country	==	"South Africa"
replace id =	56	if country	==	"Spain"
replace id =	57	if country	==	"Sweden"
replace id =	58	if country	==	"Switzerland"
replace id =	59	if country	==	"Thailand"
replace id =	60	if country	==	"Tunisia"
replace id =	61	if country	==	"Turkey"
replace id =	62	if country	==	"United Kingdom"
replace id =	63	if country	==	"United States of America" //"United States"
replace id =	64	if country	==	"Viet Nam"
tab id
drop if id ==.
sum id

save "$data\FAO data.dta", replace


*4
********************************************************************************
*Merge farm share data, World Bank data, and FAO Stat data
********************************************************************************
clear
use "$data\WB data.dta"
merge 1:m id year using "$data\farmshare.dta"
*Browse if _merge < 3
drop _merge
merge m:1 id year using "$data\FAO data.dta"
drop _merge
label var id "Country id"
label var country "Country name"
order id country year farm_share indicator population urbanization electricity gdp_pc_ppp gross_production_value agriculture_land_total ag_employment
keep id country year farm_share indicator population urbanization electricity gdp_pc_ppp gross_production_value agriculture_land_total ag_employment
drop if farm_share == .
tab indicator 

save "$dataOutput\farm share, WB, FAO.dta", replace
