
<!-- README.md is generated from README.Rmd. Please edit that file -->

# crosstable <a href='https://DanChaltiel.github.io/crosstable/'><img src='man/figures/hex_sticker_v2.png' align="right" height="175" /></a>

<!-- badges: start -->

[![Package-License](http://img.shields.io/badge/license-GPL--3-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-3.0.html)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![CRAN
status](https://www.r-pkg.org/badges/version/crosstable)](https://CRAN.R-project.org/package=crosstable)
[![CRAN RStudio mirror
downloads](https://cranlogs.r-pkg.org/badges/grand-total/crosstable?color=blue)](https://r-pkg.org/pkg/crosstable)
[![Last
Commit](https://img.shields.io/github/last-commit/DanChaltiel/crosstable)](https://github.com/DanChaltiel/crosstable)
[![Codecov test
coverage](https://codecov.io/gh/DanChaltiel/crosstable/branch/master/graph/badge.svg)](https://app.codecov.io/gh/DanChaltiel/crosstable?branch=master)
[![R build
status](https://github.com/DanChaltiel/crosstable/workflows/R-CMD-check/badge.svg)](https://github.com/DanChaltiel/crosstable/actions)
<!-- [![Dependencies](https://tinyverse.netlify.com/badge/crosstable)](https://cran.r-project.org/package=crosstable)  -->
<!-- [![Build Status](https://travis-ci.org/DanChaltiel/crosstable.svg?branch=master)](https://travis-ci.org/DanChaltiel/crosstable) -->
<!-- badges: end -->

Crosstable is a package centered on a single function, `crosstable`,
which easily computes descriptive statistics on datasets. It can use the
`tidyverse` syntax and is interfaced with the package `officer` to
create automatized reports.

## Installation

``` r
# Install last version available on CRAN (v0.2.2)
install.packages("crosstable")

# Install development version on Github
devtools::install_github("DanChaltiel/crosstable", build_vignettes=TRUE)

# Install specific version (for reproducibility purpose)
devtools::install_github("DanChaltiel/crosstable@v0.2.2-CRAN", build_vignettes=TRUE) #last tag
devtools::install_github("DanChaltiel/crosstable@ff4aaae", build_vignettes=TRUE) #last commit
```

Note that, for reproducibility purpose, an even better solution would be
to use [`renv`](https://rstudio.github.io/renv/articles/renv.html).

## Getting help and giving feedback

You can find the whole documentation on the [dedicated
website](https://danchaltiel.github.io/crosstable/).

Besides, you can also use the vignettes:

-   `vignette("crosstable")` for global use and parameterization
-   `vignette("crosstable-selection")` for variable selection
-   `vignette("crosstable-report")` for reporting with `officer` or
    `Rmarkdown`

If you miss any feature that you think would belong in `{crosstable}`,
please fill a [Feature
Request](https://github.com/DanChaltiel/crosstable/issues/new/choose)
issue.

In case of any installation problem, try the solutions proposed in [this
article](https://danchaltiel.github.io/crosstable/articles/crosstable-install.html)
or fill a [Bug
Report](https://github.com/DanChaltiel/crosstable/issues/new/choose)
issue.

## Overview

``` r
library(crosstable)
library(dplyr)
ct1 = crosstable(mtcars2, c(disp, vs), by=am, margin=c("row", "col"), total="both") %>%
  as_flextable()
```

<p align="center">
<img src="man/figures/ct1_mod.png" alt="crosstable1">
</p>

With only a few arguments, you can select which column to describe
(`c(disp, vs)`), define a grouping variable (`by=am`), set the
percentage calculation in row/column (`margin=`) and ask for totals
(`total=`).

`mtcars2` is a dataset which has labels, so they are displayed instead
of the variable name (see
[here](https://danchaltiel.github.io/crosstable/articles/crosstable.html#dataset-modified-mtcars)
for how to add some).

`crosstable` is returning a plain R object (`data.frame`), but using
`as_flextable` allows to output a beautiful HTML table that can be
exported to Word with a few more lines of code (see
[here](https://danchaltiel.github.io/crosstable/articles/crosstable-report.html)
to learn how).

Here is a more advanced example:

``` r
ct2 = crosstable(mtcars2, c(starts_with("c"), ends_with("t")), by=c(am, vs), label=FALSE,
                 funs=c(mean, quantile), funs_arg=list(probs=c(.25,.75), digits=3)) %>% 
  as_flextable(compact=TRUE)
```

<p align="center">
<img src="man/figures/ct2_mod.png" alt="crosstable2" height="500">
</p>

Here, the variables were selected using `tidyselect` helpers and the
summary functions `mean` and `quantile` were specified, along with
argument `probs` for the latter. Using `label=FALSE` allowed to see
which variables were selected but it is best to keep the labels in the
final table. In `as_flextable()`, the `compact=TRUE` option yields a
longer output, which may be more suited in some contexts, for instance
for publication.

## More

There are lots of other features you can learn about on the website
[https://danchaltiel.github.io/crosstable](https://danchaltiel.github.io/crosstable/),
for instance:

-   variable selection with functions, e.g. `is.numeric`
    ([link](https://danchaltiel.github.io/crosstable/articles/crosstable-selection.html#select-with-predicate-functions))
-   variable selection with mutating, e.g. `sqrt(mpg)` or
    `Surv(time, event)`, using a formula interface
    ([link](https://danchaltiel.github.io/crosstable/articles/crosstable-selection.html#select-with-a-formula))
-   automatic computation of statistical tests
    ([link](https://danchaltiel.github.io/crosstable/articles/crosstable.html#tests))
    and of effect sizes
    ([link](https://danchaltiel.github.io/crosstable/articles/crosstable.html#effects))
-   global options to avoid repeating arguments
    ([link](https://danchaltiel.github.io/crosstable/reference/crosstable_options.html))
-   description of correlation, dates, and survival data
    ([link](https://danchaltiel.github.io/crosstable/articles/crosstable.html#miscellaneous-1))
-   auto-reporting with `officer`
    ([link](https://danchaltiel.github.io/crosstable/articles/crosstable-report.html#create-reports-with-officer))
    or with `Rmarkdown`
    ([link](https://danchaltiel.github.io/crosstable/articles/crosstable-report.html#create-reports-with-rmarkdown))

## Acknowledgement

`crosstable` was initially based on the awesome package
[`biostat2`](https://github.com/eusebe/biostat2) written by David
Hajage. Thanks David!
