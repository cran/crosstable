## ----options, include = FALSE---------------------------------------------------------------------
  knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning=FALSE, 
  message=FALSE
  )
  options(width = 100)
  library(flextable)

## ----css, echo=FALSE, results="asis"--------------------------------------------------------------
cat("
<style>
kbd {
    background-color: #eee;
    border-radius: 3px;
    border: 1px solid #b4b4b4;
    box-shadow: 0 1px 1px rgba(0, 0, 0, .2), 0 2px 0 0 rgba(255, 255, 255, .7) inset;
    color: #333;
    display: inline-block;
    font-size: .85em;
    font-weight: 700;
    line-height: 1;
    padding: 2px 4px;
    white-space: nowrap;
}
</style>
")

## ----dataset--------------------------------------------------------------------------------------
library(crosstable)
library(dplyr)
mtcars_labels = read.table(header=TRUE, text="
  name label
  mpg  'Miles/(US) gallon'
  cyl  'Number of cylinders'
  disp 'Displacement (cu.in.)'
  hp   'Gross horsepower'
  drat 'Rear axle ratio'
  wt   'Weight (1000 lbs)'
  qsec '1/4 mile time'
  vs   'Engine'
  am   'Transmission'
  gear 'Number of forward gears'
  carb 'Number of carburetors'
")
mtcars2 = mtcars %>% 
  mutate(vs=ifelse(vs==0, "vshaped", "straight"),
         am=ifelse(am==0, "auto", "manual")) %>% 
  mutate_at(c("cyl", "gear"), factor) %>% 
  import_labels(mtcars_labels, name_from="name", label_from="label") 
#I also could have used `Hmisc::label` or `expss::apply_labels` to add labels

## ----crosstable-bare------------------------------------------------------------------------------
crosstable(mtcars2) %>% head(11)

## ----crosstable-args, tidy=TRUE-------------------------------------------------------------------
crosstable(mtcars2, mpg, cyl, by=am)

## ----crosstable-flextable-------------------------------------------------------------------------
crosstable(mtcars2, mpg, cyl, by=am) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-functions-------------------------------------------------------------------------
crosstable(mtcars2, am, mpg, wt, by=vs, funs=c(median, mean, sd)) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-percent-row-----------------------------------------------------------------------
crosstable(mtcars2, am, mpg, by=vs, funs=meansd, margin="row") %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-percent-column--------------------------------------------------------------------
crosstable(mtcars2, am, mpg, by=vs, funs=meansd, margin="column") %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-percent-none----------------------------------------------------------------------
crosstable(mtcars2, am, mpg, by=vs, funs=meansd, margin="none") %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-percent-both----------------------------------------------------------------------
#I also could have used margin="all" here
crosstable(mtcars2, am, mpg, by=vs, funs=meansd, margin=c("column","row","cell")) %>% 
  as_flextable(keep_id=TRUE) 

## ----crosstable-total-row-------------------------------------------------------------------------
crosstable(mtcars2, am, mpg, by=vs, funs=mean, total="row") %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-total-column----------------------------------------------------------------------
#of course, total="column" only has an effect on categorical variables.
crosstable(mtcars2, am, mpg, by=vs, funs=mean, total="column") %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-total-both------------------------------------------------------------------------
crosstable(mtcars2, am, mpg, by=vs, funs=mean, total="both") %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-tests-----------------------------------------------------------------------------
library(flextable)
crosstable(mtcars2, vs, qsec, by=am, funs=mean, test=TRUE) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-effect----------------------------------------------------------------------------
library(flextable)
crosstable(mtcars2, vs, qsec, by=am, funs=mean, effect=TRUE) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-dates-----------------------------------------------------------------------------
mtcars2$x_date = as.Date(mtcars2$hp , origin="2010-01-01") %>% set_label("Date")
mtcars2$x_posix = as.POSIXct(mtcars2$qsec*3600*24 , origin="2010-01-01") %>% set_label("Date+time")
crosstable(mtcars2, x_date, x_posix) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-dates2----------------------------------------------------------------------------
crosstable(mtcars2, x_date, x_posix, by=vs, date_format="%d/%m/%Y", funs_arg = list(date_unit="days")) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-correlation-----------------------------------------------------------------------
library(survival)
crosstable(mtcars2, where(is.numeric), by=mpg) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-survival--------------------------------------------------------------------------
library(survival)
aml$surv = Surv(aml$time, aml$status)
crosstable(aml, surv, by=x, times=c(0,15,30,150), followup=TRUE) %>% 
  as_flextable(keep_id=TRUE)

