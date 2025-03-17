#source("1.Code/00_set_up.R")

#source("1.Code/02_download_zoho.R")
cli::cli_h1("Cleaning Data")


## read data 

projects_raw = read_rds(file.path(dir_data_raw, "Projects_zoho.rds"))
centroids = read_rds(file.path(dir_data_clean, "centroids.rds"))





##clean data --------------------------------------------------------------------------------------------
projects_clean$url_example
names(projects_raw)

## 1 Clean multiple select questions
  #to_remove_brakets = c("Organizations", "Countries") ## define multiple select


  projects_clean <- projects_raw %>%
    ## remove brackets from strings (to_remove_brackets is defined in 01_functions.R)
  mutate(#across(all_of(to_remove_brakets), remove_brakets),
         across(ends_with("date"), dmy)) %>%
  ##Create an indepentent column for each answer (split_multi_select is defined in 01_functions.R)
    mutate(#split_multi_select(.,"Countries", "countries_"),
         #split_multi_select(.,"Organizations", "orgs_"),
         start_year = year(start_date),
         end_year = year(end_date),
         end_year = replace_na(as.character(end_year), "now"),
         text_url = ifelse(url_example == "", "", glue('[Example of my work]({url_example})')),
         text_url_project = ifelse(url_project == "", "", 
                                   glue('[See project]({url_project})')),
         
         for_table = glue::glue('<table class = "table_projects">
         <tr>
                                <td rowspan = "3" class = "col_project">
                              
                                **{Project}**<br>
                                {Description} <br>
                                {text_url_project} <br>
                                {text_url}
                               
                                </td>
  
                                <td class = "proj_info white_border">
                                
                                {start_year} - {end_year} 
                                
                                </td>
                                
                                <tr>
                                  <td class = "proj_info white_border">
                                  {Countries}
                                  </td>
                                </tr>
                                
                                <tr>
                                  <td class = "proj_info">
                                    {Organizations}
                                  </td>
                                </tr>
                                </table>
                                ')) %>%
    arrange(desc(start_date))
  
 
    

   long <- lapply(split(projects_clean, projects_clean$Project), function(a){
     
     
     Project <- a$Project[1]
     countries <-  unlist(strsplit(a$Countries[[1]],","))
     #message(Project)
     lista_project <- lapply(countries, function(c){
       
       db <- tibble(Project = Project,
                    Country = c) %>%
         mutate(Country = trim(Country))
       
        db
       
     })
     
     
     do.call(rbind, lista_project)
     
     
     
     
   })
   
   
   projects_long <- do.call(rbind, long) %>%
     mutate(Country = str_trim(Country))
   
 
   
   #               


## Export data to clean directory
  write_rds(projects_clean,file.path(dir_data_clean, "Projects_clean.rds"))
  write_rds(projects_long,file.path(dir_data_clean, "Projects_clean_long.rds"))
  