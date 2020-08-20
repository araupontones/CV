
## Load libraries and functions
source("1.Code/00_set_up.R")
source("1.Code/00_secret.R")




#set parameters for query =====================================================================================================

base = "https://creator.zoho.com/api/json/cv/view/"
user = "araupontones@gmail.com"
password = password
token  = token
scope = "creatorapi"

#reports to download
reports = c("All_Projects")

#Function to get the data ======================================================================================================
get_data = function(l) {
  
  link = paste0(base, l) # creates the link 
  r = GET(link, query = list(
    authtoken = token ,
    scope = scope ,
    zc_ownername = "araupontones"
    
    
  ))
  
  print(l)
  text = content(r,"text") #transform report to text
  
  text = content(r,"text")
  text2 = str_remove(text,"var zohoaraupontonesview[0-9][0-9] = ") #this line is blocking from parsing 
  text2 = str_remove(text2,";$") #this semicolon is also blocking from parsing
  
  
  jason = fromJSON(text2, flatten = T, bigint_as_char=TRUE) # parse to json
  p = as.data.frame(jason[1]) #Finally to a dataset 
  
  
  col_old = colnames(p) #clean names (all variables have a prefixx with the name of the table)
  col_new = str_remove_all(col_old,".+(?=\\.)\\.")
  colnames(p) = col_new
  
  
  return(p)
  
  
}



my_datas = purrr::map(reports, get_data)   #reports is created in the parameters section
names(my_datas) = reports #name each data in the list

projects = my_datas$All_Projects


## Export to raw Data
write_rds(projects,file.path(dir_data_raw, "Projects_zoho.rds"))


