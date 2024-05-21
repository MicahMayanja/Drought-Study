#Stata Dofile 
clear 
cd "C:\Users\....\Drought data study"

import excel "C:\Users\...\Drought data study\Predictors_Copying to droughts new.xls",sheet("Sheet1") firstrow


browse 
destring, replace 

recode Numberofanimalsdied (0/5=0) (6/22=1), gen(numdied)
tab numdied

recode Numberofanimalssold (0/10=0) (11/52=1), gen(numsold)
tab numsold 

encode Agriculture_name, gen(Agriculture)
drop Agriculture_name
rename Agriculture Agriculture_name

encode Gender, gen(gender)
drop Gender
rename gender Gender

encode Marital_status, gen(marital)
drop Marital_status
rename marital Marital_status

encode Educationlevel, gen(education)
drop Educationlevel
rename education Educationlevel

encode Farmingenterprise, gen(farming)
drop Farmingenterprise
rename farming Farmingenterprise

encode Droughtawareness, gen(droughtaware)
drop Droughtawareness
rename droughtaware Droughtawareness

encode Whatyoudidtoprepare, gen(whatyoudid)
drop Whatyoudidtoprepare
rename whatyoudid Whatyoudidtoprepare

encode Watersource, gen(watersource)
drop Watersource
rename watersource Watersource

encode Supplementaryfeedbefore, gen(suppbefore)
drop Supplementaryfeedbefore
rename suppbefore Supplementaryfeedbefore

encode Supplementaryfeedduring, gen(suppduring)
drop Supplementaryfeedduring
rename suppduring Supplementaryfeedduring

encode Livestockmanagementchange, gen(livestock)
drop Livestockmanagementchange
rename livestock Livestockmanagementchange

encode Accesstocleanwater, gen(accesswater)
drop Accesstocleanwater
rename accesswater Accesstocleanwater

encode Rateaccesstocleanwater, gen(rate)
drop Rateaccesstocleanwater
rename rate Rateaccesstocleanwater

encode Supportfromanyinstitution, gen(support)
drop Supportfromanyinstitution
rename support Supportfromanyinstitution

encode Informationsource, gen(Info)
drop Informationsource
rename Info Informationsource

encode Droughtpreparedness, gen(droughtprepare)
drop Droughtpreparedness
rename droughtprepare Droughtpreparedness

encode Foodsufficient, gen(foodsufficient)
drop Foodsufficient
rename foodsufficient Foodsufficient

lab def Binary 1 "Yes" 0 "No"
lab val Binary Binary

**AGE
hist Age, norm 
pnorm Age 
swilk Age /*not normal*/

**Years farming 
hist Yearsinfarming, norm /*not normal*/

**DESCRIPTIVE STATS
/*Categorical */
tab1 Agriculture_name Marital_status Gender Educationlevel Farmingenterprise Droughtawareness Informationsource Droughtpreparedness Whatyoudidtoprepare Watersource Supplementaryfeedbefore Supplementaryfeedduring Livestockmanagementchange Accesstocleanwater Rateaccesstocleanwater Foodsufficient Supportfromanyinstitution Foodsufficient

tabstat Yearsinfarming if AbletoCopewithdrought == "No", statistics (n mean p25 p50 p75) 

tabstat Age if AbletoCopewithdrought == "No", statistics (n mean p25 p50 p75) 

**ASSOCIATION TESTS
tab numsold AbletoCopewithdrought, row expect  chi2
tab numdied AbletoCopewithdrought, row expect chi2
tab Agriculture_name AbletoCopewithdrought, row expect chi2
tab Marital_status AbletoCopewithdrought, row expect chi2
tab Gender AbletoCopewithdrought, row expect chi2
tab Educationlevel AbletoCopewithdrought, row expect chi2 
tab Farmingenterprise AbletoCopewithdrought, row expect chi2 
tab Droughtawareness AbletoCopewithdrought, row expect chi2
tab Informationsource AbletoCopewithdrought, row expect chi2 
tab Droughtpreparedness AbletoCopewithdrought, row expect chi2 
tab Whatyoudidtoprepare AbletoCopewithdrought, row expect chi2 
tab Watersource AbletoCopewithdrought, row expect chi2 
tab Supplementaryfeedbefore AbletoCopewithdrought, row expect chi2 
tab Supplementaryfeedduring AbletoCopewithdrought, row expect chi2 
tab Livestockmanagementchange AbletoCopewithdrought, row expect chi2 
tab Accesstocleanwater AbletoCopewithdrought, row expect chi2 
tab Rateaccesstocleanwater AbletoCopewithdrought, row expect chi2 
tab Foodsufficient AbletoCopewithdrought, row expect chi2 
tab Supportfromanyinstitution AbletoCopewithdrought, row expect chi2 

ranksum(Age), by(AbletoCopewithdrought)
ranksum(Yearsinfarming), by(AbletoCopewithdrought)

/**Logistic regression*/
set showbaselevels all 
logit Binary i.Agriculture_name i.Educationlevel i.Farmingenterprise i.Droughtawareness i.Whatyoudidtoprepare i.Watersource i.Supplementaryfeedbefore i.Supplementaryfeedduring i.Livestockmanagementchange i.Accesstocleanwater i.Rateaccesstocleanwater i.Supportfromanyinstitution i.Informationsource i.Droughtpreparedness i.Foodsufficient, or 

est stor A 

testparm i.Agriculture_name
testparm i.Educationlevel
testparm i.Farmingenterprise /*nope*/
testparm i.Whatyoudidtoprepare
testparm i.Watersource /*nope*/
testparm i.Livestockmanagementchange
testparm i.Accesstocleanwater /*nope*/
testparm i.Rateaccesstocleanwater
testparm i.Supportfromanyinstitution /*nope*/
testparm i.Informationsource /*nope*/
testparm i.Droughtpreparedness /*nope*/
testparm i.Foodsufficient /*nope*/

logit Binary i.Agriculture_name i.Educationlevel i.Droughtawareness i.Whatyoudidtoprepare i.Supplementaryfeedbefore i.Supplementaryfeedduring i.Livestockmanagementchange i.Rateaccesstocleanwater, or 

est stor B 

lrtest A B 

testparm i.Agriculture_name
testparm i.Educationlevel /*marginally sig*/
testparm i.Droughtawareness /*nope*/
testparm i.Whatyoudidtoprepare
testparm i.Livestockmanagementchange

logit Binary i.Agriculture_name ib2.Educationlevel ib2.Whatyoudidtoprepare i.Supplementaryfeedbefore i.Supplementaryfeedduring i.Livestockmanagementchange i.Rateaccesstocleanwater, or 

est stor C 

testparm i.Agriculture_name
testparm ib2.Educationlevel
testparm i.Livestockmanagementchange
testparm i.Whatyoudidtoprepare
testparm i.Rateaccesstocleanwater

lrtest B C 

estat gof
lroc 

margins i.Agriculture_name
marginsplot, saving(Agriculture)

margins i.Educationlevel
marginsplot, saving(Education)

margins i.Whatyoudidtoprepare
marginsplot, saving(Prepare)

margins i.Supplementaryfeedbefore
marginsplot, saving(before)

margins i.Supplementaryfeedduring
marginsplot, saving(during)

margins i.Livestockmanagementchange
marginsplot, saving(livestock)

margins i.Rateaccesstocleanwater
marginsplot, saving(rate)

graph combine Agriculture.gph Education.gph Prepare.gph before.gph during.gph  rate.gph livestock.gph


