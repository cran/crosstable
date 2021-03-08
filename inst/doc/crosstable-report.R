## ----init, include = FALSE----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(crosstable)
library(dplyr)

## ----officer, message=FALSE, warning=FALSE------------------------------------
library(officer)
library(ggplot2)
ct1=crosstable(iris, by=Species, test=TRUE)
ct2=crosstable(mtcars2, c(mpg,cyl,disp), by=am, effect=TRUE, total="both", showNA="always")
ct3=crosstable(esoph)
options(crosstable_units="cm")

my_plot = ggplot(data = iris ) +
  geom_point(mapping = aes(Sepal.Length, Petal.Length))

doc = read_docx() %>% 
  body_add_title("Dataset iris", 1) %>%
  body_add_title("Not compacted", 2) %>%
  body_add_normal("Table \\@ref(table_autotest) is an example. However, automatic testing is bad and I should feel bad.") %>%
  body_add_crosstable(ct1) %>%
  body_add_table_legend("Automatic testing is bad", bookmark="table_autotest") %>%
  body_add_normal("Let's add a figure as well. You can see in Figure \\@ref(fig_iris) that sepal length is somehow correlated with petal length.") %>%
  body_add_figure_legend("Relation between Petal length and Sepal length", bookmark="fig_iris") %>% 
  body_add_gg2(my_plot, w=14, h=10, scale=1.5) %>% 
  body_add_title("Compacted", 2) %>%
  body_add_normal("When compacting, you might want to remove the test names.") %>%
  body_add_crosstable(ct1, compact=TRUE, show_test_name=FALSE) %>%
  body_add_break() %>%
  body_add_title("Dataset mtcars2", 1) %>%
  body_add_normal("This dataset has {nrow(ct3)} rows and {x} columns.", x=ncol(ct3)) %>%
  body_add_normal("Look, there are labels!") %>%
  body_add_crosstable(ct2, compact=TRUE) %>%
  body_add_break() %>%
  body_add_title("Dataset esoph", 1) %>%
  body_add_normal("This one was compacted beforehand for some reason.") %>%
  body_add_crosstable(compact(ct3))

## ----save, include=FALSE------------------------------------------------------
# stop("Working directory = ", getwd())
if(file.exists("../examples"))
  print(doc, "../examples/vignette_officer.docx")

## ----print, eval=FALSE--------------------------------------------------------
#  filename=file.path("..", "examples", "vignette_officer.docx", fsep="\\")#`\\` is needed for shell.exec on Windows
#  print(doc, filename) #write the docx file
#  shell.exec(filename) #open the docx file (fails if it is already open)

