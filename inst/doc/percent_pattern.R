## ----include = FALSE------------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning=FALSE, 
  message=FALSE
)
old = options(width = 100)

## ----setup----------------------------------------------------------------------------------------
library(crosstable)
mtcars3 = mtcars2
mtcars3$cyl[1:5] = NA
mtcars3$vs[5:12] = NA

crosstable_options(
  percent_digits=0
)

## ----Default behaviour----------------------------------------------------------------------------
crosstable(mtcars3, cyl, by=vs) %>% as_flextable()

## ----Allowed variables----------------------------------------------------------------------------
crosstable(mtcars3, cyl, by=vs, 
           percent_pattern="N={n}/{n_row} -> p={p_row}") %>% 
  as_flextable()

## ----Proportions in totals 1----------------------------------------------------------------------
crosstable(mtcars3, cyl, by=vs, total=TRUE, 
           percent_pattern="N={n}, p={p_row} ({n}/{n_row})") %>% 
  as_flextable()

## ----Proportions in totals 2----------------------------------------------------------------------
pp = list(body="N={n}, p={p_tot} ({n}/{n_tot})", 
          total_row="N={n} p=({p_col})", 
          total_col="{n}", total_all="Total={n}")
crosstable(mtcars3, cyl, by=vs, total=TRUE, 
           percent_pattern=pp) %>% 
  as_flextable()


## ----get_percent_pattern--------------------------------------------------------------------------
get_percent_pattern("all")
get_percent_pattern("col", na=TRUE)

## ----Ultimate example-----------------------------------------------------------------------------
ULTIMATE_PATTERN=list(
  body="N={n}
        Cell: p = {p_tot} ({n}/{n_tot}) [{p_tot_inf}; {p_tot_sup}]
        Col: p = {p_col} ({n}/{n_col}) [{p_col_inf}; {p_col_sup}]
        Row: p = {p_row} ({n}/{n_row}) [{p_row_inf}; {p_row_sup}]
        
        Cell (NA): p = {p_tot_na} ({n}/{n_tot_na}) [{p_tot_na_inf}; {p_tot_na_sup}]
        Col (NA): p = {p_col_na} ({n}/{n_col_na}) [{p_col_na_inf}; {p_col_na_sup}]
        Row (NA): p = {p_row_na} ({n}/{n_row_na}) [{p_row_na_inf}; {p_row_na_sup}]",
  total_row="N={n}
             Row: p = {p_row} ({n}/{n_row}) [{p_row_inf}; {p_row_sup}]
             Row (NA): p = {p_row_na} ({n}/{n_row_na}) [{p_row_na_inf}; {p_row_na_sup}]",
  total_col="N={n}
             Col: p = {p_col} ({n}/{n_col}) [{p_col_inf}; {p_col_sup}]
             Col (NA): p = {p_col_na} ({n}/{n_col_na}) [{p_col_na_inf}; {p_col_na_sup}]",
  total_all="N={n}
             P: {p_col} [{p_col_inf}; {p_col_sup}]
             P (NA): {p_col} [{p_col_na_inf}; {p_col_na_sup}]"
)

crosstable(mtcars3, cyl, by=vs,
           percent_digits=0, total=TRUE, showNA="always",
           percent_pattern=ULTIMATE_PATTERN) %>% 
  as_flextable() %>% 
  flextable::theme_box()

## ----include = FALSE------------------------------------------------------------------------------
options(old)

