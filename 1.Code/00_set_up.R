
library(pacman)

p_load(httr, jsonlite, lubridate, rprojroot, stringr, tidyverse)

## Define directories

dir_code = "1.Code"
dir_data_raw = "2.Data_Raw"
dir_data_clean = "3.Data_Clean"
dir_CV = "CV"


## Load funcitons

source(file.path(dir_code,"01_functions.R"))


