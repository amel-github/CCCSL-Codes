## Author: Michael Gruber
## EOSC Grant #220
## Date 2020-12-03

library(sf)
library(raster)
library(tmap)
library(tmaptools)
library(tigris)
library(dplyr)
library("rstudioapi")


###################################################################
########### Clear Environment and set Working Directory ###########
###################################################################

cat("\014")
rm(list = ls())

file_name = "COVID19_non-pharmaceutical-interventions_version2_utf8.csv"
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


###################################################################
####### Import and Transform Maps (into the same Geometry) ########
###################################################################

data("World")
countries.map = World %>%
	dplyr::filter(name != "Antarctica")
countries.map_crs = raster::crs(countries.map, asText = TRUE) # get coordinate reference system (CRS)

us_states.map = tigris::states(class = "sf", res = "20m", cb = TRUE)
us_states.map = sf::st_transform(us_states.map, countries.map_crs)


###################################################################
##### Import Dataset and Calculate NPIs per Country and State #####
###################################################################

dataset = read.csv(file_name, colClasses=c("Country" = "character"))

countries.csv = dataset %>%
	dplyr::filter(!(Country %in% c("Diamond Princess", "United States of America"))) %>%
	dplyr::select(iso3, Country) %>%
	dplyr::group_by(iso3, Country) %>%
	dplyr::count() %>%
	dplyr::ungroup()

us_states.csv = dataset %>%
	dplyr::filter(Country == "United States of America") %>%
	dplyr::select(State) %>%
	dplyr::group_by(State) %>%
	dplyr::count() %>%
	dplyr::ungroup()

npi_usa = us_states.csv$n[us_states.csv$State == "United States of America"]

us_states.csv = us_states.csv %>%
	dplyr::filter(State != "United States of America")


###################################################################
########### Merge Maps with CSV-Data to one World Map #############
###################################################################

countries.dataset = countries.map %>%
	dplyr::select(iso_a3, name, geometry) %>%
	dplyr::mutate(iso3 = dplyr::case_when(iso_a3 == "UNK" ~ "RKS", TRUE ~ as.character(iso_a3))) %>% # Kosovo
	dplyr::full_join(countries.csv, by = "iso3") %>%
	dplyr::filter(!(iso3 %in% c("HKG", "LIE", "MUS", "SGP"))) %>% # not in map
	dplyr::rename(Number_of_NPI = n) %>%
	dplyr::mutate(Country_State = dplyr::coalesce(Country, name)) %>%
	dplyr::select(Country_State, Number_of_NPI, geometry)

us_states.dataset = us_states.map %>%
	dplyr::select(NAME, geometry) %>%
	dplyr::rename(State = NAME) %>%
	dplyr::full_join(us_states.csv, by = "State") %>%
	dplyr::rename(Number_of_NPI = n) %>%
	dplyr::rename(Country_State = State) %>%
	dplyr::mutate(Number_of_NPI = dplyr::coalesce(Number_of_NPI, 0L)) %>%
	dplyr::mutate(Number_of_NPI = Number_of_NPI + npi_usa)

world.dataset = countries.dataset %>%
	dplyr::union(us_states.dataset)

# world.dataset = world.dataset %>%
# 	dplyr::filter(!is.na(Number_of_NPI))

world.dataset = sf::st_as_sf(world.dataset)


###################################################################
############## Plot Dataset as World Map and Format ###############
###################################################################

tmap::tmap_mode("view")

world.bbox = tmaptools::bb(world.dataset, xlim = c(-16656120, 16656120), ylim = c(-7000000, 7000000))

world.map = tmap::tm_shape(world.dataset, bbox = world.bbox) +

	tmap::tm_polygons("Number_of_NPI",
					legend.show = TRUE,
					legend.is.portrait = TRUE,
					title = "Number of<br>Government<br>Interventions",
					textNA = "Missing Data",
					popup.vars = c("Number of NPIs:" = "Number_of_NPI"),
					popup.format = list(Number_of_NPI = list(digits = 0))) +

	tmap::tm_view(set.zoom.limits = c(1.2, 5),
					view.legend.position = c("left","bottom"))


###################################################################
########################### Save Plot #############################
###################################################################

class(world.map)
tmap::tmap_save(world.map, filename = "WorldMap.html")


###################################################################
################## HTML Code for the Homepage #####################
###################################################################

# <iframe seamless src="https://covid19-interventions.com/wp-content/uploads/2020/11/WorldMap.html" width="100%" height="500"></iframe>