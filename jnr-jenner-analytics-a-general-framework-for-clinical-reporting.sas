/*--
c:/utl/jnr-jenner-analytics-a-general-framework-for-clinical-reporting.sas
---*/

Jenner Analytics general framework for clinical reporting

Too long to post, see
https://github.com/rogerjdeangelis/jnr-jenner-analytics-a-general-framework-for-clinical-reporting.sas

PROBLEM:
Reproduce  the R Intent-to-Treat Table
https://tinyurl.com/bdzhvkkp

Jenner Table in PDF Format (Note PDF tables should not be editable? - download for higher reolution?)
  https://tinyurl.com/yeyvubuf
Jenner Table in Word Format (Note PDF tables should not be editable?)
  https://tinyurl.com/5fam2m2m
Jenner Table Printer Format
  https://tinyurl.com/mwk2tysh

Some minor report formatting issues actively being worked on.

A very flexible Jenner format-driven solution

A three-page clinical mock table is mapped irectly into a Jenner format.
This format and associated cntlout configuration table drive almost all the processing

NOTE:  Page identifies the page, and order gives the placement on the page.
       It is easy to change major and minor descriptions.
       It is easy to move within abd between pages.
       This technique can easily be expanded for three or more levels, Major, Level1, and Level2
       for more complex tables.

MOCK TABLE

   Protocol: CDISCPILOT01                                                                  Page1 of 3
   Population: Intent-to-Treat
                                              Table 14-2.01
                       Summary of Demographic and Baseline Characteristics

                                                      Xanomeline  Xanomeline
                                             Placebo    Low Dose    Low Dose     Total  P-Value
                                              (N=XX)      (N=XX)      (N=XX)   (N=XXX)  [X]

      AGE (y)               N                     XX          XX          XX       XXX  X.XXXX
                            Mean(SD)         XX(X.X)     XX(X.X)     XX(X.X)   XX(X.X)
                            Median                XX          XX          XX        XX
                            Min, Max          XX, XX      XX, XX      XX, XX    XX, XX
     ...

JENNER FORMAT (This is what Jenner formats were designed for)
proc format lib=library;
/*--- PAGE 1 ---*/
  value
    /*-   Major    Page Line             Major     Minor       Staistic      Process ---*/
    /*-            2     3   4      5    6         7           8             9        --*/
    1  = "AGE      @Page @01 @Order @110 @AGE (y)  @N          @N            @UNIVARIATE"
    2  = "AGE      @Page @01 @Order @120 @AGE (y)  @Mean(SD)   @Mean StdDev  @UNIVARIATE"
    3  = "AGE      @Page @01 @Order @130 @AGE (y)  @Median     @Median       @UNIVARIATE"
    4  = "AGE      @Page @01 @Order @140 @AGE (y)  @Min, Max   @Min Max      @UNIVARIATE";
  value AGEGR1N
    2  = "AGEGR1N  @Page @01 @Order @210 @AGE (y)  @<65 yrs    @NPCT         @NPCT"
    1  = "AGEGR1N  @Page @01 @Order @220 @AGE (y)  @65-80 yrs  @NPCT         @NPCT"
    3  = "AGEGR1N  @Page @01 @Order @230 @AGE (y)  @>80        @NPCT         @NPCT";
  value SEXN
     0  ="SEXN     @Page @01 @Order @300 @Sex      @N          @NPCT         @NPCT"
     1  ="SEXN     @Page @01 @Order @310 @Sex      @Male       @NPCT         @NPCT"
     2 = "SEXN     @Page @01 @Order @320 @Sex      @Female     @NPCT         @NPCT";
  ...

Attachements

1. pages.pdf    Intent to Treat Table PDF
2. pages.docx   Intent to Treat Table MS Word
3. adsl.txt     Intent to Treat Original Table (Need to do some post processing mimor page issue Jenner fixing)
4. adslfix.txt  Post processing adsl.txt to enable a minor formatting issue
5. ads1.log     Log
6  ads1.lst     List

CONTENTS
---------
  1   ADam ADaM ADSL Input Table
      https://tinyurl.com/25zr7ent
  2   R Intent-to-Treat table-Table-14-1-02-using-ADaM-datasets
      https://tinyurl.com/bdzhvkkp
  3   MOCK Table (just first of three pages)
      We will map the mock table to a Jenner format
  4   Jenner Program
  5   Output Intent to Treat Table 14-2.01
      I Decided not to move the footnotes to the boo
  6   Table 14-2.01 in Microsoft Word Format
      I set two Word defaults, landscape and narrow margins(.5in)
      If you see blue and red underlines turn proofing off
  7   Table 14-2.01 in PDF Format
  8   Macros powershell sandwich and utlfkil
---*/

/**************************************************************************************************************************/
/* 1 ADam ADaM ADSL Input Table [ADam ADSL] https://tinyurl.com/25zr7ent                                                  */
/**************************************************************************************************************************/

libname  adam    "d:/adam";
%contentsx(libname=adam,memname=adsl);

/*---
LIST:   14NOV2026:13:40:22
Data Set Name: d:/adam\adsl.parquet
Observations:  254
Variables:     4
Variables (in alphabetical order):
  #  Variable  Type    Len      #  Variable  Type    Len    #  Variable  Type    Len
--------------------------     -------------------------   -------------------------
 16  AGE        Num      8     32  DTHFL     Char      8    4  SITEID    Char      8
 17  AGEGR1    Char      8     39  DURDIS     Num      8    1  STUDYID   Char     12
 18  AGEGR1N    Num      8     40  DURDSGR1  Char      8    3  SUBJID    Char      8
 19  AGEU      Char      8     37  EDUCLVL    Num      8    9  TRT01A    Char     20
  6  ARM       Char     20     26  EFFFL     Char      8   10  TRT01AN    Num      8
 14  AVGDD      Num      8     23  ETHNIC    Char     22    7  TRT01P    Char     20
 33  BMIBL      Num      8     35  HEIGHTBL   Num      8    8  TRT01PN    Num      8
 34  BMIBLGR1  Char      8     25  ITTFL     Char      8   13  TRTDUR     Num      8
 28  COMP16FL  Char      8     48  MMSETOT    Num      8   12  TRTEDT     Num      8  DATE9.
 29  COMP24FL  Char      8     20  RACE      Char     32   11  TRTSDT     Num      8  DATE9.
 27  COMP8FL   Char      8     21  RACEN      Num      8    2  USUBJID   Char     11
 15  CUMDOSE    Num      8     45  RFENDT     Num      8.  41  VISIT1DT   Num      8  DATE9.
 46  DCDECOD   Char     27     43  RFENDTC   Char     10
 47  DCREASCD  Char     18     42  RFSTDTC   Char     10
 30  DISCONFL  Char      8     24  SAFFL     Char      8
 38  DISONSDT   Num      8     22  SEX       Char      8
 31  DSRAEFL   Char      8      5  SITEGR1   Char      8
---*

/**************************************************************************************************************************/
/* 2 R Intent-to-Treat table-Table-14-1-02-using-ADaM-datasets  [R ITT Table] https://tinyurl.com/bdzhvkkp                */
/**************************************************************************************************************************/

/*---
R Intent-to-Treat table-Table-14-1-02-using-ADaM-datasets
https://tinyurl.com/bdzhvkkp
---*/

/**************************************************************************************************************************/
/* 3 MOCK Table (just first of three pages)                                                                               */
/**************************************************************************************************************************/

/*---
 MOCK TABLE

    Protocol: CDISCPILOT01                                                                  Page1 of 3
    Population: Intent-to-Treat
                                               Table 14-2.01
                        Summary of Demographic and Baseline Characteristics

                                                       Xanomeline  Xanomeline
                                              Placebo    Low Dose    Low Dose     Total  P-Value
                                               (N=XX)      (N=XX)      (N=XX)   (N=XXX)  [X]

       AGE (y)               N                     XX          XX          XX       XXX  X.XXXX
                             Mean(SD)         XX(X.X)     XX(X.X)     XX(X.X)   XX(X.X)
                             Median                XX          XX          XX        XX
                             Min, Max          XX, XX      XX, XX      XX, XX    XX, XX

                             <XX yrs          XX(XX%)     XX(XX%)     XX(XX%)  XXX(XX%)  X.XXXX
                             65-80            XX(XX%)      X(XX%)      X(XX%)   XX(XX%)
                             >XX              XX(XX%)     XX(XX%)     XX(XX%)   XX(XX%)

       Sex                   N                     XX          XX          XX       XXX  X.XXXX
                             Male             XX(XX%)     XX(XX%)     XX(XX%)  XXX(XX%)
                             Female           XX(XX%)     XX(XX%)     XX(XX%)  XXX(XX%)

       Race (Origin)         N                     XX          XX          XX       XXX  X.XXXX
                             Cacasian         XX(XX%)     XX(XX%)     XX(XX%)  XXX(XX%)
                             African Descen     X(X%)       X(X%)       X(X%)    XX(X%)
                             Hispanic           X(X%)       X(X%)       X(X%)     X(X%)

       MMSE                  N                     XX          XX          XX       XXX  X.XXXX
                             Mean(SD)         XX(X.X)     XX(X.X)     XX(X.X)   XX(X.X)
                             Median                XX          XX          XX        XX
                             Min, Max          XX, XX      XX, XX      XX, XX    XX, XX


    [1] P-values are results of ANOVA treatment group comparison for continuous variable and Pearson's
    chi-square test for categorical variables.
    NOTE: Duration of disease is computed as months between date of enrollment and date of onset of the
    first definite symptoms of Alzheimer's disease.
    Source: C:\cdisc_pilot\PROGRAMS\DRAFT\TFLs\adsl3.sas                12:13 Friday, November 13, 2026

 ---*/

/**************************************************************************************************************************/
/* 4 Jenner Program                                                                                                       */
/**************************************************************************************************************************/

libname  adam    "d:/adam";
libname  workx   "d:/wpswrkx";    /*--- put this in your autoexec ---*/
libname  library "d:/wpswrkx";    /*--- put this in your autoexec ---*/

proc datasets lib=workx kill;
run;

proc copy in=adam out=workx;
 select adsl;
run;

/*--- SUBSET AND ADD CODES ---*/
options validvarname=upcase;
data workx.adsl12;
   retain trt;
   set workx.adsl(
     keep=
       usubjid
       TRT01A
       RACEN
       AGE
       sex
       AGEGR1N
       MMSETOT
       EDUCLVL
       DURDIS
       WEIGHTBL
       HEIGHTBL
       BMIBL
       );
       select;
          when(0<durdis<12)  durdiscd=1;
          when(durdis=>12)   durdiscd=2;
         otherwise;
       end;
       select;
          when(0<bmibl <25)   bmicd=1;
          when(25<=bmibl <30) bmicd=2;
          when(bmibl =>30)    bmicd=3;
         otherwise;
       end;
       select (TRT01A);
         when ("Xanomeline High Dose") trt="XH";
         when ("Xanomeline Low Dose" ) trt="XL";
         when ("Placebo"             ) trt="Placebo";
         otherwise;
       end;
       if sex="M" then sexn=1;
      else if sex="F" then sexn=2;
    drop TRT01A sex;
run;

proc print data=workx.adsl12(obs=10) width=min;
run;

/*---
workx.adsl12
LIST:   13NOV2026:12:34:20
  Obs  TRT      USUBJID      AGE  AGEGR1N  RACEN  BMIBL  HEIGHTBL  WEIGHTBL  EDUCLVL  DURDIS  MMSETOT  DURDISCD  BMICD SEXN
    1  Placebo  01-701-1015   63        1      1   25.1     147.3      54.4       16    43.9       23         2      2   2
    2  Placebo  01-701-1023   64        1      1   30.4     162.6      80.3       14    76.4       23         2      3   1
    3  XH       01-701-1028   71        2      1   31.4     177.8      99.3       16    42.8       23         2      3   1
    4  XL       01-701-1033   74        2      1   28.8     175.3      88.5       12    55.3       23         2      2   1
---*/

proc format lib=library;
/*--- PAGE 1 ---*/
  value age
    /*-   Major    Page Line             Major                 Minor            Staistic      Process ---*/
    /*-            2     3   4      5    6                     7                8             9        --*/
    1  = "AGE      @Page @01 @Order @110 @AGE (y)              @N               @N            @UNIVARIATE"
    2  = "AGE      @Page @01 @Order @120 @AGE (y)              @Mean(SD)        @Mean StdDev  @UNIVARIATE"
    3  = "AGE      @Page @01 @Order @130 @AGE (y)              @Median          @Median       @UNIVARIATE"
    4  = "AGE      @Page @01 @Order @140 @AGE (y)              @Min, Max        @Min Max      @UNIVARIATE";
  value AGEGR1N
    2  = "AGEGR1N  @Page @01 @Order @210 @AGE (y)              @<65 yrs         @NPCT         @NPCT"
    1  = "AGEGR1N  @Page @01 @Order @220 @AGE (y)              @65-80 yrs       @NPCT         @NPCT"
    3  = "AGEGR1N  @Page @01 @Order @230 @AGE (y)              @>80             @NPCT         @NPCT";
  value SEXN
     0  ="SEXN     @Page @01 @Order @300 @Sex                  @N               @NPCT         @NPCT"
     1  ="SEXN     @Page @01 @Order @310 @Sex                  @Male            @NPCT         @NPCT"
     2 = "SEXN     @Page @01 @Order @320 @Sex                  @Female          @NPCT         @NPCT";
  value RACEN
     0 = "RACEN    @Page @01 @Order @400 @Race (Origin)        @N               @NPCT         @NPCT"
     1 = "RACEN    @Page @01 @Order @410 @Race (Origin)        @Cacasian        @NPCT         @NPCT"
     2 = "RACEN    @Page @01 @Order @420 @Race (Origin)        @African Descent @NPCT         @NPCT"
     6 = "RACEN    @Page @01 @Order @430 @Race (Origin)        @Hispanic        @NPCT         @NPCT";
  value MMSETOT
     1 = "MMSETOT  @Page @01 @Order @510 @MMSE                 @N               @N            @UNIVARIATE"
     2 = "MMSETOT  @Page @01 @Order @520 @MMSE                 @Mean(SD)        @Mean StdDev  @UNIVARIATE"
     3 = "MMSETOT  @Page @01 @Order @530 @MMSE                 @Median          @Median       @UNIVARIATE"
     4 = "MMSETOT  @Page @01 @Order @540 @MMSE                 @Min, Max        @Min Max      @UNIVARIATE";
/*--- PAGE 2 ---*/
  value DURDIS
     1 = "DURDIS   @Page @02 @Order @110 @Duration of disease  @N               @N            @UNIVARIATE"
     2 = "DURDIS   @Page @02 @Order @120 @Duration of disease  @Mean(SD)        @Mean StdDev  @UNIVARIATE"
     3 = "DURDIS   @Page @02 @Order @130 @Duration of disease  @Median          @Median       @UNIVARIATE"
     4 = "DURDIS   @Page @02 @Order @140 @Duration of disease  @Min, Max        @Min Max      @UNIVARIATE";
  value DURDISCD
     1 = "DURDISCD @Page @02 @Order @150 @Duration of disease  @<12 MONTHS      @NPCT         @NPCT"
     2 = "DURDISCD @Page @02 @Order @160 @Duration of disease  @>=12 MONTHS     @NPCT         @NPCT";
  value  EDUCLVL
     1 = "EDUCLVL  @Page @02 @Order @210 @Years of Education   @N               @N            @UNIVARIATE"
     2 = "EDUCLVL  @Page @02 @Order @220 @Years of Education   @Mean(SD)        @Mean StdDev  @UNIVARIATE"
     3 = "EDUCLVL  @Page @02 @Order @230 @Years of Education   @Median          @Median       @UNIVARIATE"
     4 = "EDUCLVL  @Page @02 @Order @240 @Years of Education   @Min, Max        @Min Max      @UNIVARIATE";
  value  WEIGHTBL
     1 = "WEIGHTBL @Page @02 @Order @310 @Baseline weight(kg)  @N               @N            @UNIVARIATE"
     2 = "WEIGHTBL @Page @02 @Order @320 @Baseline weight(kg)  @Mean(SD)        @Mean StdDev  @UNIVARIATE"
     3 = "WEIGHTBL @Page @02 @Order @330 @Baseline weight(kg)  @Median          @Median       @UNIVARIATE"
     4 = "WEIGHTBL @Page @02 @Order @340 @Baseline weight(kg)  @Min, Max        @Min Max      @UNIVARIATE";
/*--- PAGE 3 ---*/
  value  HEIGHTBL
     1 = "HEIGHTBL @Page @03 @Order @110 @Baseline height(cm)  @N               @N            @UNIVARIATE"
     2 = "HEIGHTBL @Page @03 @Order @120 @Baseline height(cm)  @Mean(SD)        @Mean StdDev  @UNIVARIATE"
     3 = "HEIGHTBL @Page @03 @Order @130 @Baseline height(cm)  @Median          @Median       @UNIVARIATE"
     4 = "HEIGHTBL @Page @03 @Order @140 @Baseline height(cm)  @Min, Max        @Min Max      @UNIVARIATE";
  value  BMIBL
     1 = "BMIBL    @Page @03 @Order @210 @Baseline BMI         @N               @N            @UNIVARIATE"
     2 = "BMIBL    @Page @03 @Order @220 @Baseline BMI         @Mean(SD)        @Mean StdDev  @UNIVARIATE"
     3 = "BMIBL    @Page @03 @Order @230 @Baseline BMI         @Median          @Median       @UNIVARIATE"
     4 = "BMIBL    @Page @03 @Order @240 @Baseline BMI         @Min, Max        @Min Max      @UNIVARIATE";
  value BMICD
     1 = "BMICD    @Page @03 @Order @310 @Baseline BMI         @<25             @NPCT         @NPCT"
     2 = "BMICD    @Page @03 @Order @320 @Baseline BMI         @25-30           @NPCT         @NPCT"
     3 = "BMICD    @Page @03 @Order @330 @Baseline BMI         @>=30            @NPCT         @NPCT";
run;

/*--- CREATE A TABLE FROM THE FOEMAT CODE ---*/
proc format lib=library.formats cntlout=workx.mockup;
run;

proc print data=workx.mockup(keep=fmtname label);
run;

/*---
LIST:   14NOV2026:07:13:25
  Obs  FMTNAME   LABEL
    1  AGE       AGE      @Page @01 @Order @110 @AGE (y)              @N               @N            @UNIVARIATE
    2  AGE       AGE      @Page @01 @Order @120 @AGE (y)              @Mean(SD)        @Mean StdDev  @UNIVARIATE
    3  AGE       AGE      @Page @01 @Order @130 @AGE (y)              @Median          @Median       @UNIVARIATE
    4  AGE       AGE      @Page @01 @Order @140 @AGE (y)              @Min, Max        @Min Max      @UNIVARIATE
    5  AGEGR1N   AGEGR1N  @Page @01 @Order @210 @AGE (y)              @<65 yrs         @NPCT         @NPCT
    6  AGEGR1N   AGEGR1N  @Page @01 @Order @220 @@AGE (y)             @65-80 yrs       @NPCT         @NPCT
    7  AGEGR1N   AGEGR1N  @Page @01 @Order @230 @AGE (y)              @>80             @NPCT         @NPCT
---*/

/*--- PIVOT LONG ---*/
data workx.nrm1st;
  keep    trt question answer;
  length  question  $200;
  set workx.adsl12;
  question=put(sexn,sexn.);        answer=1;        link all; * NPCT;
  question=put(racen,racen.);      answer=1;        link all;
  question=put(AGEGR1N,AGEGR1N.);  answer=1;        link all;
  question=put(durdiscd,durdiscd.);answer=1;        link all;
  question=put(bmicd,bmicd.);      answer=1;        link all;
  question='AGE';                  answer=age;      link all; * UNIVARIATE;
  question='MMSETOT';              answer=MMSETOT;  link all;
  question='EDUCLVL';              answer= EDUCLVL; link all;
  question='DURDIS' ;              answer= DURDIS;  link all;
  question='WEIGHTBL';             answer= WEIGHTBL;link all;
  question='HEIGHTBL';             answer= HEIGHTBL;link all;
  question='BMIBL';                answer= BMIBL;   link all;
return;
all:
  output;
  savtrt=trt;
  trt="All";
  output;
  trt=savtrt;
return;
run;

proc print data=workx.nrm1st(obs=5);
run;


/*--- FILL IN ALL POSSIBLE NPCT COMBINATIONS WITH 0 COUNTS FOR A LATTER JOIN         ---*/
/*--- NEED A SHELL TABLE SO MISSING CATEGORIES CAN BE REPRESENTED IN THE REPORT      ---*/
/*--- NOTE WE USE THE FORMAT TO GENERATE ALL COMBINATIONS                            ---*/
/*--- ANSWER WILL BE THE WEIGHTS MISSING CATEGORIES WILL HAVE 0 COUNTS AND PERCENTS  ---*/
/*--- WE WILL BE TAKING AVANTAGE OF POWERFULl QUESTION/ANSWER NORMAILZATION          ---*/
data workx.shl;
 length  question  $96 trt $24;
 keep trt question answer;
 set workx.mockup(where=(scan(label,8,'@') eq 'NPCT'));      /* only categorical variables */
 trt="Placebo"    ; question=label; answer=0; output;
 trt="XL"         ; question=label; answer=0; output;
 trt="XH"         ; question=label; answer=0; output;
 trt="All"        ; question=label; answer=0; output;
run;

proc print data=workx.shl;
run;

/*--- NOTE ALL THE 0 (60 of them)
Obs  question                                                                                   trt      answer
  1  AGEGR1N  @Page @01 @Order @210 @AGE (y)              @<65 yrs         @NPCT         @NPCT  Placebo       0
  2  AGEGR1N  @Page @01 @Order @210 @AGE (y)              @<65 yrs         @NPCT         @NPCT  XL            0
  3  AGEGR1N  @Page @01 @Order @210 @AGE (y)              @<65 yrs         @NPCT         @NPCT  XH            0
  4  AGEGR1N  @Page @01 @Order @210 @AGE (y)              @<65 yrs         @NPCT         @NPCT  All           0
---*/

/*--- ALL NPCT ROWS HAVE JUST 1 WE WILL AD 0S LATER TO FILL IN ALL POSSIBLE COMBINATIONS ---*/
proc sql;
 create
   table workx.shldat  as
 select
   coalesce(dat.trt,shl.trt)                                   as trt
  ,coalesce(SCAN(dat.question,1),sCAN(shl.question,1)) as grp  length=8
  ,coalesce(dat.question,shl.question)                         as question length=96
  ,coalesce(dat.answer,shl.answer)                             as answer
 from
  (select distinct * from workx.shl) as shl left join workx.nrm1st as dat
 on
  shl.question = dat.question  and
  shl.trt      = dat.trt
 order
  by grp, trt, question;
;quit;

proc freq data=workx.shldat;
  tables trt;
run;

proc print data=workx.shldat(obs=10);
run;

/*---
LIST:   14NOV2026:07:19:41 LOTS OF ONES
                                     Cumulative    Cumulative
trt        Frequency    Percent     Frequency      Percent
----------------------------------------------------------------
All             1271     49.88         1271        49.88
Placebo          433     16.99         1704        66.88
XH               422     16.56         2126        83.44
XL               422     16.56         2548       100.00

 trt  grp      question                                                                                   answer
 All  AGEGR1N  AGEGR1N  @Page @01 @Order @210 @AGE (y)              @<65 yrs         @NPCT         @NPCT       1
 All  AGEGR1N  AGEGR1N  @Page @01 @Order @210 @AGE (y)              @<65 yrs         @NPCT         @NPCT       1
 All  AGEGR1N  AGEGR1N  @Page @01 @Order @210 @AGE (y)              @<65 yrs         @NPCT         @NPCT       1
 All  AGEGR1N  AGEGR1N  @Page @01 @Order @210 @AGE (y)              @<65 yrs         @NPCT         @NPCT       1
 All  AGEGR1N  AGEGR1N  @Page @01 @Order @210 @AGE (y)              @<65 yrs         @NPCT         @NPCT       1
---*/

/*--- DIMENSION VARIABLES CATEGORICAL N(PCT) VARIABLES ---*/
proc sql;
   create
     table workx.cntpct as
   select
    distinct
     l.trt
    ,l.grp
    ,l.question
    ,r.sumgrp
    ,cats(put(sum(l.answer),4.),'(',put(sum(l.answer)/r.sumgrp,percent.),')') as answer
  from
     workx.shldat as l, (select trt, grp, sum(answer) as sumgrp from workx.shldat group by trt, grp) as r
  where
     l.trt        =  r.trt  and
     l.grp        =  r.grp
  group
     by l.trt, l.grp, l.question
;quit;

proc print data=workx.cntpct;
run;

/*---
LIST:   14NOV2026:07:25:08
  Obs  trt      grp       question
    1  All      AGEGR1N   AGEGR1N  @Page @01 @Order @210 @AGE (y)              @<65 yrs         @NPCT         @NPCT
    2  All      AGEGR1N   AGEGR1N  @Page @01 @Order @220 @@AGE (y)             @65-80 yrs       @NPCT         @NPCT
    3  All      AGEGR1N   AGEGR1N  @Page @01 @Order @230 @AGE (y)              @>80             @NPCT         @NPCT
    4  All      BMICD     BMICD    @Page @03 @Order @310 @Baseline BMI         @<25             @NPCT         @NPCT
    5  All      BMICD     BMICD    @Page @03 @Order @320 @Baseline BMI         @25-30           @NPCT         @NPCT
    6  All      BMICD     BMICD    @Page @03 @Order @330 @Baseline BMI         @>=30            @NPCT         @NPCT
---*/

/*---  SUMMARIZE    FACT NUMERIC VARIABLE                                            ---*/
/*---  STATISTICS   Mean StdDev Median Min Max N                                     ---*/
/*---  FLOATS      "AGE" "BMIBL" "DURDIS" "EDUCLVL" "HEIGHTBL" "MMSETOT" "WEIGHTBL"  ---*/
proc sql;
  select distinct(quote(trim(scan(label,1,'@',' ')))) into :floats separated by ' '     from workx.mockup where trim(scan(label,9,'@'))  ne "NPCT";
  select distinct(trim(scan(label,8,'@',' ')))  into :statistics separated by ' '     from workx.mockup where trim(scan(label,9,'@'))  ne "NPCT";
quit;

%put 1 &=floats;
%put 2 &=statistics;

proc summary data=workx.nrm1st(where=(trim(scan(question,1,'@',' ')) in (&floats))) &statistics nway;
class trt question;
var answer;
output out=workx.demunv;
run;

proc print data=workx.demunv;
run;

/*---
LIST:   14NOV2026:07:29:58 FACT VARIABLES
  Obs  TRT      QUESTION  _TYPE_  _FREQ_     ANSWER_Mean  ANSWER_StdDev  ANSWER_Median  ANSWER_Min  ANSWER_Max  ANSWER_N
    1  All      AGE            3     254   75.0866141732   8.2462338962             77          51          89       254
    2  All      BMIBL          3     254   24.6723320158    4.092184927           24.2        13.7        40.1       253
    3  All      DURDIS         3     254   43.9393700787  28.3973156263          36.25         2.2       183.1       254
    4  All      EDUCLVL        3     254   12.7519685039   3.3829227112             12           3          24       254
    5  All      HEIGHTBL       3     254   163.931496063  10.7604472686         162.85       135.9       195.6       254
    6  All      MMSETOT        3     254   18.1417322835   4.2103287441             19          10          24       254
    7  All      WEIGHTBL       3     254    66.647826087  14.1314255373           66.7          34         108       253
---*/

/*--- PIVOT LONG FACT VARIABLES ---*/ ;
data workx.nrmunv;
 keep trt grp question answer;
 length question answer $96;
 do until (dne);
   set workx.demunv end=dne;
   format _all_;
   grp=question;
   fmt=strip(question);
   question=putn(1,fmt);
   answer=put(answer_n,5.);
   output;
   question=putn(2,fmt);
   answer=cats(put(answer_mean,5.),'(',put(answer_stddev,5.1),')');
   output;
   question=putn(3,fmt);
   answer=put(answer_median,5.);
   output;
   question=putn(4,fmt);
   answer=strip(put(answer_min,5.))!!', '!!strip(put(answer_max,5.));
   output;
 end;

 dne=0;
 do until (dn1);
   set workx.cntpct end=dn1;
   format _all_;
   output;
 end;
 stop;
run;

proc print data=workx.nrmunv;
run;

/*----
LIST:   14NOV2026:07:32:05
  Obs  question                                                                                         answer     TRT
    1  AGE      @Page @01 @Order @110 @AGE (y)              @N               @N            @UNIVARIATE    254
    2  AGE      @Page @01 @Order @120 @AGE (y)              @Mean(SD)        @Mean StdDev  @UNIVARIATE  75(8.2)    All
    3  AGE      @Page @01 @Order @130 @AGE (y)              @Median          @Median       @UNIVARIATE     77      All
    4  AGE      @Page @01 @Order @140 @AGE (y)              @Min, Max        @Min Max      @UNIVARIATE  51, 89     All
   '''
   57  AGE      @Page @01 @Order @110 @AGE (y)              @N               @N            @UNIVARIATE     84       XH
   58  AGE      @Page @01 @Order @120 @AGE (y)              @Mean(SD)        @Mean StdDev  @UNIVARIATE  74(7.9)     XH
   59  AGE      @Page @01 @Order @130 @AGE (y)              @Median          @Median       @UNIVARIATE     76       XH
   60  AGE      @Page @01 @Order @140 @AGE (y)              @Min, Max        @Min Max      @UNIVARIATE  56, 88      X
---*/

/*--- PIVOT WIDE BY QUESTION TRT ---*/

proc sort data=workx.nrmunv out=srt nodupkey;
  by question trt;
run;

proc transpose data=srt out=workx.xpo(drop=_name_) ;
 by question;
 id trt;
 var answer;
run;

proc print data=workx.xpo width=min;
run;quit;

/*---

                                                                                                     ADDED THESE
LIST:   14NOV2026:07:44:34                                                                 ---------------------------------
  Obs  question                                                                            All      Placebo    XH         XL
    1  AGE      @Page @01 @Order @110 @AGE (y)  @N           @N            @UNIVARIATE    254        86         84         84
    2  AGE      @Page @01 @Order @120 @AGE (y)  @Mean(SD)    @Mean StdDev  @UNIVARIATE  75(8.2)   75(8.6)    74(7.9)    76(8.3)
    3  AGE      @Page @01 @Order @130 @AGE (y)  @Median      @Median       @UNIVARIATE     77        76         76         78
    4  AGE      @Page @01 @Order @140 @AGE (y)  @Min, Max    @Min Max      @UNIVARIATE  51, 89    52, 89     56, 88     51, 88
    5  AGEGR1N  @Page @01 @Order @210 @AGE (y)  @<65 yrs     @NPCT         @NPCT        144(57%)  42(49%)    55(65%)    47(56%)
    6  AGEGR1N  @Page @01 @Order @220 @@AGE (y) @65-80 yrs   @NPCT         @NPCT        33(13%)   14(16%)    11(13%)    8(10%)
    7  AGEGR1N  @Page @01 @Order @230 @AGE (y)  @>80         @NPCT         @NPCT        77(30%)   30(35%)    18(21%)    29(35%)
 ---*/


/*--- P VALUE FACT VARIABLES USING ANOVA ---*/
proc sql;
  select distinct(trim(scan(label,1,'@',' ')))
  into :floats
  separated by ' '
  from workx.mockup
  where trim(scan(label,9,'@')) ne "NPCT";
quit;

%put FLOATS &=floats;
/*--- FLOATS FLOATS=AGE MMSE ---*/

%macro glmx(vars);
%local i res;
%let i=0;
%do i=1 %to %sysfunc(countw(&floats));
  %let res=%qscan(&vars,&i);
  %put ITER &=res &=i;
  ods output OverallANOVA=&res;
  proc glm data=workx.ADSL12;
    class trt;
    model &res = trt;
  run;
%end;
ods output close;
run;
%mend glmx;

%glmx(&floats);

%put &=floats;

PROC PRINT DATA=AGE;
run;

data workx.pFloats;
  set &floats indsname=src;
  if upcase(source)="MODEL";
  fro=scan(src,2,'.');
  put fro= src=;
  pval=input(probf,8.5);
  keep fro pval;
run;

proc print data=workx.pfloats;
run;

/*---
LIST:   14NOV2026:07:59:39
Obs  fro           pval
    1  AGE       0.593435
    2  BMIBL     0.013319
    3  DURDIS     0.15296
    4  EDUCLVL   0.387508
    5  HEIGHTBL  0.126217
    6  MMSETOT   0.594659
    7  WEIGHTBL   0.00304
---*/

/*--- P VALUE DIMENTSION FACT VARIABLES USING PROC FREQ     ---*/
/*--- DIMENSION VARIABLES AGEGR1N BMICD DURDISCD RACEN SEXN  ---*/
proc sql;
  select distinct(trim(scan(label,1,'@',' ')))
  into :catagorical
  separated by ' '
  from workx.mockup
  where trim(scan(label,9,'@')) eq "NPCT";
quit;

%put CATAGORICAL &=CATAGORICAL;

/*--- COMPUTE P VALS USING PROC FTREQ ---*/
%MACRO FRQX(VARS);
%local i res;
%let i=0;
%do %until(&res= );
  %let i=%eval(&i + 1);
  %let res=%qscan(&vars,&i);
  %put ITER &=res &=i;
  Proc freq data=workx.adsl12;
    tables trt*&res / chisq expected;
  output out=&res pchi;
  run;
%end;
%mend frqx;

%frqx(&catagorical);

/*--- TABLE WITH P VALUES ---*/
data workx.pCatagorical;
  set &catagorical indsname=src;
  fro=scan(src,2,'.');
  put fro= src=;
  pval=p_pchi;
  keep fro pval;
run;

proc print data=workx.pCatagorical;
run;

/*---
LIST:   14NOV2026:08:05:32
  Obs  fro         pval
    1  AGEGR1N   0.1439
    2  BMICD     0.2235
    3  DURDISCD  0.7885
    4  RACEN      0.604
    5  SEXN      0.1409
 16
---*/

/*--- COMBINE DIMENSION AND FACT VARIABLE P VALUES ---*/
data workx.glmfrq;
   length fro $8;
   set
     workx.pCatagorical
     workx.pfloats;
   format pval 8.5;
run;

proc print data=workx.glmfrq;
run;

/*---
LIST:   14NOV2026:08:06:58
  Obs  fro           pval
    1  AGEGR1N    0.14390
    2  BMICD      0.22350
    3  DURDISCD   0.78850
    4  RACEN      0.60400
    5  SEXN       0.14090
    6  AGE        0.59344
    7  BMIBL      0.01332
    8  DURDIS     0.15296
    9  EDUCLVL    0.38751
   10  HEIGHTBL   0.12622
   11  MMSETOT    0.59466
   12  WEIGHTBL   0.00304
---*/

/*--- ADD PVALUES TO QUESTIONS ---*/
proc sql;
   create
      table workx.addpvals as
   select
      l.*
     ,r.pval
   from
     workx.xpo as l left join workx.glmfrq as r
   on
     scan(question,1,' ') = r.fro
;quit;

proc print data=workx.addpvals;
run;

/*---
LIST:   14NOV2026:08:10:00
  question                                                                        All    Placebo    XH         XL          pval
  AGE   @Page @01 @Order @110 @AGE (y)  @N          @N            @UNIVARIATE    254        86         84         84    0.59344
  AGE   @Page @01 @Order @120 @AGE (y)  @Mean(SD)   @Mean StdDev  @UNIVARIATE  75(8.2)   75(8.6)    74(7.9)    76(8.3)  0.59344
  AGE   @Page @01 @Order @130 @AGE (y)  @Median     @Median       @UNIVARIATE     77        76         76         78    0.59344
  AGE   @Page @01 @Order @140 @AGE (y)  @Min, Max   @Min Max      @UNIVARIATE  51, 89    52, 89     56, 88     51, 88   0.59344


/*---REMOVE QUESTION AND SET UP FOR PROC REPORT ---*/
proc sql;
 create
   table workx.prerpt as
 select
    input(scan(question,3,'@'),5.) as pge
   ,scan(question,5,'@')           as odr length=3
   ,scan(question,6,'@')           as mjr length=64
   ,scan(question,7,'@')           as mnr length=64
   ,Placebo      length=24
   ,XL           length=24
   ,XH           length=24
   ,all          length=24
   ,Pval         length=24
 from
   workx.addpvals
 where
   scan(question,5,'@') ne 'XX'
 order
   by pge, odr
;quit;

proc print data=workx.prerpt;
run;

/*---
LIST:   14NOV2026:08:14:30
  Obs  pge  odr  mjr       mnr        Placebo    XL         XH         All            pval
    1    1  110  AGE (y)   N             86         84         84        254       0.59344
    2    1  120  AGE (y)   Mean(SD)   75(8.6)    76(8.3)    74(7.9)    75(8.2)     0.59344
    3    1  130  AGE (y)   Median        76         78         76         77       0.59344
    4    1  140  AGE (y)   Min, Max   52, 89     51, 88     56, 88     51, 89      0.59344
    5    1  210  AGE (y)   <65 yrs    42(49%)    47(56%)    55(65%)    144(57%)    0.14390
    6    1  220            AGE (y)    14(16%)    8(10%)     11(13%)    33(13%)     0.14390
    7    1  230  AGE (y)   >80        30(35%)    29(35%)    18(21%)    77(30%)     0.14390
---*/

/*--- THIS HARDCODING SHOULD BE REMOVED                                                   ---*/
/*--- THIS CODE WAS ADDED BECAUSE I FORGOT TO ADD IT TO PREVIOUS PROC FREQ                ---*/
/*--- TOO LAZY TO GO BACK AND ADD NS USING PREVIOUS PROC FREQ                             ---*/
/*--- THERE WERE TWO CASES WITH N COUNTS FOR DIMENSION VARIABLES THAT I FORGOT TO COMPUTE ---*/
/*--- NOT ALL DIMENSION VARIABLES HAVE THE N CATEGORY                                     ---*/
/*--- FIINAL STEPS TO TO CREATE FINAL TAB:E FOR PROC REPORT                               ---*/
proc sql;
  create table workx.fillin as (
  select trt,'Sex' as cat, '300' as odr, count(sexn) as cnt_nomiss from workx.adsl12 group by trt
  union all
  select trt,'Race (Origin)' as cat, '400' as odr, count(racen) as cnt_nomiss from workx.adsl12 group by trt
  union all
  select 'All' as trt,'Sex' as cat, '300' as odr, count(sexn) as cnt_nomiss from workx.adsl12
  union  all
  select 'All' as trt,'Race (Origin)' as cat, '400' as odr, count(racen) as cnt_nomiss from workx.adsl12)
  order by odr;
;quit;

proc transpose data=workx.fillin out=workx.xpofillin;
id trt;
by odr;
var cnt_nomiss;
run;

proc print data=workx.xpofillin;
run;

/*--- HERE ARE THE NS WE NEED TO ADD )NOTEPAGE ODER IS A PRIMARY KEY
LIST:   14NOV2026:08:32:33
  Obs  odr  _NAME_      Placebo  XH  XL  All
    1  300  cnt_nomiss       86  84  84  254
    2  400  cnt_nomiss       86  84  84  254
---*/

/*--- IN PLACE MODIFICATION TO REPLACE THE SHELL CREATED 0'S FOR N WITH NEW VALUES ---*/
data workx.prerpt;
  modify workx.prerpt workx.xpofillin;
  by odr;
run;quit;

proc print data=workx.prerpt;
run;

/*--- fix pval ---*/
data workx.fixpval;
   length mjr $20;
   set workx.prerpt;
   by pval notsorted;
   mjr=strip(mjr);
   if first.pval then pvalue=put(pval,6.4);
   else pvalue=' ';
   output;
   if cats(pge,odr) in ("1140","3240","2140") then do;
   mnr="";placebo="";xl="";xh="";all="";output;
   end;
   drop pval;
run;

proc print data=workx.fixpval;
run;

/*---
LIST:   14NOV2026:08:42:05
  Obs  pge  odr  mjr                    mnr                   Placebo    XL         XH         All            pval
    1    1  110  AGE (y)                N                        86         84         84        254       0.59344
    2    1  120  AGE (y)                Mean(SD)              75(8.6)    76(8.3)    74(7.9)    75(8.2)     0.59344
    3    1  130  AGE (y)                Median                   76         78         76         77       0.59344
    4    1  140  AGE (y)                Min, Max              52, 89     51, 88     56, 88     51, 89      0.59344
    5    1  210  AGE (y)                <65 yrs               42(49%)    47(56%)    55(65%)    144(57%)    0.14390
    6    1  220  AGE (y)                65-80                 14(16%)    8(10%)     11(13%)    33(13%)     0.14390
    7    1  230  AGE (y)                >80                   30(35%)    29(35%)    18(21%)    77(30%)     0.14390
---*/

proc sql;select max(pge) into :maxpge separated by '' from prerpt;quit;
%put MAX NUMBER OF PAGES &=maxpge;
/*--- MAX NUMBER OF PAGES MAXPGE=3 ---*/

/*--- COMPUTE BIG Ns ---*/
proc sql;
  select cats("Placebo","#(N=",sum(trt="Placebo"),")") into :Placebo      from workx.adsl12;
  select cats("Xanomeline#Low Dose","#(N=",sum(trt="XL"),")") into :XL    from workx.adsl12;
  select cats("Xanomeline#High Dose","#(N=",sum(trt="XH"),")") into :XH   from workx.adsl12;
  select cats("Total","#(N=",count(*),")") into :All from workx.adsl12;
  select catx(' ',put(timepart(datetime()), time5.),put(datepart(datetime()), weekdate29.)) into :dt from workx.adsl12(obs=1);
;quit;

%put &=xl;
%put &=xh;
%put &=placebo;
%put &=dt;

/*---
XL=Xanomeline#Low Dose#(N=84)
XH=Xanomeline#High Dose#(N=84)
PLACEBO=Placebo#(N=86)
DT=8:50 Saturday, November 14, 2026
---*/

%utlfkil(d:/txt/adsl.txt);

options ps=42 center nodate nonumber;
ods listing file = "d:/txt/adsl.txt";
proc sql;select max(pge) into :maxpge separated by '' from prerpt;quit;
%put MAX NUMBER OF PAGES &=maxpge;
%macro mny;
 %do pge=1 %to &maxpge;
    proc report data=workx.fixpval(where=(pge=&pge))  nowd split='#' missing headskip;
    title1  "Protocol: CDISCPILOT01                                                                  Page &pge of 3";
    TiTLe2  "Population: Intent-to-Treat                                                                        ";
    TiTLe3  "Table 14-2.01";
    TiTLe4  "Summary of Demographic and Baseline Characteristics";
         cols  pge mjr mnr placebo xl xh all pvalue;
          define pge           / order " " noprint;
          define mjr           / order " " left width=20  order=data;
          define mnr           / display  " "              width=15;
          define placebo       / display  "&placebo" right width=8;
          define XL            / display  "&XL"      right width=10;
          define XH            / display  "&XH"      right width=10;
          define All           / display  "&All"     right width=8;
          define pvalue        / display  "P-Value#[1]"    width=8;
          break after mjr;
          compute after mjr;
            spc=" ";
            line spc $char1.;
          endcomp;
          break after pge / page;
     footnote1 "[1] P-values are results of ANOVA treatment group comparison for continuous variable and Pearson's ";
     footnote2 "chi-square test for categorical variables.                                                         ";
     footnote3 "NOTE: Duration of disease is computed as months between date of enrollment and date of onset of the";
     footnote4 "first definite symptoms of Alzheimer's disease.                                                    ";
     footnote5 "Source: C:\cdisc_pilot\PROGRAMS\DRAFT\TFLs\adsl3.sas                 &dt";
    run;quit;
 %end;
%mend nmy;
%mny;
ods listing close;

/*---
          Protocol: CDISCPILOT01                                                                  Page 1 of 3
          Population: Intent-to-Treat
                                                     Table 14-2.01
                                  Summary of Demographic and Baseline Characteristics

                                                                 Xanomeline  Xanomeline
                                                        Placebo    Low Dose    Low Dose     Total  P-Value
                                                         (N=86)      (N=84)      (N=84)   (N=254)  [1]

             AGE (y)                   N                     86          84          84       254  0.5934
                                       Mean(SD)         75(8.6)     76(8.3)     76(8.3)   75(8.2)
                                       Median                76          78          78        77
                                       Min, Max          52, 89      51, 88      51, 88    51, 89

                                       <65 yrs          42(49%)     47(56%)     47(56%)  144(57%)  0.1439
                                       65-80 yrs        14(16%)      8(10%)      8(10%)   33(13%)
                                       >80              30(35%)     29(35%)     29(35%)   77(30%)

             Sex                       N                     86          84          84       254  0.1409
                                       Male             33(38%)     34(40%)     34(40%)  111(44%)
                                       Female           53(62%)     50(60%)     50(60%)  143(56%)

             Race (Origin)             N                     86          84          84       254  0.6040
                                       Cacasian         78(91%)     78(93%)     78(93%)  230(91%)
                                       African Descen     8(9%)       6(7%)       6(7%)    23(9%)
                                       Hispanic           0(0%)       0(0%)       0(0%)     1(0%)

             MMSE                      N                     86          84          84       254  0.5947
                                       Mean(SD)         18(4.3)     18(4.2)     18(4.2)   18(4.2)
                                       Median                20          18          18        19
                                       Min, Max          10, 23      10, 24      10, 24    10, 24


          [1] P-values are results of ANOVA treatment group comparison for continuous variable and Pearson's
          chi-square test for categorical variables.
          NOTE: Duration of disease is computed as months between date of enrollment and date of onset of the
          first definite symptoms of Alzheimer's disease.
          Source: C:\cdisc_pilot\PROGRAMS\DRAFT\TFLs\adsl3.sas                12:13 Friday, November 13, 2026



          Protocol: CDISCPILOT01                                                                  Page 2 of 3
          Population: Intent-to-Treat
                                                     Table 14-2.01
                                  Summary of Demographic and Baseline Characteristics

                                                                 Xanomeline  Xanomeline
                                                        Placebo    Low Dose    Low Dose     Total  P-Value
                                                         (N=86)      (N=84)      (N=84)   (N=254)  [1]

             Duration of disease       N                     86          84          84       254  0.1530
                                       Mean(SD)        43(30.2)    49(29.6)    49(29.6)  44(28.4)
                                       Median                35          40          40        36
                                       Min, Max          7, 183      8, 131      8, 131    2, 183

                                       <12 MONTHS         5(6%)       3(4%)       3(4%)    12(5%)  0.7885
                                       >=12 MONTHS      81(94%)     81(96%)     81(96%)  242(95%)

             Years of Education        N                     86          84          84       254  0.3875
                                       Mean(SD)         13(2.9)     13(4.1)     13(4.1)   13(3.4)
                                       Median                12          12          12        12
                                       Min, Max           6, 21       3, 24       3, 24     3, 24

             Baseline weight(kg)       N                     86          83          83       253  0.0030
                                       Mean(SD)        63(12.8)    67(14.1)    67(14.1)  67(14.1)
                                       Median                61          65          65        67
                                       Min, Max          34, 86     45, 106     45, 106   34, 108


          [1] P-values are results of ANOVA treatment group comparison for continuous variable and Pearson's
          chi-square test for categorical variables.
          NOTE: Duration of disease is computed as months between date of enrollment and date of onset of the
          first definite symptoms of Alzheimer's disease.
          Source: C:\cdisc_pilot\PROGRAMS\DRAFT\TFLs\adsl3.sas                12:13 Friday, November 13, 2026



          Protocol: CDISCPILOT01                                                                  Page 3 of 3
          Population: Intent-to-Treat
                                                     Table 14-2.01
                                  Summary of Demographic and Baseline Characteristics

                                                                 Xanomeline  Xanomeline
                                                        Placebo    Low Dose    Low Dose     Total  P-Value
                                                         (N=86)      (N=84)      (N=84)   (N=254)  [1]

             Baseline height(cm)       N                     86          84          84       254  0.1262
                                       Mean(SD)        163(11.5   163(10.4)   163(10.4)  164(10.8
                                       Median               163         163         163       163
                                       Min, Max        137, 185    136, 196    136, 196  136, 196

             Baseline BMI              N                     86          83          83       253  0.0133
                                       Mean(SD)         24(3.7)     25(4.3)     25(4.3)   25(4.1)
                                       Median                23          24          24        24
                                       Min, Max          15, 33      18, 40      18, 40    14, 40

                                       <25              59(69%)     46(55%)     46(55%)  149(59%)  0.2235
                                       25-30            21(24%)     27(33%)     27(33%)   76(30%)
                                       >=30               6(7%)     10(12%)     10(12%)   28(11%)


          [1] P-values are results of ANOVA treatment group comparison for continuous variable and Pearson's
          chi-square test for categorical variables.
          NOTE: Duration of disease is computed as months between date of enrollment and date of onset of the
          first definite symptoms of Alzheimer's disease.
          Source: C:\cdisc_pilot\PROGRAMS\DRAFT\TFLs\adsl3.sas                12:13 Friday, November 13, 2026

 ---*/

/*--- PAD LINES SO FOOTNOTES ARE AT THE BOTTOM OF THE PAGE ---*/
/*--- PAGESIZE IS CURRENTLY GETTING FIXED                 ----*/
/*--- JENNER IS ACTIVELY WORKING ON PAGESIXE ISSUES       ----*/
/*--- SOON YOU WILL NOT NEED TO PAD REPORTS               ----*/



%utlfkil(d:/txt/adslfix.txt);

options pagesize=42;
%let footn=5; /*--- NUMBER OD FOOTNOTES ---*/
%let psx=%sysfunc(getoption(pagesize));
data workx.FixPs;
  retain lyn 0;
  infile "d:/txt/adsl.txt";
  input;
  file "d:/txt/adslfix.txt";
  if left(_infile_) =: '[1]'  then do;
    savLyn = _infile_;
    *putlog lyn=;
    *--- 5 is the number of footnotes ---;
    do lyns = 1 to ((&psx-&footn) - lyn);
       put "   ";
       *putlog "&psx" lyn=;
       *putlog lyns= _infile_;
    end;
    put savlyn;
    lyn=-&footn;
  end;
  else do;
    lyn = lyn + 1;
    if lyn=1 then _infile_=substr(_infile_,2);
    put _infile_;
    *putlog lyn= _infile_;
  end;
run;

/**************************************************************************************************************************/
/*  6 Table 14-2.01 in Microsoft Word Format                                                                              */
/**************************************************************************************************************************/

/*--- CONVERT TO MS WORD ---*/
%utlfkil(D:\doc\pages.docx);

%jnr_powershellBegin;
cards4;
$ErrorActionPreference = "Stop"

$inputFile  = "D:\txt\adslfix.txt"
$outputFile = "D:\doc\pages.docx"

$word  = $null
$doc   = $null
$range = $null

try {
    Write-Host "1. Checking input file..."

    if (-not (Test-Path -LiteralPath $inputFile -PathType Leaf)) {
        throw "Input file not found: $inputFile"
    }

    $outputDir = Split-Path -Parent $outputFile

    if (-not (Test-Path -LiteralPath $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir -Force |
            Out-Null
    }

    Write-Host "2. Reading text..."
    $text = Get-Content -LiteralPath $inputFile -Raw -Encoding UTF8

    if ([string]::IsNullOrEmpty($text)) {
        throw "Input file is empty: $inputFile"
    }

    Write-Host "   Read $($text.Length) characters."

    Write-Host "3. Starting Microsoft Word..."
    $word = New-Object -ComObject Word.Application

    $word.Visible = $true
    $word.DisplayAlerts = -1

    Write-Host "4. Creating document..."
    $doc = $word.Documents.Add()

    Write-Host "5. Inserting text..."
    $range = $doc.Content
    $range.Text = $text

    Write-Host "6. Formatting..."
    $range.Font.Name = "Courier New"
    $range.Font.Size = 9

    $range.ParagraphFormat.SpaceBefore = 0
    $range.ParagraphFormat.SpaceAfter  = 0

    #$doc.PageSetup.Orientation  = 1
    #$doc.PageSetup.TopMargin    = 36
    #$doc.PageSetup.BottomMargin = 36
    #$doc.PageSetup.LeftMargin   = 36
    #$doc.PageSetup.RightMargin  = 36

    Write-Host "7. Saving Word document..."

    # 12 = wdFormatXMLDocument (.docx)
    $doc.SaveAs2($outputFile, 12)

    if (-not (Test-Path -LiteralPath $outputFile -PathType Leaf)) {
        throw "Word returned without creating the DOCX file."
    }

    Write-Host "Word document exists: $outputFile"
}
catch {
    Write-Host ("ERROR: " + $_.Exception.Message) -ForegroundColor Red
    throw
}
finally {
    if ($null -ne $range) {
        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($range)
    }

    if ($null -ne $doc) {
        Write-Host "8. Closing document..."
        try {
            $doc.Close(0)
        }
        catch {
            Write-Warning $_.Exception.Message
        }

        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($doc)
    }

    if ($null -ne $word) {
        Write-Host "9. Quitting Word..."
        try {
            $word.Quit()
        }
        catch {
            Write-Warning $_.Exception.Message
        }

        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($word)
    }
}
Write-Host "Finished."
;;;;
%jnr_powershellEnd;

/**************************************************************************************************************************/
/*  7 Table 14-2.01 in PDF Format                                                                                         */
/**************************************************************************************************************************/

%utlfkil(D:\pdf\pages.pdf);

%jnr_powershellBegin;
cards4;
$ErrorActionPreference = "Stop"

$inputFile  = "D:\txt\adslfix.txt"
$outputFile = "D:\pdf\pages.pdf"

$word  = $null
$doc   = $null
$range = $null

try {
    Write-Host "1. Checking input file..."

    if (-not (Test-Path -LiteralPath $inputFile -PathType Leaf)) {
        throw "Input file not found: $inputFile"
    }

    $outputDir = Split-Path -Parent $outputFile

    if (-not (Test-Path -LiteralPath $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir -Force |
            Out-Null
    }

    Write-Host "2. Reading text..."
    $text = Get-Content -LiteralPath $inputFile -Raw -Encoding UTF8

    if ([string]::IsNullOrEmpty($text)) {
        throw "Input file is empty: $inputFile"
    }

    Write-Host "   Read $($text.Length) characters."

    Write-Host "3. Starting Microsoft Word..."
    $word = New-Object -ComObject Word.Application

    # Keep Word visible and alerts enabled during diagnosis.
    $word.Visible = $true
    $word.DisplayAlerts = -1

    Write-Host "4. Creating document..."
    $doc = $word.Documents.Add()

    Write-Host "5. Inserting text..."
    $range = $doc.Content
    $range.Text = $text

    Write-Host "6. Formatting..."
    $range.Font.Name = "Courier New"
    $range.Font.Size = 9

    $range.ParagraphFormat.SpaceBefore = 0
    $range.ParagraphFormat.SpaceAfter  = 0

    #$doc.PageSetup.Orientation  = 1
    #$doc.PageSetup.TopMargin    = 36
    #$doc.PageSetup.BottomMargin = 36
    #$doc.PageSetup.LeftMargin   = 36
    #$doc.PageSetup.RightMargin  = 36

    Write-Host "7. Exporting PDF..."
    $doc.ExportAsFixedFormat($outputFile, 17)

    if (-not (Test-Path -LiteralPath $outputFile -PathType Leaf)) {
        throw "Word returned without creating the PDF."
    }

    Write-Host "PDF exists: $outputFile"
}
catch {
    Write-Host ("ERROR: " + $_.Exception.Message) -ForegroundColor Red
    throw
}
finally {
    if ($null -ne $range) {
        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($range)
    }

    if ($null -ne $doc) {
        Write-Host "8. Closing document..."
        try {
            $doc.Close(0)
        }
        catch {
            Write-Warning $_.Exception.Message
        }
        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($doc)
    }

    if ($null -ne $word) {
        Write-Host "9. Quitting Word..."
        try {
            $word.Quit()
        }
        catch {
            Write-Warning $_.Exception.Message
        }
        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($word)
    }
}
Write-Host "Finished."
;;;;
%jnr_powershellEnd;

/**************************************************************************************************************************/
/* 8   Macros pwershell sandwich and utlfkil                                                                              */
/**************************************************************************************************************************/

/*--- SAVE JNR_POWERSHELLBEGIN.SAS IN AUTOCALL C:/OTOJNR ---*/
filename ft15f001 "c:/otojnr/jnr_powershellBegin.sas";
parmcards4;
%macro jnr_powershellBegin(
    resolve=Y
    )/des="No additional quote(backtic) because powershell needs it";

  %local pth;
  %let pth=%sysfunc(pathname(workx));

  %utlfkil(&pth/powershell_resolve.ps1);

  data _null_;
    length _infile_ $255;
    file "&pth/powershell_resolve.ps1";
    input;
    if upcase("&resolve")=:"Y" then _infile_=resolve(_infile_);
    put _infile_;
    putlog _infile_;

%mend jnr_powershellBegin;
;;;;
run;

/*--- SAVE JNR_POWERSHELLEND.SAS IN AUROCALL C:/OTOJNR ---*/
filename ft15f001 "c:/otojnr/jnr_powershellEnd.sas";
parmcards4;
%macro jnr_powershellEnd(
    return=
   )/des="execute powershell script";
run;
  %local pth;
  %let pth=%sysfunc(pathname(workx);
  filename rut pipe 'powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "d:\wpswrkx\powershell_resolve.ps1" 2>&1';
run;quit;
  run;quit;
  data _null_;
    infile rut;
    input;
    putlog _infile_;
    *ile print;
    *put _infile_;
  run;

  filename rut clear;

  * use the clipboard to create macro variable;
  %if "&return" ^= "" %then %do;
    filename clip clipbrd;
    data _null_;
     infile clip;  /*--- created from the SPSS script ---*/
     input;
     putlog "*******  " _infile_ "  ********";
     call symputx("&return",_infile_,"G");
    run;quit;
  %end;

%mend jnr_powershellEnd;
;;;;
run;

filename ft15f001 "c:/otojnr/utlfkil.sas";
parmcards4;
%macro utlfkil(file) / des="delete file if it exists";
  %if %sysfunc(fileexist(&file)) ge 1 %then %do;
    %let rc=%sysfunc(filename(temp,&file));
    %let rc=%sysfunc(fdelete(&temp));
  %end;
%else %put The file &file does not exist;
%mend utlfkil;
;;;;
run;

/*--- END ---*/

