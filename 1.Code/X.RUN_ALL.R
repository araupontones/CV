scripts <- list.files("1.Code", pattern = ".R", full.names = T)

run_scripts <- lapply(scripts, function(script){
  
  if(script != "1.Code/X.RUN_ALL.R")
  source(script)
  
})


