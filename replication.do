cd "C:\Users\tkirm\Desktop\CAnD3_replication"
import delimited "gss-12M0025-E-2017-c-31_F1.csv", clear
save "gss.dta", replace

//*sample*//
keep if agec > = 45

//*population weight* //
svyset [pweight = wght_per]

//*recoding variables of interest* //
recode slm_01 (97/99=.) (0=0 "Very dissatisfied") (10=10 "Very Satisfied"), gen(subj_wellbeing)
recode grndpa (1=1 "Yes") (2=0 "No") (9=.), gen(gparent_status)
recode sex (1=0 "Male") (2=1 "Female") (9=.), gen(gender)
recode ngrdchdc (0=0 "None") (15=15 "15 or more") (97/99=.), gen(n_gchildren)
recode ehg3_01b (1=1 "Less than high school diploma or its equivalent") (2=2 "High school diploma or a high school equivalency certificate") (3=3 "Trade certificate or diploma") (4=4 "College, CEGEP or other non-university certificate") (5=5 "University certificate or diploma below the bachelor's level") (6=6 "Bachelor's degree") (7=7 "University certificate, diploma or degree above Bachelors") (96/99=.), gen(education)
tab agec 
recode famincg2 (1 = 1 "Less than $25,000") (2 = 2 "$25,000 to $49,999") (3 = 3 "$50,000 to $74,999") (4 = 4 "$75,000 to $99,999") (5 = 5 "$100,000 to $124,999") (6 = 6 "$125,000 and more") (96/99=.), gen(income) 

//*labeling variables* //
label variable subj_wellbeing "Subjective Wellbeing"
label variable gparent_status "Grandparent Status"
label variable gender "Gender"
label variable n_gchildren "Number of Grandchildren"
label variable ehg3_01b "Level of Education"
label variable agec "Age"
label variable income "Level of Income"


//*descriptive tables* //
asdoc tabulate gender gparent_status, row percent nofreq replace
asdoc tabulate  education gparent_status, row percent nofreq append
asdoc tabulate  income gparent_status, row percent nofreq append 

asdoc tabstat subj_wellbeing n_gchildren agec, stat(mean sd min max) by(gparent_status) nototal long col(stat) ///
    title(Summary Stats of Variables by Grandparent Status) ///
    append


//*regression models* //
eststo m1: reg subj_wellbeing gparent_status gender n_gchildren education agec income 

//*regression table* //
	esttab m1 using "results_table.rtf", replace ///
    b(%9.2f) se(%9.2f) eform star(* 0.10 ** 0.05 *** 0.01) ///
    title("Regression Model for Subjective Wellbeing") ///
    scalars(N) label ///
    varlabels( ///
        subj_wellbeing "Subjective Wellbeing" ///
        gparent_status "Grandparent Status" ///
        gender "Gender" ///
        n_gchildren "Number of Grandchildren" ///
        ehg3_01b "Level of Education" ///
        agec "Age" ///
        income "Level of Income" ///
    ) 
	
	