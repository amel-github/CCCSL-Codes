###################################################
#
# Author: Michael Gruber, VetMedUni Wien, Dec. 2020
# 
# The algorithm produces one graph containing all
# the countries and one graph for every country
# within the CCCSL dataset showing the number of
# implemented government measures per day and
# per L1-category over a timeline
#
###################################################

width_bar = months(1)
width_labels = months(1) + weeks(3)
date_min = lubridate::floor_date  (min(DATASET_NPI$Date), unit = "month") + months(1)
date_max = lubridate::ceiling_date(max(DATASET_NPI$Date), unit = "month")


###################################################################
########################### Line-Plot #############################
###################################################################

data_npi = DATASET_NPI %>%
	dplyr::mutate(Measure_L1 = str_break(Measure_L1, 25)) %>%
	dplyr::mutate(Measure_L1 = factor(Measure_L1, levels = sort(unique(Measure_L1)))) %>% # for drop=FALSE
	dplyr::select(iso3, Country, Date, Measure_L1,) %>%
	dplyr::group_by(iso3, Country, Date, Measure_L1) %>%
	dplyr::tally() %>%
	dplyr::rename(Number = n) %>%
	dplyr::ungroup() %>%
	dplyr::group_by(iso3, Country) %>%
	dplyr::arrange(iso3, Country, desc(Measure_L1), Date) %>%
	dplyr::mutate(Number_CumSum = cumsum(Number)) %>%
	dplyr::mutate(Number_Sum_All = max(Number_CumSum)) %>%
	dplyr::ungroup() %>%
	dplyr::mutate(Number_Relative = Number / Number_Sum_All) %>%
	dplyr::mutate(Number_CumSum_Relative = Number_CumSum / Number_Sum_All) %>%
	dplyr::select(iso3, Country, Date, Measure_L1, Number, Number_Sum_All, Number_Relative, Number_CumSum_Relative)

####### ggproto-Element: Line-Plot (Straight Fill-Length-dependent Lines)

p_line_plot = function(data, date_max_ = date_max, width_bar_ = width_bar, show_legend_ = show_legend) {
	list(
	ggplot2::geom_rect(data = data,
		mapping = aes(xmin = Date, xmax = date_max_ + width_bar_, ymin = Number_CumSum_Relative - Number_Relative, ymax = Number_CumSum_Relative, fill = Measure_L1),
		alpha = 0.5, size = 0.7, linetype = "solid", stat = "identity", show.legend = show_legend_, key_glyph = "rect"),
	ggplot2::scale_fill_manual(aesthetics = "fill",
		name = "Name of implemented\ngovernment measure",
		values = c("gold2", "black", "blue2", "seagreen", "green", "cyan", "red", "hotpink"), drop = FALSE,
		guide = guide_legend(reverse = FALSE, override.aes = list(alpha = 0.6))))
}


###################################################################
#### Line-Plot: Bar-Frame, Ticks, Labels and White Background #####
###################################################################

data_npi_total = data_npi %>%
	dplyr::group_by(iso3) %>%
	dplyr::distinct(Number_Sum_All)

####### ggproto-Element: Line-Plot: White-Rectangular Background-Area for Bar and Labels

p_background_white_line_plot = function(data, date_max_ = date_max, width_bar_ = width_bar, width_labels_ = width_labels) {
	list(
	ggplot2::geom_rect(data = data,
		mapping = aes(xmin = date_max_ + lubridate::days(2), xmax = date_max_ + width_bar_ + width_labels_, ymin = -Inf, ymax = Inf),
		alpha = 1, fill = "white", colour = "white", stat = "identity", show.legend = FALSE))
}

####### ggproto-Element: Line-Plot: Black Bar-Frame

p_bar_frame_line_plot = function(data, date_max_ = date_max, width_bar_ = width_bar) {
	list(
	ggplot2::geom_rect(data = data, # bar
		mapping = aes(xmin = date_max_, xmax = date_max_ + width_bar_, ymin = 0, ymax = 1),
		alpha = 0, fill = NA, size = 0.5, linetype = "solid", colour = "black", stat = "identity", show.legend = FALSE))
}

####### ggproto-Element: Line-Plot: Tick Marks

p_tick_marks_line_plot = function(data, date_max_ = date_max, width_bar_ = width_bar) {
	list(
	ggplot2::geom_segment(data = data,
		mapping = aes(x = date_max_ + width_bar_, xend = date_max_ + width_bar_ + lubridate::days(4), y = 0, yend = 0),
		size = 0.3, linetype = "solid", colour = "black", show.legend = FALSE),
	ggplot2::geom_segment(data = data,
		mapping = aes(x = date_max_ + width_bar_, xend = date_max_ + width_bar_ + lubridate::days(4), y = 1, yend = 1),
		size = 0.3, linetype = "solid", colour = "black", show.legend = FALSE))
}

####### ggproto-Element: Line-Plot: Ticks

p_ticks_line_plot = function(data, date_max_ = date_max, width_bar_ = width_bar) {
	list(
	ggplot2::geom_text(data = data,
		mapping = aes(x = date_max_ + width_bar_ + lubridate::days(7), y = 0, label = "0"),
		size = 3, colour = "black", hjust = 0, nudge_x = 0, nudge_y = 0.02, show.legend = FALSE),
	ggplot2::geom_text(data = data,
		mapping = aes(x = date_max_ + width_bar_ + lubridate::days(7), y = 1, label = paste0(Number_Sum_All)),
		size = 3, colour = "black", hjust = 0, nudge_x = 0, nudge_y = -0.02, show.legend = FALSE))
}


###################################################################
########################### Bar-Plot ##############################
###################################################################

data_npi_bar = data_npi %>%
	dplyr::select(iso3, Number_Sum_All) %>%
	unique()

####### ggproto-Element: Bar-Plot

p_bar_plot = function(data) {
	list(
	ggplot2::geom_bar(data = data,
		mapping = aes(x = iso3, y = Number_Sum_All),
		alpha = 0.9, fill = "steelblue", size = 0.3, linetype = "solid", colour = "black",
		stat = "identity", show.legend = TRUE, key_glyph = "rect"),
	ggplot2::scale_fill_manual(aesthetics = "fill",
		name = "Sum of all implemented\ngovernment measures",
		guide = guide_legend(override.aes = list(alpha = 1))))
}


###################################################################
####################### Other Plot Elements #######################
###################################################################

####### ggproto-Element: x-Axis and y-Axis

limits_Date = c(date_min, date_max + width_bar + width_labels)
breaks_dates = seq(limits_Date[1], date_max, by = '1 month')
labels_dates = ifelse(format(breaks_dates, "%b") == "Jan", format(breaks_dates, "%b%y"), format(breaks_dates, "%b"))

p_axis_line_plot = function(data = data) {
	list(
	ggplot2::scale_x_date(limits = limits_Date, breaks = breaks_dates, labels = labels_dates),
	ggplot2::scale_y_continuous(limits = c(-0.02, 1.02), breaks = NULL),
	ggplot2::labs(title = "", x = "Date", y = "Number of measures"))
}

p_axis_bar_plot = function(data = data) {
	list(
	ggplot2::scale_x_discrete(expand = plopt$ax_0_0),
	ggplot2::scale_y_sqrt(expand = plopt$ax_0_0, limits = pretty_limits(data$Number_Sum_All)),
	ggplot2::labs(title = "", x = "ISO-code of the country", y = "Sum of all measures"))
}

####### ggproto-Element: Line-Plot for Countries: y-Label

p_ylabel_line_plot = list(
	ggplot2::annotate("text", x = date_max + width_bar + weeks(5), y = 0.18,
	label = "Number of measures",
	angle = 90, hjust = 0, vjust = 0.5, size = 4, colour = "black"))

####### ggproto-Element: Facet-Plot Options

p_facet = list(
	ggplot2::facet_wrap(~ iso3, ncol = 4, scales = "fixed", strip.position = "left"))

####### ggproto-Element: Themes: Background, Axis, Legend

p_theme_line_plot = list(
	theme_classic(),
	theme(panel.grid.major = element_line(colour = "grey", size = 0.4),
		panel.grid.minor = element_blank(),
		panel.border = element_rect(colour = "black", size = 0.5, fill = NA),
		plot.margin = margin(t = 0, r = 0, b = 0, l = 0, unit = "cm")),
	theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
		axis.title.y = element_blank(),
		axis.text.y = element_blank(),
		axis.ticks.y = element_blank()),
	theme(legend.position = "right",
		legend.key = element_rect(colour = "black")))

p_theme_bar_plot = list(
	theme_classic(),
	theme(panel.grid.major = element_line(colour = "grey", size = 0.4),
		panel.grid.minor = element_line(colour = "grey", size = 0.2),
		panel.border = element_rect(colour = "black", size = 0.5, fill = NA),
		plot.margin = margin(t = 0, r = 0, b = 0, l = 0, unit = "cm")),
	theme(axis.text.x = element_text(size = 7, angle = 45, hjust = 1, vjust = 1)),
	theme(legend.position = "right",
		legend.key = element_rect(colour = "black")))


###################################################################
#################### Perform Poster-Plots #########################
###################################################################

save.height = 41 # A2: 420mm x 594mm - A3: 297mm x 420mm
save.width = 28
save.title = "Plot-Poster_L1-Measures-Timeline_Lines"
save.format = ".jpg"

####### L1-Measure-Timeline Line

p1 = ggplot2::ggplot() +
	p_background_white_line_plot(data_npi) +
	p_line_plot(data_npi, show_legend = TRUE) +
	p_bar_frame_line_plot(data_npi) +
	p_tick_marks_line_plot(data_npi_total) +
	p_ticks_line_plot(data_npi_total) +
	p_axis_line_plot(data_npi) +
	p_facet +
	p_theme_line_plot

leg1 = extract_legend(p1)
ggplot2::ggsave(file.path(output_dir, paste0("tmp_leg", save.format)), plot = leg1,
	dpi = plopt$save_dpi, width = 6, height = 6, units = plopt$units)
image_leg = magick::image_read(file.path(output_dir, paste0("tmp_leg", save.format)))

p1 = p1 + ggplot2::guides(fill = FALSE)

####### L1-Measure Bar-Plot Stacked

p2 = ggplot2::ggplot() +
	p_bar_plot(data_npi_bar) +
	p_axis_bar_plot(data_npi_total) +
	p_theme_bar_plot

####### L1-Measure Poster-Plot

p3 = ggpubr::ggarrange(p2, NULL, nrow = 1, widths = c(1, 0.3))

p4 = ggpubr::ggarrange(p1, NULL, p3, NULL, ncol = 1, heights = c(4, 0.05, 1, 0.05)) +
	theme(plot.margin = margin(t=save.height*0.03, b=save.height*0.07, l=save.width*0.05, r=save.width*0.05, unit=plopt$units))

p5 = cowplot::ggdraw() +
	cowplot::draw_plot(p4) +
	cowplot::draw_image(image_leg, x = 0.37, y = -0.325, width = 1, height = 1, scale = 0.2) + # legend
	cowplot::draw_label(build_usa_states_string(), # USA*
		x = 0.09, y = 0.05, hjust = 0, vjust = 0.5, size = 8, colour = "grey")

ggplot2::ggsave(file.path(output_dir, paste0(save.title, save.format)), plot = p5,
	dpi = plopt$save_dpi, width = save.width, height = save.height, units = plopt$units)


###################################################################
#################### Perform Country-Plots ########################
###################################################################

save.height = 10
save.width = 22
save.format = ".jpg"
output_folder = "./"

if(!dir.exists(file.path(output_dir, output_folder))) dir.create(file.path(output_dir, output_folder))

for (iso_country in  unique(data_npi$iso3))
{
	country_npi = data_npi %>%
		dplyr::filter(iso3 == iso_country)
	country_npi_total = data_npi_total %>%
		dplyr::filter(iso3 == iso_country)
	iso_country = gsub("[*]", "", iso_country)

	p1 = ggplot2::ggplot() +
		p_background_white_line_plot(country_npi) +
		p_line_plot(country_npi, show_legend = TRUE) +
		p_bar_frame_line_plot(country_npi) +
		p_tick_marks_line_plot(country_npi_total) +
		p_ticks_line_plot(country_npi_total) +
		p_axis_line_plot(country_npi) +
		p_ylabel_line_plot +
		p_theme_line_plot

	leg = extract_legend(p1)

	ggplot2::ggsave(file.path(output_dir, paste0("tmp_leg", save.format)), plot = leg,
		dpi = plopt$save_dpi, width = save.height, height = save.height, units = plopt$units)

	image_leg = magick::image_read(file.path(output_dir, paste0("tmp_leg", save.format)))

	p1 = p1 + ggplot2::guides(fill = FALSE)

	p2 = ggpubr::ggarrange(p1, heights = 1, labels = c("D"), label.y = 0.9) +
		theme(plot.margin = margin(t=save.height*0.1, b=save.height*0.05, l=save.width*0.05, r=save.width*0.27, unit=plopt$units))

	p3 = cowplot::ggdraw() +
		cowplot::draw_image(image_leg, x = 0.37, y = 0.02, width = 1, height = 1, scale = 0.7) + # legend
		cowplot::draw_plot(p2)
		# + cowplot::draw_label(paste0(country_npi$Country[1], "  (", country_npi$iso3[1], ")"), # title
		# 	x = 0.05, y = 0.94, hjust = 0, vjust = 0.5, size = 15)

	ggplot2::ggsave(file.path(output_dir, output_folder, paste0(iso_country, "_Lines", save.format)), plot = p3,
		dpi = plopt$save_dpi, width = save.width, height = save.height, units = plopt$units)
}
