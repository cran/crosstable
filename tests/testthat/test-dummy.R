# f = function(data, cols=everything(), ..., by=NULL,
#                       total = c("none", "row", "column", "both"),
#                       percent_pattern = "{n} ({p_row})",
#                       percent_digits = 2, num_digits = 1,
#                       showNA = c("ifany", "always", "no"), label = TRUE,
#                       funs = c(" " = cross_summary), funs_arg=list(),
#                       cor_method = c("pearson", "kendall", "spearman"),
#                       drop_levels = FALSE,
#                       unique_numeric = 3, date_format=NULL,
#                       times = NULL, followup = FALSE,
#                       test = FALSE, test_args = crosstable_test_args(),
#                       effect = FALSE, effect_args = crosstable_effect_args(),
#                       margin = deprecated(),
#                       .vars = deprecated()) {
#   dataCall = deparse(substitute(data))
#   # Deprecations --------------------------------------------------------
#   if(!missing(...)){
#     cols_length = length(enexpr(cols))
#     if(cols_length==1) colsCall = as.character(enexpr(cols))
#     else colsCall = enexpr(cols) %>% as.list() %>% map(as.character) %>% discard(~.x=="c") %>% paste(collapse=", ")
#     dotsCall = enexprs(...) %>% as.list() %>% map(as.character) %>% paste(collapse=", ")
#
#     goodcall = c(colsCall, dotsCall) %>% paste(collapse=", ")
#     bad = glue("`crosstable({dataCall}, {colsCall}, {dotsCall}, ...)`")
#     good = glue("`crosstable({dataCall}, c({goodcall}), ...)`")
#     deprecate_warn("0.2.0", "crosstable(...=)", "crosstable(cols=)",
#                    details=glue("Instead of {bad}, write {good}"))
#   }
#   1
# }
#
#
# # f(mtcars2, c(am, cyl), hp, by=vs)
# # crosstable(mtcars2, c(am, cyl), hp, by=vs)
#
# # lifecycle::expect_deprecated(f(mtcars2, c(am, cyl), hp, by=vs))
