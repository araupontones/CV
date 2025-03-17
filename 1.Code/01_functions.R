## Remove brackets in multiple select type of vars
cli::cli_h1("Loading utils")
remove_brakets <-  function(x){
  x <- str_remove_all(x,"\\[|\\]" ) ##remove brakets
  
}

##create a column for each multiple select (for use in dplyr)

split_multi_select = function(db, var, prefix, ...) {
  
  cols_how_many = max(sapply(strsplit(db[[var]], ","), length)) # count the maximum number of countries per project
  
  cols_names = sapply(1:cols_how_many, function(x)paste0(prefix,x)) ## create name of the new vars
  
  new_cols = str_split_fixed(db[[var]], ",", cols_how_many) %>% ## create the new columns 
    as.data.frame()
  
  names(new_cols) <- cols_names ## name the new colums
  
  new_db = cbind(db, new_cols)
  
  
  
}
