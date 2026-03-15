#

if (!is_testing() && !is_checking()) {
  # x <- mtcars2 %>%
  #   mutate(am = fct_recode(am, "Yes" = "manual", "No" = "auto")) %>%
  #   apply_labels(am = "Manual transmission") %>%
  #   crosstable(c(mpg, am, hp), by = vs, test = T, effect = T)
  # crosstable(mtcars2, c(mpg, drat, wt, qsec), by=am) %>%
  #   t() %>% as_flextable(compact=FALSE)

  ct = crosstable(mtcars2, c(mpg, drat, wt, qsec), by=am) %>%
    t()
  ct %>% attributes
  ct %>% attr("transposed_id_labels")
  ct %>% attr("inner_labels")

  ct %>% as_flextable(compact=TRUE)
  ct %>% as_flextable(compact=F)

}
