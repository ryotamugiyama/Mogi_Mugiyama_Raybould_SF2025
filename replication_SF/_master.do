clear all
set more off
macro drop _all

global exportdir "results"
global latestwave "17"
global secondlatestwave "16"
global firstwave "8"
global surveyflag "z a b c d e f g h i j k l m n o p"
global surveyflag2 "a b c d e f g h i j k l m n o p"


/**********************************************************************/
/*  SECTION 0: Macro data              
    Notes: */
/**********************************************************************/
do "replication_SF/0_macrodata/JLPS_cpi.do"


/**********************************************************************/
/*  SECTION 1: expand Data              
    Notes: */
/**********************************************************************/
use "Data/JLPSw1_17.dta", clear
rename *, lower

do "replication_SF/1_expandData/expandData.do"

xtset id wave

/**********************************************************************/
/*  SECTION 2: generate vars              
    Notes: */
/**********************************************************************/

*** Gender
    do "replication_SF/2_generateVars/gender.do"

*** Block, prefecture, city size
    do "replication_SF/2_generateVars/blockprefsize.do"

*** Age
    do "replication_SF/2_generateVars/age.do"

*** Year
    do "replication_SF/2_generateVars/year.do"

*** Cohort
    do "replication_SF/2_generateVars/cohort.do"

*** Educational background
    do "replication_SF/2_generateVars/educ.do"

*** Work
    do "replication_SF/2_generateVars/work.do"

*** Student
    do "replication_SF/2_generateVars/student.do"

*** Revival sample
    do "replication_SF/2_generateVars/revival.do"

*** Marital status
    do "replication_SF/2_generateVars/marstat.do"

*** Dating
    do "replication_SF/2_generateVars/dating.do"

*** Cohabitation with their romantic partner
    do "replication_SF/2_generateVars/cohabitation.do"

*** Number of children, etc.
    do "replication_SF/2_generateVars/havechild.do"

*** Income
    do "replication_SF/2_generateVars/income.do"
    do "replication_SF/2_generateVars/income_replace.do"

*** Employment status
    do "replication_SF/2_generateVars/status.do"

*** Age at entry
    do "replication_SF/2_generateVars/ageentry.do"

*** Fertility intention
    do "replication_SF/2_generateVars/fertilitydesire.do"

*** partnership (marital status + non-coresidential relationship + cohabitation among those without children)
    do "replication_SF/2_generateVars/partnership.do"

*** partnership, separating past experience
    do "replication_SF/2_generateVars/partnership_history.do"

*** duration of not having a partner and noncoresidential partner
    do "replication_SF/2_generateVars/nopartner_duration.do"

*** interaction variable
    do "replication_SF/2_generateVars/interactionvars.do"

foreach x in $surveyflag{
    drop `x'q*
}
    save "data/NFI_dataVariable.dta", replace

/**********************************************************************/
/*  SECTION 3: sample limitation              
    Notes: */
/**********************************************************************/

*** Sample limitation
    do "replication_SF/3_sampleLimitation/sampleLimitation.do"


/**********************************************************************/
/*  SECTION 4: analysis              
    Notes: */
/**********************************************************************/

*** Table 1 Descriptive statistics
*** Table A1. Descriptive statistics by gender and partnership status
    do "replication_SF/4_analysis/descriptives.do"

*** Table A2 Within-variation
*   R: "replication_SF/4_analysis/tableA2_within_variation.R"

*** Fig1, 2, A2, and A3. Tabulation
*** Fig 1. fertility desire and partnership status by gender
*** Fig 2. fertility desire and non-partnership duration
*** Fig A2. fertility desire by age and gender
*** Fig A3. partnership status by age and gender
*   R: "replication_SF/4_analysis/Fig1_2_A1_A2_tabulations.R"

*** Footnote for "want a boy" and "want a girl" proportions.
    do "replication_SF/4_analysis/footnote.do"

*** Main regression results
*** Table 2/A3: Fixed effects model
*** Table A4: Alternative measurement of duration of non-partnership
*** Table A5: Continuous models
*** Table A6: Separating partnership duration
*** Table A9: Separating sex preference
*** Table A10: Experience of partnership
    do "replication_SF/4_analysis/fixedeffect.do"

*** Table A7: Interaction with age
*** Table A8: Interaction with education
    do "replication_SF/4_analysis/fixedeffect_interaction.do"

*** Table A11: Hybrid model
    do "replication_SF/4_analysis/hybrid.do"

*** Table A12: Continuous model
    do "replication_SF/4_analysis/fixedeffect_continuous.do"

