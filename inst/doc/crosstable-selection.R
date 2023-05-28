## ---- include = FALSE-----------------------------------------------------------------------------
knitr::opts_chunk$set(
collapse = TRUE,
comment = "#>",
warning=FALSE, 
message=FALSE
)
old = options(width = 100)

## ----crosstable-bare------------------------------------------------------------------------------
library(crosstable)
ct = crosstable(iris2, everything()) #or simply `crosstable(iris2)`
ct %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-names-----------------------------------------------------------------------------
crosstable(mtcars2, c(mpg, "qsec"), by=vs) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-external--------------------------------------------------------------------------
qsec = c("mpg", "cyl") #wouldn't that be the most evil variable name ever?
crosstable(mtcars2, any_of(qsec), by=vs) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-negation--------------------------------------------------------------------------
crosstable(mtcars2, c(-mpg, -cyl, -1), by=vs) %>% head(8) %>% #-c(mpg, cyl, 1) would also work
  as_flextable(keep_id=TRUE)

## ----crosstable-indice----------------------------------------------------------------------------
crosstable(mtcars2, 2:4, by=vs) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-helpers1--------------------------------------------------------------------------
crosstable(mtcars2, starts_with("d")) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-helpers2--------------------------------------------------------------------------
crosstable(mtcars2, c(ends_with("g"), contains("yl"))) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-helpers3--------------------------------------------------------------------------
#to all regex haters: the following call selects all columns which name 
#starts with "d" or "g", followed by exactly 3 characters
crosstable(mtcars2, matches("^d|g.{3}$")) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-functions1------------------------------------------------------------------------
crosstable(mtcars2, c(where(is.character), where(is.factor), -model)) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-functions2------------------------------------------------------------------------
crosstable(mtcars2, where(function(x) is.numeric(x) && mean(x)>100)) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-formula1--------------------------------------------------------------------------
crosstable(mtcars2, mpg+cyl ~ vs) %>% 
  as_flextable(keep_id=TRUE)

## ----crosstable-formula2--------------------------------------------------------------------------
crosstable(mtcars2, sqrt(mpg) + I(qsec^2) ~ ifelse(mpg>20,"mpg>20","mpg<20"),
           label=FALSE) %>% 
  as_flextable()

## ----crosstable-ultimate1-------------------------------------------------------------------------
crosstable(mtcars2, c(where(is.numeric), -matches("^d|w"), drat), label=FALSE) %>% 
  as_flextable()

## ---- include = FALSE---------------------------------------------------------
options(old)

