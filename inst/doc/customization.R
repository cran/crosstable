## ----include = FALSE------------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup----------------------------------------------------------------------------------------
library(crosstable)
crosstable_options(compact=TRUE, keep_id=TRUE)

## ----numerics-------------------------------------------------------------------------------------
crosstable_options(funs=c("mean"=mean, "std dev"=sd, qtl=~quantile(.x, prob=c(0.25, 0.75))))
crosstable(mtcars2, mpg) %>% as_flextable()

## ----numerics2------------------------------------------------------------------------------------
f = function(x) c("Mean (SD)"=meansd(x), "Med [IQR]"=mediqr(x))
crosstable(mtcars2, wt, funs=f) %>% as_flextable()
crosstable(mtcars2, wt, funs=c(" "=f)) %>% as_flextable()

## ----effect-default-------------------------------------------------------------------------------
mtcars2 %>% 
  crosstable(am, by=vs, effect=TRUE) %>% 
  as_flextable()

## ----effect-custom--------------------------------------------------------------------------------
ct_effect_prop_diff = function(x, by, conf.level){
  tb = table(x, by) 
  test = prop.test(tb, conf.level=conf.level)
  nms = dimnames(tb)[["x"]] 
  effect = diff(test$estimate)
  effect.type = "Difference of proportions"
  reference = glue::glue(", {nms[1]} vs {nms[2]}")
  summary = data.frame(name = "Proportion difference", effect, 
                       ci_inf = test$conf.int[1], 
                       ci_sup = test$conf.int[2])
  list(summary = summary, ref = reference, effect.type = effect.type)
}
my_effect_args = crosstable_effect_args(effect_tabular=ct_effect_prop_diff)
  
# crosstable_options(effect_args=my_effect_args) #set globally if desired
mtcars2 %>% 
  crosstable(am, by=vs, effect=TRUE, effect_args=my_effect_args) %>% 
  as_flextable()

## ----test-custom----------------------------------------------------------------------------------
ct_test_lm = function(x, by){
  fit = lm(x ~ by)
  pval = anova(fit)$`Pr(>F)`[1]
  list(p.value = pval, method = "Linear model ANOVA")
}
my_test_args = crosstable_test_args(test_summarize=ct_test_lm)
  
# crosstable_options(test_args=my_test_args) #set globally if desired
mtcars2 %>% 
  crosstable(mpg, by=vs, test=TRUE, test_args=my_test_args) %>% 
  as_flextable()

