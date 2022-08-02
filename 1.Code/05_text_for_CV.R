#source("1.Code/00_set_up.R")
#cli::cli_alert_info("Creating text for CV")

df_projects_long = read_rds(file.path(dir_data_clean, "Projects_clean_long.rds"))
df_projects = read_rds(file.path(dir_data_clean, "Projects_clean.rds")) %>%
  arrange(desc(start_date))


## Address 

txt_phone = "+34657402968"
txt_email = "andres.arau@pulpodata.org"
txt_address = "Pablo Ruiz Picasso, No.4, 8D. Zaragoza, Spain. 50018"
txt_website = "https://www.andresarau.com"



## 1. Years of experience
txt_years_of_experience = year(Sys.Date()) - 2010



## 1. Countries I have worked in
txt_countries = sort(unique(df_projects_long$Country))
txt_number_countries = length(txt_countries) ## number of countries

View(df_projects_long)
## Projects 

txt_number_projects = nrow(df_projects)

# 2. Languages

txt_languages = "Spanish (native), English (fluent), Portuguese (basic)"

txt_software = c("ArcGIS", "Google Maps", "Google Sheets", "HTML 5", 
                 "KoBoToolbox", "Leaflet", "MS Excel", "NVivo", "Power Bi", 
                 "R", "Shiny R", "Stata", "Survey Solutions", "Ubuntu", "Zoho")



## 3. Project table

txt_projects = paste(df_projects$for_table, collapse = " ")
