
#' Get label if wanted and available, or default (name) otherwise
#'
#' @param x labelled object. If `x` is a list/data.frame, `get_label()` will return the labels of all children recursively
#' @param default value returned if there is no label. Default to `names(x)`.
#' @param object if `x` is a list/data.frame, `object=TRUE` will force getting the labels of the object instead of the children
#' @param simplify if `x` is a list and `object=FALSE`, simplify the result to a vector
#'
#' @return A character vector if `simplify==TRUE`, a list otherwise
#'
#' @author Dan Chaltiel
#' @export
#' @importFrom cli cli_abort
#' @importFrom purrr map map2
#' @importFrom rlang is_null
#' @seealso [set_label()], [import_labels()], [remove_label()], [Hmisc::label()], [expss::var_lab()]
#' @examples
#' xx=mtcars2 %>%
#'   set_label("The mtcars2 dataset", object=TRUE)
#' xx$cyl=remove_label(xx$cyl)
#'
#' #vectors
#' get_label(xx$mpg) #label="Miles/(US) gallon"
#' get_label(xx$cyl) #default to NULL (since names(xx$cyl)==NULL)
#' get_label(xx$cyl, default="Default value")
#'
#' #data.frames
#' get_label(xx)
#' get_label(xx, object=TRUE)
#' data.frame(name=names(xx), label=get_label(xx, default=NA)) #cyl is NA
#'
#' #lists
#' get_label(list(xx$cyl, xx$mpg))          #cyl is NA
#' get_label(list(foo=xx$cyl, bar=xx$mpg))  #default to names
#' get_label(list(foo=xx$cyl, bar=xx$mpg), default="Default value")
get_label = function(x, default=names(x), object=FALSE, simplify=TRUE){
  if(is.list(x) && !object){
    if(is.null(default)) default=rep(NA, length(x))
    if(length(default)>1 && length(x)!=length(default)) {
      cli_abort("`default` should be either length 1 or the same length as `x`",
                class="crosstable_labels_get_wrong_default_error")
    }
    lab = x %>%
      map(get_label) %>%
      map2(default, ~{if(is.null(.x)) .y else .x})
    if(simplify) lab = unlist(lab)
  } else {
    lab = attr(x, "label", exact=TRUE)
    if(is_null(lab) && length(default)==1) lab=default
  }

  lab
}



#' Set the "label" attribute of an object
#'
#' @param x object to label.
#' @param value value of the label. If `x` is a list/data.frame, the labels will all be set recursively. If `value` is a function, it will be applied to the current labels of `x`.
#' @param object if `x` is a list/data.frame, `object=TRUE` will force setting the labels of the object instead of the children
#'
#' @return An object of the same type as `x`, with labels
#'
#' @author Dan Chaltiel
#' @export
#' @importFrom checkmate assert_character
#' @importFrom cli cli_abort
#' @importFrom dplyr intersect
#' @importFrom purrr map_chr
#' @importFrom rlang as_function is_named is_formula is_function
#' @seealso [get_label()], [import_labels()], [remove_label()]
#' @examples
#' library(dplyr)
#' mtcars %>%
#'    mutate(mpg2=set_label(mpg, "Miles per gallon"),
#'           mpg3=mpg %>% copy_label_from(mpg2)) %>%
#'    crosstable(c(mpg, mpg2, mpg3))
#' mtcars %>%
#'    copy_label_from(mtcars2) %>%
#'    crosstable(c(mpg, vs))
#' mtcars2 %>% set_label(toupper) %>% get_label()
set_label = function(x, value, object=FALSE){
  if(is_formula(value)) value = as_function(value)
  if(is_function(value)) return(set_label(x, value(get_label(x))))
  if(is.null(value) || all(is.na(value))) return(x)
  value = map_chr(value, as.character)
  assert_character(value)
  if(is.list(x) && !object){
    if(length(value)==1){
      for (each in seq_along(x))
        x[[each]] = set_label(x[[each]], value)
    } else if(is_named(value)){
      for (each in intersect(names(value), names(x)))
        x[[each]] = set_label(x[[each]], value[[each]])
    }  else if(length(value)==length(x)){
      for (each in seq_along(x))
        x[[each]] = set_label(x[[each]], value[[each]])
    } else {
      cli_abort("{.arg value} must be named or must be either length 1 or the same as `x`")
      #TODO faire des tests pour ces deux nouvelles conditions !
    }
    return(x)
  }
  attr(x, "label") = value
  return(x)
}


#' Copy the label from one variable to another
#'
#' @param x the variable to label
#' @param from the variable whose label must be copied
#'
#' @rdname set_label
#' @author Dan Chaltiel
#' @export
copy_label_from = function(x, from){
  set_label(x, get_label(from))
}

#' Remove all label attributes.
#'
#' Use `remove_labels()` to remove the label from an object or to recursively remove all the labels from a collection of objects (such as a list or a data.frame). \cr \cr This can be useful with functions reacting badly to labelled objects.
#'
#' @param x object to unlabel
#'
#' @return An object of the same type as `x`, with no labels
#'
#' @author Dan Chaltiel
#' @export
#' @rdname remove_labels
#' @aliases remove_label
#' @seealso [get_label], [set_label], [import_labels], [expss::unlab]
#' @examples
#' mtcars2 %>% remove_labels %>% crosstable(mpg) #no label
#' mtcars2$hp %>% remove_labels %>% get_label() #NULL
remove_labels = function(x){
  if (is.null(x))
    return(x)
  if (is.list(x)) {
    for (each in seq_along(x))
      x[[each]] = remove_label(x[[each]])
    return(x)
  }
  attr(x, "label") = NULL
  class(x) = setdiff(class(x), c("labelled"))
  x
}

#' @rdname remove_labels
#' @aliases remove_labels
#' @param x object to unlabel
#' @usage NULL
#' @export
remove_label = remove_labels


#' Rename every column of a dataframe with its label
#'
#' @param df a data.frame
#' @param except <[`tidy-select`][tidyselect::language]> columns that should not be renamed.
#'
#' @return A dataframe which names are copied from the label attribute
#'
#' @importFrom checkmate assert_data_frame
#' @importFrom dplyr rename_with select
#' @importFrom rlang enexpr as_string
#' @author Dan Chaltiel
#' @export
#' @source https://stackoverflow.com/q/75848408/3888000
#'
#' @examples
#' rename_with_labels(mtcars2[,1:5], except=5) %>% names()
#' rename_with_labels(iris2, except=Sepal.Length) %>% names()
#' rename_with_labels(iris2, except=starts_with("Pet")) %>% names()
rename_with_labels = function(df, except=NULL){
  if(is.null(df)) return(NULL)
  assert_data_frame(df)
  except = enexpr(except)
  if((!is.numeric(except)) && length(as.list(except))== 1){
    except = as_string(except)
  }
  nm = setdiff(names(df), names(select(df, any_of({{except}}))))
  rename_with(df, ~get_label(df)[.x], all_of(nm))
}

#' @export
#' @rdname rename_with_labels
#' @usage NULL
#' @importFrom lifecycle deprecate_warn
rename_dataframe_with_labels=function(df, except=NULL){
  deprecate_warn("0.5.0", "rename_dataframe_with_labels()", "rename_with_labels()")
  rename_with_labels(df, except)
}




#' Cleans names of a dataframe while retaining old names as labels
#'
#' @param df a data.frame
#' @param except <[`tidy-select`][tidyselect::language]> columns that should not be renamed.
#' @param .fun the function used to clean the names. Default function is limited; if the cleaning is not good enough you could use janitor::make_clean_names()
#'
#' @return A dataframe with clean names and label attributes
#' @author Dan Chaltiel
#' @export
#'
#' @examples
#' #options(crosstable_clean_names_fun=janitor::make_clean_names)
#' x = data.frame("name with space"=1, TwoWords=1, "total $ (2009)"=1, àccénts=1,
#'                check.names=FALSE)
#' cleaned = clean_names_with_labels(x, except=TwoWords)
#' cleaned %>% names()
#' cleaned %>% get_label()
#' @importFrom checkmate assert_data_frame
#' @importFrom dplyr rename_with select
clean_names_with_labels = function(df, except=NULL, .fun=getOption("crosstable_clean_names_fun")){
  assert_data_frame(df, null.ok=TRUE)
  if(is.null(.fun)) .fun=crosstable_clean_names

  except = names(select(df, {{except}}))
  df %>%
    rename_with(~ifelse(.x %in% except, .x, .fun(.x))) %>%
    set_label(names(df))
}




#' Batch set variable labels
#'
#' This function is a copycat of from expss package v0.10.7 (slightly modified) to avoid having to depend on expss. See [expss::apply_labels()] for more documentation. Note that this version is not compatible with `data.table`.
#'
#' @param data data.frame/list
#' @param ... named arguments
#' @param warn_missing if TRUE, throw a warning if some names are missing
#'
#' @return An object of the same type as `data`, with labels
#'
#' @importFrom cli cli_warn
#' @importFrom rlang current_env
#' @author Dan Chaltiel
#' @export
#'
#' @examples
#' iris %>%
#'   apply_labels(Sepal.Length="Length of Sepal",
#'                Sepal.Width="Width of Sepal") %>%
#'   crosstable()
apply_labels = function(data, ..., warn_missing=FALSE) {
  args = lst(...)
  unknowns = setdiff(names(args), names(data))
  if (length(unknowns) && warn_missing) {
    cli_warn("Cannot apply a label to unknown column{?s} in `data`: {.var {unknowns}}",
             class="crosstable_missing_label_warning",
             call=current_env())
  }

  data %>%
    mutate(across(everything(),
                  ~set_label(.x, args[[cur_column()]])))
}


#' Import labels
#'
#' `import_labels` imports labels from a data.frame (`data_label`) to another one (`.tbl`). Works in synergy with [save_labels()].
#'
#' @param .tbl the data.frame to be labelled
#' @param data_label a data.frame from which to import labels. If missing, the function will take the labels from the last dataframe on which [save_labels()] was called.
#' @param name_from in `data_label`, which column to get the variable name (default to `name`)
#' @param label_from in `data_label`, which column to get the variable label (default to `label`)
#' @param warn_name if TRUE, displays a warning if a variable name is not found in `data_label`
#' @param warn_label if TRUE, displays a warning if a label is not found in `.tbl`
#' @param verbose deprecated
#'
#' @return A dataframe, as `.tbl`, with labels
#'
#' @author Dan Chaltiel
#' @export
#' @importFrom cli cli_abort cli_warn
#' @importFrom dplyr all_of select
#' @importFrom lifecycle deprecate_warn deprecated is_present
#' @importFrom rlang current_env
#' @importFrom tibble column_to_rownames
#' @importFrom tidyr drop_na
#'
#' @seealso [get_label()], [set_label()], [remove_label()], [save_labels()]
#' @examples
#' #import the labels from a data.frame to another
#' iris_label = data.frame(
#'   name=c("Sepal.Length", "Sepal.Width",
#'          "Petal.Length", "Petal.Width", "Species"),
#'   label=c("Length of Sepals", "Width of Sepals",
#'           "Length of Petals", "Width of Petals", "Specie name")
#' )
#' iris %>%
#'   import_labels(iris_label) %>%
#'   crosstable
#'
import_labels = function(.tbl, data_label,
                         name_from = "name", label_from = "label",
                         warn_name = FALSE, warn_label = FALSE,
                         verbose=deprecated()){
  force(.tbl)

  if(is_present(verbose)) {
    deprecate_warn("0.2.0", "import_labels(verbose=)",
                   details = "Please use the `warn_name` or the `warn_label` argument instead.")
    if(isTRUE(verbose)) warn_name=warn_label=TRUE
  }

  if(missing(data_label)){
    data_label = get_last_save()
    if(is.null(data_label)) {
      cli_abort("There is no saved labels. Did you forget `data_label` or calling `save_labels()`?",
                class="crosstable_labels_import_null_error")
    }
  }

  if(!name_from %in% names(data_label) || !label_from %in% names(data_label)){
    cli_abort(c('`data_label` should have a column named `{name_from}` and a column named `{label_from}`.',
                i="`names(data_label)`: {.var {names(data_label)}}"),
              class="crosstable_labels_import_missing_col")
  }

  duplicates = data_label$name[duplicated(data_label$name)]
  if(length(duplicates)>0){
    cli_abort('Cannot identify a label uniquely because of duplicated name{?s} in `data_label`: {.var {duplicates}}',
              class="crosstable_labels_import_dupkey_error")
  }

  no_label = names(.tbl)[!names(.tbl) %in% data_label$name]
  if(length(no_label)>0 && warn_name){
    cli_warn("Cannot find any label in `data_label` for variable{?s}: {.var {no_label}}",
             class="crosstable_missing_label_warning",
             call=current_env())
  }

  not_found = data_label$name[!data_label$name %in% names(.tbl)]
  if(length(not_found)>0 && isTRUE(warn_label)){
    cli_warn('Some name{?s} in `data_label` are absent in `.tbl`: {.var {not_found}}.',
             class="crosstable_missing_label_name_warning",
             call=current_env())
  }

  data_label = as.data.frame(data_label) %>%
    select(all_of(c(name_from, label_from))) %>%
    drop_na() %>%
    column_to_rownames(name_from)

  .tbl %>% mutate(across(everything(), ~{
    label = data_label[cur_column(), label_from]
    set_label(.x, label)
  }))
}

#' @rdname import_labels
#' @description `save_labels` saves the labels from a data.frame in a temporary variable that can be retrieve by `import_labels`.
#' @return `.tbl` invisibly. Used only for its side effects.
#' @author Dan Chaltiel
#' @export
#' @examples
#' #save the labels, use some dplyr label-removing function, then retrieve the labels
#' library(dplyr)
#' mtcars2 %>%
#'   save_labels() %>%
#'   transmute(disp=as.numeric(disp)+1) %>%
#'   import_labels(warn_label=FALSE) %>% #
#'   crosstable(disp)
#' @importFrom tibble tibble
save_labels = function(.tbl){
  labels_env$last_save = tibble(
    name=names(.tbl),
    label=get_label(.tbl)[.data$name]
  )
  invisible(.tbl)
}


# utils -------------------------------------------------------------------


# labels_env = rlang::new_environment()
labels_env = rlang::env()

#' @keywords internal
#' @noRd
get_last_save = function(){
  labels_env$last_save
}

#' @keywords internal
#' @noRd
remove_last_save = function(){
  labels_env$last_save = NULL
  invisible()
}
