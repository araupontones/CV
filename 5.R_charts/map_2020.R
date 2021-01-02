source("1.Code/00_set_up.R")

#Load packages
library(pacman)
 

p_load(sf, ggrepel, ggtext, ggspatial, spData,extrafont )

loadfonts(dev='win')

#'load projects(run downloads and clean CV)-----------------------------------

projects_20 = projects_long %>%
  #' Projects worked in 2020
  filter(end_year %in% c("2020", "now") | start_year == "2020") %>%
  #' Clean contries to match with polygons
  mutate(Country = case_when(Country == "Cote d'Ivoire" ~ "Ivory Coast",
         T ~ Country))



#world polygons--------------------------------------------------------------
globe_sf = spData::world %>% 
  st_as_sf() %>%
  #'clean it -----------------------------------------------------------------
  filter(name_long!="Antarctica") %>%
  mutate(name_long = case_when(name_long == "Côte d'Ivoire" ~ "Ivory Coast",
                               name_long == "The Gambia" ~ "Gambia",
                          T ~ name_long)) %>%
  arrange(name_long) %>%
  #join with projects --------------------------------------------------------
    left_join(projects_20, by=c("name_long"="Country")) %>%
    mutate(color = !is.na(end_year)) %>%
  group_by(name_long) %>%
  slice(1) %>%
  ungroup()



#'draw chart -----------------------------------------------------------------
map = ggplot(data = globe_sf) +
  
  #' polygons ---------------------------------------------------------------
  geom_sf(show.legend = F,
          color = "white",
          aes(fill = color)
  ) +
  coord_sf(crs = 3395) +
  #' points -------------------------------------------------------------------
  stat_sf_coordinates(
    data = subset(globe_sf, color ==T),
    geom = "point"
    ) +
  #'text ----------------------------------------------------------------------
  stat_sf_coordinates(data = subset(globe_sf, color ==T),
                      geom = "text_repel",
                      aes(label = name_long),
                      direction = c("both"),
                      min.segment.length = 0, 
                      seed = 42, 
                      box.padding = .7,
                      family = "Open Sans Light"
                      ) +
  #'colors --------------------------------------------------------------------
  scale_fill_manual(values = c(alpha("#0058A3", .1), alpha("#0058A3", 1))
  ) +
  #'labs -----------------------------------------------------------------------
  
  labs(
    title = "In 2020, I worked in more than 10 projects across 12 countries",
   # subtitle = "I worked in more than 10 projects across 12 countries",
    caption = "**Andres Arau** | 31st December, 2020"
  ) +
  
  #'theme ---------------------------------------------------------------------
  theme(
    
    #plot
    plot.background = element_blank(),
    panel.background = element_blank(),
    #axis
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    #title
    plot.caption = element_markdown(family = "Open Sans Light", size = 12),
    plot.title = element_markdown(family = "Open Sans Light", size = 32, hjust = .85),
    plot.subtitle = element_markdown(family = "Open Sans Light", size = 24)
    
  )
  

#;export

filename = file.path("6.plots/map2020.png")

ggsave(filename, map,
       width = 35,
       height = 20,
       units = 'cm')

unique(projects_20$Project)


