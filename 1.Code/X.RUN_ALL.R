scripts <- list.files("1.Code", pattern = ".R", full.names = T)

run_scripts <- lapply(scripts, function(script){
  
  source(script)
  
})
