#source("1.Code/00_set_up.R")
cli::cli_alert_info("Cleaning centroids")

centroids = CoordinateCleaner::countryref %>%
  filter(type == "country") %>%
  group_by(name) %>%
  slice(1) %>%
  rename(country = name,
         lon = centroid.lon,
         lat=centroid.lat) %>%
  select(country, lon, lat)


write_rds(centroids, file.path(dir_data_clean, "centroids.rds"))
