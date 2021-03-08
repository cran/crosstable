## ---- include = FALSE-----------------------------------------------------------------------------
knitr::opts_chunk$set(
collapse = TRUE,
comment = "#>",
warning=FALSE, 
message=FALSE
)
options(width = 100)

## ----crosstable-bare------------------------------------------------------------------------------
library(crosstable)
library(dplyr)
ct=crosstable(mtcars2, everything())
dim(ct)
ct %>% head(10) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-names-----------------------------------------------------------------------------
crosstable(mtcars2, mpg, by=vs) %>% 
  as_flextable(keep_id=TRUE)
crosstable(mtcars2, "qsec", by="am") %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-external--------------------------------------------------------------------------
qsec=c("mpg", "cyl") #well, that's quite a bad variable name...
crosstable(mtcars2, any_of(qsec), by=vs) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-negation--------------------------------------------------------------------------
crosstable(mtcars2, -mpg, by=vs) %>% head(7) %>% 
  as_flextable(keep_id=TRUE)
crosstable(mtcars2, -mpg, -cyl, by=vs) %>% head(8) %>% 
  as_flextable(keep_id=TRUE)
crosstable(mtcars2, -c(mpg, cyl), by=vs) %>% head(8) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-indice----------------------------------------------------------------------------
crosstable(mtcars2, 1:3, by=vs) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-helpers---------------------------------------------------------------------------
crosstable(mtcars2, starts_with("d")) %>% 
  as_flextable(keep_id=TRUE)
crosstable(mtcars2, ends_with("g"), contains("yl")) %>% 
  as_flextable(keep_id=TRUE)
#for regex haters, the following call selects all columns which name starts with "d" or "g", followed by exactly 3 characters
crosstable(mtcars2, matches("^d|g.{3}$")) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-functions1------------------------------------------------------------------------
crosstable(mtcars2, where(is.numeric)) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-functions2------------------------------------------------------------------------
crosstable(mtcars2, function(x) is.numeric(x) && mean(x)>100) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-formula1--------------------------------------------------------------------------
crosstable(mtcars2, mpg+cyl ~ vs) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-formula2--------------------------------------------------------------------------
crosstable(mtcars2, sqrt(mpg) + I(qsec^2) ~ ifelse(mpg>20,"mpg>20","mpg<20"),
           label=FALSE) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-ultimate1-------------------------------------------------------------------------
crosstable(mtcars2, where(is.numeric), -matches("^d|w"), drat, label=FALSE) %>% 
  as_flextable()

