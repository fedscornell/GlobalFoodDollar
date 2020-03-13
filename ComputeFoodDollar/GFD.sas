/***************************************************************************************************/ 
/* This script is developed for the global food dollar project: https://fedscornell.github.io/GlobalFoodDollar/ */
/* More descriptions are available at: https://fedscornell.github.io/GlobalFoodDollar/ComputeFoodDollar/ */

/* The sqlGFD library is available at: https://github.com/FEDSCornell/GlobalFoodDollar/raw/master/ComputeFoodDollar/sqlGFD.zip */

/*1. Please uncompress the downloaded data library to have the sqlGFD library in your directory. */
/*2. Edit 'YourDirectory' to specify the directory of this sqlGFD library */

/***************************************************************************************************/

libname sqlGFD 'YourDirectory';

/*Read in the entire OECD IOT dataset, including the Z, Y, V, and m
  matricies, plus the set definitions, I, F, and S, for all C-Y pairs*/


/*Add export assembly and fah industries*/
/*This done here since the 'cards' command is problematic inside of
  an 'include' statement*/

/*Read in 36x36 transaction matrix, 3x36 value added matrix,
  36x1 final demand vector and 1x36 import vector*/

/*Add export assembly and fah industries*/
/*This done here since the 'cards' command is problematic inside of
  an 'include' statement*/

data Z_;set sqlGFD.GFD_SAS_InputData;
WHERE (SUBSTR(COL,1,1)='Z' AND SUBSTR(ROW,1,1)='Z');
proc sort;by COUNTRY YEAR ROW COL;
run;

data Zind; set Z_;
where (COL='Z84' AND COUNTRY='Chile' AND YEAR=2005);
keep ROW;
run;

data Z_;set Z_;
drop ROW COL;
run;

data V_;set sqlGFD.GFD_SAS_InputData;
WHERE (SUBSTR(COL,1,1)='Z' AND SUBSTR(ROW,1,1)='V');
proc sort;by COUNTRY YEAR ROW COL;
run;

data Vind; set V_;
where (COL='Z84' AND COUNTRY='Chile' AND YEAR=2005);
keep ROW;
run;

data V_;set V_;
drop ROW COL;
run;

data Y_;set sqlGFD.GFD_SAS_InputData;
WHERE (SUBSTR(COL,1,1)='Y' AND SUBSTR(ROW,1,1)='Z' AND COL<>'YIMP');
proc sort;by COUNTRY YEAR ROW COL;
run;

data Yind; set Y_;
where (ROW='Z84' AND COUNTRY='Chile' AND YEAR=2005);
keep COL;
run;

data Y_;set Y_;
drop ROW COL;
run;

data M_;set sqlGFD.GFD_SAS_InputData;
WHERE (SUBSTR(ROW,1,1)='Z' AND COL='YIMP');
proc sort;by ROW;
run;

data M_;set M_;
drop ROW COL;
run;

data Zind2;
	input row $15.;
	cards;
	ZEXP
	Z55t56f
	;
run;

/*Compile the Industry set for the GFD model*/
data Z2ind; set Zind Zind2;
run;


/*Food at Home PCE*/
data YFAH_;set sqlGFD.GFD_FAH_DOLLAR_INTERMEDIATEnew;
proc sort;by COUNTRY YEAR  ROW;
run;

data YFAH_;set YFAH_;
drop ROW;
run;

/*Food and Tobacco at Home PCE*/
data YFTAH_;set sqlGFD.GFD_FnTAH_DOLLAR_INTERMEDIATE;
proc sort;by COUNTRY YEAR  ROW;
run;

data YFTAH_;set YFTAH_;
drop ROW;
run;

/*Note that YFAAFH is embedded in the IOT Y matrix loaded above*/

/*Get a master list of countries from the IOT*/

data COU;set sqlGFD.GFD_SAS_InputData (KEEP=COUNTRY);
proc sort NODUPKEY;by country;
run;
/*Get a master list of years from the IOT*/
data YRS;set sqlGFD.GFD_SAS_InputData  (KEEP=YEAR);
proc sort NODUPKEY;by year;
run;

proc iml;

/*******************************************************************/
/*  Read in all input data from SQLServer                          */
/*******************************************************************/

/*Matrix and submatrix dimensions and addresses*/

use Vind;
read all var _all_ into Vrows;
otx = {'VOTXSplus'};
find point(1 : nrow(Vrows)) where (row = otx) into otx_row;

use Yind;
read all var _all_ into Ycols;
exp = {'YEXP'};
pce = {'YPCE'};
gov = {'YGOV'};
find point(1 : nrow(Ycols)) where (COL = exp) into EX_COL;
find point(1 : nrow(Ycols)) where (COL ^= exp) into CIG_COL;
find point(1 : nrow(Ycols)) where (COL = pce) into PCE_COL;
find point(1 : nrow(Ycols)) where (COL = gov) into gov_col;

use Zind;
read all var _all_ into Zrows;

use COU;
read all var _all_ into COUNTRIES;

USE YRS;
read all var _all_ into YEARS;

DO KK = 1 TO NROW(COUNTRIES);
    CO = COUNTRIES[KK];
    DO LL = 1 TO NROW(YEARS);
    	YR = YEARS[LL];

		/*Begin with food pce and ftah pce in case no data so you 
		  can skip ahead*/
		use YFAH_;
		read all var {vfob} into YFAH where (YEAR = YR & COUNTRY= CO);
		if nrow(YFAH)>0 then do;

			read all var {trade} into YFAH_trd where 
(YEAR = YR & COUNTRY= CO);

			read all var {tran} into YFAH_trn where 
(YEAR = YR & COUNTRY= CO);
		end;

		use YFTAH_;
		read all var {vfob} into YFTAH where (YEAR = YR & COUNTRY= CO);
		if nrow(YFTAH)>0 then do;

			read all var {trade} into YFTAH_trd where 
(YEAR = YR & COUNTRY= CO);

			read all var {tran} into YFTAH_trn where 
(YEAR = YR & COUNTRY= CO);
		end;

		/* endogenous transactions */

		use Z_;
		read all var _ALL_ into Z where (YEAR = YR & COUNTRY= CO);

		/*NOTE, VARIABLE VFOB_$MIL HAS SPECIAL CHARACTER SO CAN'T BE
		  REFERENCED, SO MUST READ IN _ALL_ VARIABLES. BUT COUNTRY
		  IS A CHARACTER VARIABLE SO IS NOT READ. SO DATA COLUMN IS
		  THE SECOND COLUMN. SAME HOLDS FOR Y, V, AND M*/
 
		Z = Z[,2];
		Z = shape(Z,nrow(Zrows),nrow(Zrows));

		/*final demand (GDP less imports)*/
		use Y_;
		read all var _ALL_ into Y where (YEAR = YR & COUNTRY= CO);
		Y = Y[,2];
		Y = shape(Y,nrow(Zrows),nrow(Ycols));

		/*exogenous GDI plus imports*/
		use V_;
		read all var _ALL_ into V where (YEAR = YR & COUNTRY= CO);
		V = V[,2];
		V = shape(V,nrow(Vrows),nrow(Zrows));

		use M_;
		read all var _ALL_ into M where (YEAR = YR & COUNTRY= CO);
		M = M[,2];
		YM = Y||M;

		/*Create Leontief and sub-matricies*/
		X = t(Z[+,] + V[+,]);/*GROSS DOMESTIC OUTPUT*/
		/*To address potential singular matrix problems, create a vector
		  X0 that has a 1 in the position where an industry has no gross
		  output. This will be added to output taxes and Ygov to avoid
		  singularity--e.g., gov gives and takes away to non existent
  industry*/
		X0 = (X=0); 
		/*add a unit of currency in output tax*/
		V[otx_row,] = V[otx_row,] + t(X0); 
		/*add a unit of currency in government spending*/
		Y[,gov_col] = Y[,gov_col] + X0; 
		X = t(Z[+,] + V[+,]);/*GROSS DOMESTIC OUTPUT*/
		A = Z*inv(diag(X));/*DIRECT REQUIREMENT MATRIX*/
		L = inv(I(nrow(A))-A);/*TOTAL REQUIREMENT MATRIX*/

		W = V*inv(diag(X));/*EXOGENOUS VALUE ADDED (plus IMPORTS) MULTIPLIER*/

		/*CREATE A NEW EXPORT ASSEMBLY INDUSTRY THAT ENSURES IMPORTS ARE NOT RE-
		  EXPORTED AND SEPARATE FOOD FROM THE ACCOMODATION AND FOODSERVICE INDUSTRY */

		Z2 = Z - A*DIAG(Y[,EX_COL])||(A*DIAG(Y[,EX_COL]))[,+];
		Z2 = Z2//(0*Z2[1,]);

		V2 = V - W*DIAG(Y[,EX_COL])||(W*DIAG(Y[,EX_COL]))[,+];

		/*YEXP is 1st alphabetical column in the Y matrix*/
		Y2 = (0*Y[,EX_COL]//Y[+,EX_COL])||(Y[,CIG_COL]//0*Y[1,CIG_COL]);

		/*YFAH*/
		if nrow(YFAH)>0 then do;
			Y2FAH = YFAH//0;
			Y2FAH_trd = YFAH_trd // 0;
			Y2FAH_trn = YFAH_trn // 0;
		end;

		/*YFTAH*/
		if nrow(YFTAH)>0 then do;
			Y2FTAH = YFTAH//0;
			Y2FTAH_trd = YFTAH_trd // 0;
			Y2FTAH_trn = YFTAH_trn // 0;
		end;

		/*Insert placeholders for the new food for 
  foodservice column and row*/
		Z2 = Z2||(0*Z2[,1]);
		Z2 = Z2//(0*Z2[1,]);

		V2 = V2||(0*V2[,1]);

		VM2= V2 // -t(M//0//0);

		Y2 = Y2//(0*Y2[1,]);

		/*YFAH*/
		if nrow(YFAH)>0 then do;
			Y2FAH = Y2FAH // 0;
			Y2FAH_trd = Y2FAH_trd // 0;
			Y2FAH_trn = Y2FAH_trn // 0;
		end;

		/*YFTAH*/
		if nrow(YFTAH)>0 then do;
			Y2FTAH = Y2FTAH // 0;
			Y2FTAH_trd = Y2FTAH_trd // 0;
			Y2FTAH_trn = Y2FTAH_trn // 0;
		end;

		/*SPLIT AFS TO CREATE THE NEW AFS_FOOD INDUSTRY*/

		/*Locate sections of the new accounts*/

		use Z2ind;
		read all var _all_ into Z2rows;
		ag  = {'Z01T03'};
		trd = {'Z45T47'};
		trn = {'Z49T53'};
		Afs = {'Z55T56'};
		Afsf ={'Z55t56f'};
		food = {'Z01T03','Z10T12'};
		find point(1 : nrow(Z2rows)) where (row = ag) into Ag_rows;
		find point(1 : nrow(Z2rows)) where (row ^= ag) into nonAg_rows;
		find point(1 : nrow(Z2rows)) where (row = trd) into trd_rows;
		find point(1 : nrow(Z2rows)) where (row = trn) into trn_rows;
		find point(1 : nrow(Z2rows)) where (row = Afs) into afs_rows;
		find point(1 : nrow(Z2rows)) where (row = Afsf) into afsf_rows;
		find point(1 : nrow(Z2rows)) where (row = food) into food_rows;

		Z2[food_rows,afsf_rows] = Z2[food_rows,afs_rows];
		Z2[food_rows,afs_rows] = 0;
		X2 = t(Z2[+,]+VM2[+,]);

		/*compute share of old AFS industry output
  representing food purchases*/
		shr1 = X2[afsf_rows]/(X2[afsf_rows]+X2[afs_rows]);
		shr2 = 1-shr1;

		/*Split intermediate and final outlays on the old
  Afs between new AFS and AFSf*/
		Z2[afsf_rows,] = shr1*Z2[afs_rows,];
		Z2[afs_rows,] = shr2*Z2[afs_rows,];
		Y2[afsf_rows,] = shr1*Y2[afs_rows,];
		Y2[afs_rows,] = shr2*Y2[afs_rows,];

		/*Compile and test new model*/
		A2 = Z2*inv(diag(X2));/*DIRECT REQUIREMENT MATRIX*/
		L2 = inv(I(nrow(A2))-A2);/*TOTAL REQUIREMENT MATRIX*/

		s_d = inv(diag(X2))*(X2-t(VM2[4,]));

		/*Margin costs are only for domestic production 
		  so do not deduct imports from these costs*/
		s_d[trd_rows] = 1; /*100 percent domestic services*/
		s_d[trn_rows] = 1; /*100 percent domestic services*/

		/*FAAFH*/

		/*
		FOODSERVICE AND ACCOMODATIONS AWAY FROM HOME ARE PULLED
		FROM THE FOOD-AWAY AND THE FOOD & ACCOMODATION SERVICES
		ROWS OF THE PCE COLUMN OF THE FINAL DEMAND MATRIX (Y2)
		*/

		YFAAFH = Y2[,PCE_COL];
		YFAAFH = 0*Y2[,PCE_COL];
		YFAAFH[afs_rows] = Y2[afs_rows,PCE_COL];
		YFAAFH[afsf_rows] = Y2[afsf_rows,PCE_COL];

		/*THERE ARE NO ADDITIONAL MARGIN COSTS ADDED TO FAAFH*/

		
/*Total ag requirement of import inclusive food & 
		  accommodations away from home dollars*/ 
		x_faafh = L2[Ag_rows,] * YFAAFH;

		x_faafhNet  = x_faafh 
				- (A2[Ag_rows,Ag_rows] 
				+ A2[Ag_rows,nonAg_rows]
* L2[nonAg_rows,nonAg_rows]
				* A2[nonAg_rows,Ag_rows])
				* x_faafh;
		/*
		Farm share is measured as the domestic portion
		of gross farm output, net of farm-to-farm direct
		and indirect sales divided by the domestic portion
		of total food & accommodation expenditures at 
		purchaser prices
		*/

		FSFA = t(s_d[Ag_rows])*x_faafhNet/(t(s_d)*YFAAFH) ||0||0||1;
		print FSFA;

		IF KK+LL>2 THEN DO;
			load FS1 FS2; /*load matrix previously stored*/
		END;
		/*store Accommodation and Food dollar C-Y ID's*/
		FS1=FS1//(CO || char(Yr,4,0)); 
		/*store Accommodation and Food dollar shares*/
		FS2=FS2//FSFA; 
		store FS1 FS2;

		/*FAH*/
		if nrow(YFAH)=0 then goto skip;

		/*COMPUTE DOMESTIC SHARE OF AVAILABILITY BY INDUSTRY*/

		/*Add only margin costs on domestic production to YFAH*/
		Y2FAH[trd_rows] = t(s_d)*Y2FAH_trd;
		Y2FAH[trn_rows] = t(s_d)*Y2FAH_trn;

		/*Total ag requirement of import inclusive 
  food at home dollars*/ 
		x_fah = L2[Ag_rows,] * Y2FAH;

		x_fahNet = x_fah 
				 - (A2[Ag_rows,Ag_rows] +
				 + A2[Ag_rows,nonAg_rows]
 * L2[nonAg_rows,nonAg_rows]
				 * A2[nonAg_rows,Ag_rows])
				 * x_fah;

		/*
		Farm share is measured as the domestic portion
		of gross farm output, net of farm-to-farm direct
		and indirect sales divided by the domestic portion
		of total food & accommodation expenditures at 
		purchaser prices
		*/
		FSFT = t(s_d[Ag_rows])*x_fahNet/(t(s_d)*Y2FAH) || 1 || 0 || 0;
		print FSFT;

		IF  KK+LL>2 THEN DO;
			load FS1 FS2; /*load matrix previously stored*/
		END;
		FS1=FS1//(CO || char(Yr,4,0)); /*store Food dollar C-Y ID's*/
		FS2=FS2//FSFT; /*store Food dollar shares*/
		store FS1 FS2;


		/*FTAH*/
skip:	if nrow(YFTAH)=0 then goto skip2;

		/*COMPUTE DOMESTIC SHARE OF AVAILABILITY BY INDUSTRY*/

		/*Add only margin costs on domestic production to YFTAH*/
		Y2FTAH[trd_rows] = t(s_d)*Y2FTAH_trd;
		Y2FTAH[trn_rows] = t(s_d)*Y2FTAH_trn;

		/*Total ag requirement of import inclusive food
  and tob at home dollars*/ 
		x_ftah = L2[Ag_rows,] * Y2FTAH;

		x_ftahNet = x_ftah 
				 - (A2[Ag_rows,Ag_rows] +
					A2[Ag_rows,nonAg_rows]*L2[nonAg_rows,nonAg_rows]
				 *	A2[nonAg_rows,Ag_rows])
				 *  x_ftah;

		/*
		Farm share is measured as the domestic portion
		of gross farm output, net of farm-to-farm direct
		and indirect sales divided by the domestic portion
		of total food & accommodation expenditures at 
		purchaser prices
		*/

		FSFTT = t(s_d[Ag_rows])*x_ftahNet/(t(s_d)*Y2FTAH) || 0 || 1 || 0;
		print FSFTT;

		IF  KK+LL>2 THEN DO;
			load FS1 FS2; /*load matrix previously stored*/
		END;
		FS1=FS1//(CO || char(Yr,4,0)); /*store Food dollar C-Y ID's*/
		FS2=FS2//FSFTT; /*store ftah dollar shares*/
		store FS1 FS2;

skip2:	END;
END;

MetaCNames = {Country Year};
DataCNames = {Value FAH FTAH AFAFH};

create FSmeta from FS1[colname=MetaCNames];
append from FS1;

create FSdata from FS2[colname=DataCNames];
append from FS2; 

quit;

DATA GFD;
merge FSmeta FSdata;
run;

proc format; 
picture mydtfmt 
  low-high = '%0m_%0d_%Y_%0I%0M%p' (datatype=datetime); 
run; 

proc sql; 
     create table sqlGFD.GFD_RESULTS_%unquote(%sysfunc(datetime(),mydtfmt.)) as 
     select * from GFD; 
quit; 
run;

