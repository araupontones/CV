source("1.Code/00_set_up.R")

#source("1.Code/02_download_zoho.R")


## read data 

projects_raw = read_rds(file.path(dir_data_raw, "Projects_zoho.rds"))
centroids = read_rds(file.path(dir_data_clean, "centroids.rds"))




##clean data --------------------------------------------------------------------------------------------


## 1 Clean multiple select questions
  to_remove_brakets = c("Organizations", "Countries") ## define multiple select


  projects_clean <- projects_raw %>%
    ## remove brackets from strings (to_remove_brackets is defined in 01_functions.R)
  mutate(across(all_of(to_remove_brakets), remove_brakets),
         across(ends_with("date"), dmy)) %>% 
  ##Create an indepentent column for each answer (split_multi_select is defined in 01_functions.R)
    mutate(split_multi_select(.,"Countries", "countries_"),
         split_multi_select(.,"Organizations", "orgs_"),
         start_year = year(start_date),
         end_year = year(end_date),
         end_year = replace_na(end_year, "now"),
         
         for_table = glue::glue('<table class = "table_projects">
         <tr class = "page-break-avoid">
                                <td rowspan = "3" style = "width:80%;" class = "page-break-avoid">
                               <span class = "avoid">
                                **{Project}**<br>
                                {Description} {url_example}
                                </span>
                                </td>
  
                                <td class = "proj_info white_border page-break-avoid">
                                
                                {start_year} - {end_year} 
                                
                                </td>
                                
                                <tr class = "page-break-avoid">
                                  <td class = "proj_info white_border page-break-avoid">
                                  {Countries}
                                  </td>
                                </tr>
                                
                                <tr class = "page-break-avoid">
                                <td class = "proj_info page-break-avoid"">
                                {Organizations}
                                </td>
                                </tr>
                                </table>
                                ')) %>%
    arrange(desc(start_date))
  
  
 
    

  
  

## 2 Create a long version for the countries
  projects_long = projects_clean %>%
    select(-Countries) %>%
    pivot_longer(cols = starts_with("countries"),
                 values_to = "Country") %>%
    select(-name) %>%
    filter(Country != "") %>%
    mutate(Country = str_trim(Country))
                


## Export data to clean directory
  write_rds(projects_clean,file.path(dir_data_clean, "Projects_clean.rds"))
  write_rds(projects_long,file.path(dir_data_clean, "Projects_clean_long.rds"))
  