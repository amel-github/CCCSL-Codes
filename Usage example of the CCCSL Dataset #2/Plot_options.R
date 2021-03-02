###################################################
# 
# Author: Michael Gruber, VetMedUni Wien, Dec. 2020
# 
# This file contains the format settings for the plots
#
###################################################

###################################################################
########################## Plot Options ###########################
###################################################################

plot_options = function()
{
	plopt = list(

		"base_font_family" = "Helvetica",
		"base_font_size" = 24,
		
		#####

		"units" = "cm",											# Units

		"save_format" = "jpg",									# Save - File format
		"save_dpi" = 300,										# Save - Resolution
		"save_height" = 20,										# Save - Height
		"save_width" = 30,										# Save - Width

		#####

		"ax_lab_face" = "bold",									# Axis label (Title) - Appearance
		"ax_lab_margin_t_r" = 0.05,								# Axis label (Title) - Indention of axis
		"ax_lab_size" = 0.9,									# Axis label (Title) - Font size
		"ax_lin_size" = 1,										# Axis line - Thickness
		"ax_txt_margin_t_r" = 0.02,								# Axis label - Indention of tick text from axis line
		"ax_txt_size" = 0.7,									# Axis label - Font size of numbers
		"ax_tik_len" = 3,										# Axis ticks - Length
		"ax_0_0" = c(0,0),										# Axis line - Empty space

		#####

		"leg_direction" = "vertical",							# Legend - Orientation horizontal/vertical
		"leg_key_height" = 0.01,								# Legend - Height of legend symbols
		"leg_key_size" = 0.7,									# Legend - Size of legend symbols
		"leg_key_spacing" = 1,									# Legend - Distance legend symbols x/y-direction
		"leg_key_width" = 1,									# Legend - Width of legend symbols
		"leg_margin_l" = 0.005,									# Legend - Indention around legend
		"leg_margin_r" = 0.005,									# Legend - Indention around legend
		"leg_margin_t" = 0.005,									# Legend - Indention around legend
		"leg_tit_align" = 0.5,									# Legend - Title horizontal orientation
		"leg_tit_face" = "bold",								# Legend - Title appearance title font
		"leg_tit_size" = 0.9,									# Legend - Title font size
		"leg_txt_align" = 0,									# Legend - Text horizontal orientation
		"leg_txt_face" = "plain",								# Legend - Text appearance font
		"leg_txt_size" = 0.6,									# Legend - Text font size

		#####

		"plot_margin_b" = 0.1,									# Plot-Box - Indention
		"plot_margin_l" = 0.05,									# Plot-Box - Indention
		"plot_margin_r" = 0.2,									# Plot-Box - Indention
		"plot_margin_t" = 0.1,									# Plot-Box - Indention

		#####

		"tit_col" = "black",									# Title - Font color
		"tit_face" = "bold",									# Title - Appearance
		"tit_hjust" = 0.5,										# Title - Orientation horizontal
		"tit_margin_b" = 0.1,									# Title - Indention below title to graph
		"tit_size" = 1.2,										# Title - Relative font size
		"tit_sub_col" = "black",								# Sub-title - Font colo
		"tit_sub_face" = "plain",								# Sub-title - Appearance
		"tit_sub_hjust" = 0.5,									# Sub-title - Orientation horizontal
		"tit_margin_b" = 2,										# Title - Indention below title
		"tit_sub_size" = 0.9									# Sub-title - Font size
	)

	return(plopt)
}

plopt = plot_options()

###################################################################
########################### Plot Themes ###########################
###################################################################

theme_plot = function(plopt, bf = "", bs = 11, bls = bs/22, brs = bs/22)
{
	hl = bs / 2 # Half line size

	theme_classic(base_family = bf, base_size = bs, base_line_size = bls, base_rect_size = brs) %+replace%

		theme(

			line =									element_line(size = bls,
														colour = "black",
														linetype = "solid",
														lineend = "butt"),

			text =									element_text(family = bf,
														size = bs,
														colour = "black",
														face = "plain",
														lineheight = 0.9,
														hjust = 0.5, vjust = 0.5,
														angle = 0,
														margin = margin(), debug = FALSE),

			rect =									element_rect(size = brs,
														colour = "white",
														linetype = "solid",
														fill = "white"),

			###

			axis.line =								element_line(size = rel(plopt$ax_lin_size),
														colour = "black"),

			axis.text =								element_text(size = rel(plopt$ax_txt_size),
														face = plopt$ax_txt_face,
														colour = "black"),
			axis.text.x =							element_text(hjust = 0.5, vjust = 0.5,
														angle = 0,
														margin = margin(t = hl * plopt$ax_txt_margin_t_r, unit = plopt$units)),
			axis.text.y =							element_text(hjust = 1, vjust = 0.5,
														margin = margin(r = hl * plopt$ax_txt_margin_t_r, unit = plopt$units)),

			axis.ticks =							element_line(colour = "black"),
			axis.ticks.length =							unit(plopt$ax_tik_len, "pt"),

			axis.title =							element_text(size = rel(plopt$ax_lab_size),
														face = plopt$ax_lab_face,
														colour = "black"),
			axis.title.x =							element_text(angle = 0,
														margin = margin(t = hl * plopt$ax_lab_margin_t_r, unit = plopt$units)),
			axis.title.y =							element_text(angle = 90,
														margin = margin(r = hl * plopt$ax_lab_margin_t_r, unit = plopt$units)),

			legend.box =							NULL,
			legend.direction =						plopt$leg_direction,
			legend.justification =					NULL,
			legend.key.height =						unit(plopt$leg_key_height, plopt$units),
			legend.margin =							margin(t = hl*plopt$leg_margin_t, r = hl * plopt$leg_margin_r, l = hl * plopt$leg_margin_l, unit = plopt$units),
			legend.position =						plopt$leg_pos,
			legend.text =							element_text(size = rel(plopt$leg_txt_size),
														face = plopt$leg_txt_face,
														colour = "black"),
			legend.text.align =						plopt$leg_txt_align,
			legend.title =							element_text(size = rel(plopt$leg_tit_size),
														face = plopt$leg_tit_face,
														colour = "black",
														hjust = 0.5, vjust = 0.5),

			plot.background =						element_rect(colour = "white"),
			plot.margin =							margin(t = hl * plopt$plot_margin_t, r = hl * plopt$plot_margin_r, b = hl * plopt$plot_margin_b, l = hl * plopt$plot_margin_l, unit = plopt$units),
			plot.title =							element_text(size = rel(plopt$tit_size),
														face = plopt$tit_face,
														colour = plopt$tit_col,
														hjust = plopt$tit_hjust, vjust = 0.5,
														margin = margin(b = hl * plopt$tit_margin_b, unit = plopt$units)),
			plot.subtitle =							element_text(size = rel(plopt$tit_sub_size),
														face = plopt$tit_sub_face,
														colour = plopt$tit_sub_col,
														hjust = plopt$tit_sub_hjust, vjust = 0.5),

			complete = TRUE
		)
}

# #############################################

theme_subplot = function(plopt, bf = "", bs = 11, bls = bs/22, brs = bs/22)
{
	theme_plot(plopt, bf = bf, bs = bs) %+replace%

		theme(

			plot.margin =							margin(t = 0.3, r = 0.3, b = 0.3, l = 0.3, unit = plopt$units),
			plot.title =							element_text(margin = margin(b = 0, unit = plopt$units)),

			complete = TRUE
		)
}

# #############################################