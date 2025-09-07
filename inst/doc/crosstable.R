## ----options, include = FALSE---------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning=FALSE, 
  message=FALSE
)
old = options(width = 100, 
              crosstable_verbosity_autotesting="quiet")
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
  name  label
  model 'Model'
  mpg   'Miles/(US) gallon'
  cyl   'Number of cylinders'
  disp  'Displacement (cu.in.)'
  hp    'Gross horsepower'
  drat  'Rear axle ratio'
  wt    'Weight (1000 lbs)'
  qsec  '1/4 mile time'
  vs    'Engine'
  am    'Transmission'
  gear  'Number of forward gears'
  carb  'Number of carburetors'
")
mtcars2 = mtcars %>% 
  mutate(model=rownames(mtcars), 
         vs=ifelse(vs==0, "vshaped", "straight"),
         am=ifelse(am==0, "auto", "manual"), 
         across(c("cyl", "gear"), factor),
         .before=1) %>% 
  import_labels(mtcars_labels, name_from="name", label_from="label") %>% 
  as_tibble()
#I also could have used `labelled::set_variable_labels()` to add labels

## ----crosstable-flextable-------------------------------------------------------------------------
crosstable(mtcars2, c(mpg, cyl), by=am) %>%
  as_flextable(keep_id=TRUE)

## ----crosstable-total-both------------------------------------------------------------------------
#of course, the total of a "column" in only meaningful for categorical variables.
crosstable(mtcars2, c(am, mpg), by=vs, total="both") %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-categorical-----------------------------------------------------------------------
mtcars3 = mtcars2
mtcars3$cyl[1:5] = NA
crosstable(mtcars3, c(am, cyl), by=vs, showNA="always", 
           percent_digits=0, percent_pattern="{n} ({p_col}/{p_row})") %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-functions-------------------------------------------------------------------------
crosstable(mtcars2, c(mpg, wt), funs=c("mean"=mean, "std dev"=sd, q1=~quantile(.x, prob=0.25))) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-correlation-----------------------------------------------------------------------
library(survival)
crosstable(mtcars2, where(is.numeric), cor_method="pearson", by=mpg) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-survival--------------------------------------------------------------------------
library(survival)
aml$surv = Surv(aml$time, aml$status)
crosstable(aml, surv, by=x, times=c(0,50,150), followup=TRUE) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-dates-----------------------------------------------------------------------------
mtcars2$x_date = as.Date(mtcars2$hp , origin="2010-01-01") %>% set_label("Date")
mtcars2$x_posix = as.POSIXct(mtcars2$qsec*3600*24 , origin="2010-01-01") %>% set_label("Date+time")
crosstable(mtcars2, c(x_date, x_posix), date_format="%d/%m/%Y") %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-dates2----------------------------------------------------------------------------
crosstable(mtcars2, c(x_date, x_posix), funs=meansd, funs_arg=list(date_unit="days")) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-effect----------------------------------------------------------------------------
crosstable(mtcars2, c(vs, qsec), by=am, funs=mean, effect=TRUE) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-tests-----------------------------------------------------------------------------
library(flextable)
crosstable(mtcars2, c(vs, qsec), by=am, funs=mean, test=TRUE) %>% 
  as_flextable(keep_id=TRUE)

## ----include = FALSE------------------------------------------------------------------------------
options(old)

