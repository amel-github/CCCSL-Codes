###################################################
#
# Author: Michael Gruber, VetMedUni Wien, Dec. 2020
# 
# The algorithm produces one graph containing all
# the countries and one graph for every country
# within the CCCSL dataset showing the number of
# implemented government measures per day and
# per L1-category as bubbles over a timeline
#
###################################################

DESIGN_VLINE_FULL = FALSE

####### Heights

covid_max = ceiling(max(DATASET_COVID$new_cases_smoothed_per_million, na.rm = TRUE) / 100) * 100
special_height = ifelse(DESIGN_VLINE_FULL == TRUE, 0, 200)
total_height = covid_max + special_height


###################################################################
###################### Pre-Process NPI Data #######################
###################################################################

levels_size_npi = c(1, 2, 4, 10, 20, 40)

data_npi = DATASET_NPI %>%
	dplyr::mutate(Measure_L1 = str_break(Measure_L1, 25)) %>%
	dplyr::group_by(iso3, Country, Date, Measure_L1) %>%
	dplyr::tally() %>%
	dplyr::ungroup() %>%
	dplyr::rename(Number_of_NPI = n) %>%
	dplyr::mutate(Measure_L1 = factor(Measure_L1, levels = sort(unique(Measure_L1)))) %>%  # for drop=FALSE
	dplyr::mutate(Point_size_levels = cut(Number_of_NPI, c(levels_size_npi, Inf), right = FALSE, labels = paste0(levels_size_npi))) # for drop=FALSE

####### ggproto-Element: Size-Colour-dependent Circles for L1-measures

p_points = function(data, levels_size_npi_ = levels_size_npi, covid_max_ = covid_max, special_height_ = special_height) {
	list(
	ggplot2::geom_count(data = data,
		mapping = aes(x = Date, y = covid_max_ / 2 + special_height_, colour = Measure_L1, size = Point_size_levels),
		position = position_jitter(w = 0, h = covid_max_ * 0.4, seed = 32),
		alpha = 0.4, stat = "identity",  show.legend = TRUE, key_glyph = "point"),
	ggplot2::scale_color_manual(aesthetics = "colour",
		name = "Name of implemented\ngovernment measure",
		values = c("gold2", "black", "blue2", "seagreen", "green", "cyan", "red", "hotpink"), drop = FALSE,
		guide = guide_legend(order = 1, override.aes = list(alpha = 0.6, size = 3, fill = NA, linetype = 0))),
	ggplot2::scale_size_manual(
		name = "Number of specific\nimplemented government\nmeasures per day",
		values = c(1, 2, 3, 4, 5, 6), labels = levels_size_npi_, drop = FALSE,
		guide = guide_legend(order = 2, override.aes = list(fill = NA, linetype = 0), reverse = TRUE)))
}


###################################################################
########## Pre-Process Special Measures of the NPI-Data ###########
###################################################################

data_npi_special = DATASET_NPI %>%
	dplyr::mutate(Measure = ifelse(Measure_L2 == "National lockdown", as.character("National lockdown"),
		ifelse(Measure_L2 == "Cordon sanitaire", as.character("Cordon sanitaire"),
		ifelse(Measure_L3 == "Curfew", as.character("Curfew"), as.character("FALSE"))))) %>%
	dplyr::select(iso3, Date, Measure) %>%
	dplyr::filter(!(Measure == "FALSE" | Measure == "Curfew"))

data_npi_special$Measure = factor(data_npi_special$Measure, levels = unique(data_npi_special$Measure )) # for drop=FALSE

####### ggproto-Element: Full Vertical-Lines for Special Measures

p_vline_full = function(data) {
	list(
	(ggplot2::geom_vline(data = data,
		mapping = aes(xintercept = Date, colour1 = Measure),
		linetype = "solid", size = 0.7, show.legend = TRUE, key_glyph = "vline") %>%
		relayer::rename_geom_aes(new_aes = c("colour" = "colour1"))),
	ggplot2::scale_colour_manual(aesthetics = "colour1",
		name = "Special measures",
		labels = c("National Lockdown", "Cordon sanitaire"), values = c("navy", "purple"), drop = FALSE,
		guide = guide_legend(order = 3, override.aes = list(fill = NA, shape = NA))))
}

####### ggproto-Element: Partial Vertical-Lines for Special Measures

p_vline_partial = function(data, special_height_ = special_height) {
	list(
	(ggplot2::geom_segment(data = data,
		mapping = aes(x = Date, xend = Date, y = -Inf, yend = special_height_, colour2 = Measure),
		linetype = "solid", size = 0.7, show.legend = TRUE, key_glyph = "vline") %>%
		relayer::rename_geom_aes(new_aes = c("colour" = "colour2"))),
	ggplot2::scale_colour_manual(aesthetics = "colour2",
		name = "Special measures",
		labels = c("National Lockdown", "Cordon sanitaire"), values = c("navy", "purple"), drop = FALSE,
		guide = guide_legend(order = 3, override.aes = list(fill = NA, shape = NA))))
}


###################################################################
############## Pre-Process Daily-new COVID19 cases ################
###################################################################

data_covid = DATASET_COVID %>%
	dplyr::select(iso3, Date, new_cases_smoothed_per_million) %>%
	dplyr::rename(New_cases = new_cases_smoothed_per_million) %>%
	dplyr::filter(!is.na(New_cases)) %>%
	dplyr::filter(New_cases > 0) %>%
	unique()

####### ggproto-Element: Gradient-Background Fill

p_gradient = function(data, total_height_ = total_height) {
	list(
	ggplot2::geom_rect(data = data,
		mapping = aes(xmin = Date, xmax = (Date + 1), ymin = special_height, ymax = total_height_, fill = New_cases),
		alpha = 0.25, stat = "identity", show.legend = TRUE, key_glyph = "rect"),
	ggplot2::scale_fill_gradientn(
		name = "Smoothed daily-new\nconfirmed COVID-19\ncases per million people\n(Source: Our World in Data)",
		breaks = c(0.0001, 0.001, 0.01, 0.1, 1, 10, 100, 1000),
		labels = c("<0.001 or data NA", "0.001", "0.01", "0.1", "1", "10", "100", "1000"),
		limits = c(0.0001, 1600), trans = "log10", colors = rev(c(magma(9), "#FFFFFFFF")),
		guide = guide_legend(order = 4, override.aes = list(alpha = 0.4, linetype = 0, shape = NA), reverse = TRUE)))
}

####### ggproto-Element: Dotdashed-Line

date1 = as.Date("2019-12-26")
date2 = as.Date("2020-01-05")

dates = data.frame(x11 = date1, x12 = date1, x21 = date1, x22 = date2,
	y11 = special_height, y12 = total_height, y21 = special_height, y22 = special_height)

p_line = function(data, special_height_ = special_height, total_height_ = total_height, covid_max_ = covid_max, dates_ = dates) {
	list(
	(ggplot2::geom_line(data = data,
		mapping = aes(x = Date, y = New_cases + special_height_, colour3 = "New_cases"),
		linetype = "dotdash", size = 0.5, stat = "identity", show.legend = TRUE, key_glyph = "timeseries") %>%
		relayer::rename_geom_aes(new_aes = c("colour" = "colour3"))),
	ggplot2::scale_colour_manual(aesthetics = "colour3",
		name = "Smoothed daily-new\nconfirmed COVID-19\ncases per million people\n(Source: Our World in Data)",
		labels = c("New cases"), values = c("New_cases" = "red"), drop = FALSE,
		guide = guide_legend(order = 4, override.aes = list(fill = NA, shape = NA))),
	ggplot2::annotate("text", x = date1 - 3, y = special_height_ + 100,
		label = "0",
		hjust = 1, size = 2.9, color = "red"),
	ggplot2::annotate("text", x = date1 - 3, y = total_height_ - 100,
		label = paste0(covid_max_, sep = ""),
		hjust = 1, size = 2.9, color = "red"),
	ggplot2::geom_segment(data = dates_,
		mapping = aes(x = x11, xend = x12, y = y11, yend = y12),
		arrow = arrow(length = unit(0.1, "cm")), color = "red", show.legend = FALSE),
	ggplot2::geom_segment(data = dates_,
		mapping = aes(x = x21, xend = x22, y = y21, yend = y22),
		arrow = arrow(length = unit(0.1, "cm")), color = "red", show.legend = FALSE))
}


###################################################################
####################### Other Plot Elements #######################
###################################################################

####### ggproto-Element: x-Axis and y-Axis

limits_Date = c(
	lubridate::floor_date  (min(min(data_covid$Date), min(data_npi$Date), date1), unit = "month"),
	lubridate::ceiling_date(max(max(data_covid$Date), max(data_npi$Date)), unit = "month"))

breaks_dates = seq(limits_Date[1], limits_Date[2], by = '1 month')
labels_dates = ifelse(format(breaks_dates, "%b") == "Jan", format(breaks_dates, "%b%y"), format(breaks_dates, "%b"))

p_axis = list(
	ggplot2::scale_x_date(limits = limits_Date, breaks = breaks_dates, labels = labels_dates),
	ggplot2::scale_y_continuous(limits = c(0, total_height), breaks = NULL),
	ggplot2::labs(title = "", x = "Date", y = ""))

####### ggproto-Element: Facet-Plot Options

p_facet = list(
	ggplot2::facet_wrap(~ iso3, ncol = 2, scales = "fixed", strip.position = "left"))
	#ggplot2::facet_grid(rows = vars(iso3), switch = "both"))


####### ggproto-Element: Themes: Background, Axis, Legend

p_theme = list(
	theme_classic(),
	theme(panel.grid.major = element_line(colour = "grey", size = 0.4),
		panel.grid.minor = element_blank(),
		panel.border = element_rect(colour = "black", size = 0.5, fill = NA),
		plot.margin = margin(t = 0, r = 0, b = 0, l = 0, unit = "cm")),
	theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
		axis.title.y = element_blank(),
		axis.text.y = element_blank(),
		axis.ticks.y = element_blank()),
	theme(legend.position = "right"))

###### ggproto-Element: Margins

p_poster_margin = function(height_ = save.height, width_ = save.width, plopt_ = plopt) {
	list(
	theme(plot.margin = margin(t=height_*0.03, b=height_*0.07, l=width_*0.05, r=width_*0.05, unit=plopt_$units)))
}


###################################################################
#################### Perform Poster-Plots #########################
###################################################################

save.height = 41 # A2: 420mm x 594mm - A3: 297mm x 420mm
save.width = 28
save.title = "Plot-Poster_L1-Measures-Timeline_Bubbles"
save.format = ".jpg"

text_usa_x = 0.05
text_usa_y = 0.04

####### Poster-Plot: L1-Measure-Timeline

p1 = ggplot2::ggplot() +
	{if(DESIGN_VLINE_FULL == TRUE)  p_vline_full(data_npi_special)} +
	{if(DESIGN_VLINE_FULL == FALSE) p_vline_partial(data_npi_special)} +
	p_points(data_npi) +
	p_axis +
	p_facet +
	p_theme +
	p_poster_margin()

p2 = cowplot::ggdraw() +
	cowplot::draw_plot(p1) +
	cowplot::draw_label(build_usa_states_string(), # USA*
		x = text_usa_x, y = text_usa_y, hjust = 0, vjust = 0.5, size = 8, colour = "grey")

ggplot2::ggsave(file.path(output_dir, paste0(save.title, "_v1", save.format)), plot = p2,
	dpi = plopt$save_dpi, width = save.width, height = save.height, units = plopt$units)

####### Poster-Plot: L1-Measure-Timeline with COVID19-Data as Background

p1 = ggplot2::ggplot() +
	{if(DESIGN_VLINE_FULL == TRUE)  p_vline_full(data_npi_special)} +
	{if(DESIGN_VLINE_FULL == FALSE) p_vline_partial(data_npi_special)} +
	p_gradient(data_covid) +
	p_points(data_npi) +
	p_axis +
	p_facet +
	p_theme +
	p_poster_margin()
p1 = draw_box_around_key_gradients_plot_v2(p1)

p2 = cowplot::ggdraw() +
	cowplot::draw_plot(p1) +
	cowplot::draw_label(build_usa_states_string(), # USA*
		x = text_usa_x, y = text_usa_y, hjust = 0, vjust = 0.5, size = 8, colour = "grey")

ggplot2::ggsave(file.path(output_dir, paste0(save.title, "_v2", save.format)), plot = p2,
	dpi = plopt$save_dpi, width = save.width, height = save.height, units = plopt$units)

####### Poster-Plot: L1-Measure-Timeline with COVID-Data as Line

p1 = ggplot2::ggplot() +
	{if(DESIGN_VLINE_FULL == TRUE)  p_vline_full(data_npi_special)} +
	{if(DESIGN_VLINE_FULL == FALSE) p_vline_partial(data_npi_special)} +
	p_points(data_npi) +
	p_line(data_covid) +
	p_axis +
	p_facet +
	p_theme +
	p_poster_margin()
p1 = remove_false_lines_in_legend_key_plot_v3(p1)

p2 = cowplot::ggdraw() +
	cowplot::draw_plot(p1) +
	cowplot::draw_label(build_usa_states_string(), # USA*
		x = text_usa_x, y = text_usa_y, hjust = 0, vjust = 0.5, size = 8, colour = "grey")

ggplot2::ggsave(file.path(output_dir, paste0(save.title, "_v3", save.format)), plot = p2,
	dpi = plopt$save_dpi, width = save.width, height = save.height, units = plopt$units)


###################################################################
#################### Perform Country-Plots ########################
###################################################################

save.height = 20
save.width = 22
save.format = ".jpg"
output_folder = "./"

if(!dir.exists(file.path(output_dir, output_folder))) dir.create(file.path(output_dir, output_folder))

for (iso_country in unique(data_npi$iso3))
{
	country_covid = data_covid %>%
		dplyr::filter(iso3 == iso_country)
	country_npi = data_npi%>%
		dplyr::filter(iso3 == iso_country)
	country_npi_special = data_npi_special %>%
		dplyr::filter(iso3 == iso_country)
	iso_country = gsub("[*]", "", iso_country)

	enough_special = length(country_npi_special$Measure) > 0
	enough_covid = length(country_covid$New_cases) > 0

	p1 = ggplot2::ggplot() +
		{if(enough_special) { if(DESIGN_VLINE_FULL == TRUE)  p_vline_full(country_npi_special) }} + 
		{if(enough_special) { if(DESIGN_VLINE_FULL == FALSE) p_vline_partial(country_npi_special) }} +
		p_points(country_npi) +
		p_axis +
		p_theme

	p2 = ggplot2::ggplot() +
		{if(enough_special) { if(DESIGN_VLINE_FULL == TRUE)  p_vline_full(country_npi_special) }} +
		{if(enough_special) { if(DESIGN_VLINE_FULL == FALSE) p_vline_partial(country_npi_special) }} +
		{if(enough_covid) p_gradient(country_covid)} +
		p_points(country_npi) +
		p_axis +
		p_theme +
		guides(colour = FALSE, size = FALSE, colour1 = FALSE, colour2 = FALSE)

	p3 = ggplot2::ggplot() +
		{if(enough_special) { if(DESIGN_VLINE_FULL == TRUE)  p_vline_full(country_npi_special) }} + 
		{if(enough_special) { if(DESIGN_VLINE_FULL == FALSE) p_vline_partial(country_npi_special) }} +
		p_points(country_npi) +
		{if(enough_covid) p_line(country_covid)} +
		p_axis +
		p_theme +
		guides(colour = FALSE, size = FALSE, colour1 = FALSE, colour2 = FALSE)

	if(enough_covid) {
		leg1 = extract_legend(p1)
		leg2 = extract_legend(p2)
		leg3 = extract_legend(p3)
		leg2 = draw_box_around_key_gradients_plot_v2_country(leg2)
		leg3 = remove_false_lines_in_legend_key_plot_v3_country(leg3)
		leg = ggpubr::ggarrange(leg1, leg3, leg2, ncol = 1, heights = c(1.5, 0.4, 0.8)) # legend
	} else {
		leg1 = extract_legend(p1)
		leg = ggpubr::ggarrange(leg1, ncol = 1) # legend
	}

	ggplot2::ggsave(file.path(output_dir, paste0("tmp_leg", save.format)), plot = leg,
		dpi = plopt$save_dpi, width = 6, height = 27, units = plopt$units)

	image_leg = magick::image_read(file.path(output_dir, paste0("tmp_leg", save.format)))

	p1 = p1 + ggplot2::guides(colour = FALSE, size = FALSE, colour1 = FALSE, colour2 = FALSE)
	p2 = p2 + ggplot2::guides(fill = FALSE)
	p3 = p3 + ggplot2::guides(colour3 = FALSE)

	p4 = ggpubr::ggarrange(p1, NULL, p3, NULL, p2, ncol = 1, heights = c(1, 0.05, 1, 0.05, 1),
			labels = c("A", "", "B", "", "C", ""), label.y = 0.9) +
		theme(plot.margin = margin(t=save.height*0.1, b=save.height*0.05, l=save.width*0.05, r=save.width*0.27, unit=plopt$units)) # plot

	p5 = cowplot::ggdraw() +
		cowplot::draw_image(image_leg, x = 0.77, y = 0.0, width = 0.2, height = 1, scale = 1.0) + # legend
		cowplot::draw_plot(p4) +
		cowplot::draw_label(paste0(country_npi$Country[1], "  (", iso_country, ")"), # title
			x = 0.05, y = 0.94, hjust = 0, vjust = 0.5, size = 15)

	ggplot2::ggsave(file.path(output_dir, output_folder, paste0(iso_country,  "_Bubbles", save.format)), plot = p5,
		dpi = plopt$save_dpi, width = save.width, height = save.height, units = plopt$units)
}
