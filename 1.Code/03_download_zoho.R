cli::cli_alert_info("Downloading data")

library(zohor)
library(glue)




#define parameters of app -------------------------------------------------------
app <- "cv"
report <- "All_Projects"

refresh_token = "1000.b11df28b89daaeb2df10fa2c43178db6.6f953944b607f0ff366915cb9a770edc"

#refresh zoho token --------------------------------------------------------------
new_token <- zohor::refresh_token(
  base_url = "https://accounts.zoho.com",
  client_id = "1000.V0FA571ML6VV7YFWRC4Q7OKQ32U5PZ",
  client_secret = "c551969c7d49a7a945ac2da12d1a3fe5f241b8dae6",
  refresh_token = refresh_token
)


 


#download data -----------------------------------------------------------------
projects <-zohor::get_report(url_app = "https://creator.zoho.com" ,
                  account_owner_name = "araupontones" ,
                  app_link_name = "cv",
                  report_link_name = "All_Projects",
                  access_token = new_token,
                  criteria = "ID != 0",
                  from = 1)

#function to unnest multiple select variables -------------------------------
get_value_from_list<- function(x){
  
  lapply(x, function(y){
    
    str_flatten(y[[1]], collapse = ", ")
  })
  
  
}


#unnest list columns (multiple select variables)
projects_unnested <- projects %>%   
  mutate_if(is.list,get_value_from_list)
 

## Export to raw Data
write_rds(projects_unnested,file.path(dir_data_raw, "Projects_zoho.rds"))



              