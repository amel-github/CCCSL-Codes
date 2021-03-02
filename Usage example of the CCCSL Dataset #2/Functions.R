###################################################
# 
# Author: Michael Gruber, VetMedUni Wien, Dec. 2020
# 
# This file contains the functions used by the
# various algorithms
#
###################################################

###################################################################
####################### Small Functions ###########################
###################################################################

clear_workspace = function()
{
	keep = c("output_dir", "DATASET_COVID", "DATASET_NPI",
			 "plopt", "theme_plot", "theme_subplot", "theme_plot_heatmap")
	#rm(list = setdiff(ls(), c(lsf.str(), keep))
	rm(list = setdiff(ls(envir = .GlobalEnv), c(lsf.str(envir = .GlobalEnv), keep)), envir = .GlobalEnv)
}

####

str_break = function(col_str, num_char_before_break)
{
	# gsub('(.{100})\\s(.*)', '\\1\n\\2',str)
	txt = paste0("(.{", num_char_before_break, "})\\s(.*)", sep = "")
	gsub(txt, "\\1\n\\2", col_str)
}

####

pretty_limits = function(col)
{
	range(scales::pretty_breaks()(col))
}

####

extract_legend = function(p_)
{
	leg = gtable_trim(cowplot::get_legend(p_))
	leg = gtable_filter(leg, "legend.box.background", invert = TRUE, trim = TRUE)
	return(leg)
}

####

add_year_to_Jan = function(dates)
{
	dates = as.Date(paste0(dates, "-01"))
	ifelse(format(dates, "%b") == "Jan", format(dates, "%b%y"), format(dates, "%b"))
}

####

build_usa_states_string = function()
{
	str = "USA*: Implemented measurements of the federal government and of the state governments of the following 24 states: Alabama, Alaska, Arizona, California, Colorado, Connecticut, Delaware, Florida,
	Georgia, Hawaii, Idaho, Illinois, Indiana, Iowa, Kansas, Kentucky, Louisiana, Maine, Maryland, Massachusetts, Michigan, New York, Wisconsin, Wyoming"
	return(str)
}


###################################################################
################## Remove Legend Key Elements #####################
###################################################################

remove_false_lines_in_legend_key_plot_v3 = function(p_)
{
	g = ggplot2::ggplotGrob(p_)
	guide = which(g$layout$name == "guide-box")
	guide_order = 3 # which(g$grobs[[guide]]$layout$name == "guides")
	leg_elem_num_z = c(6, 10) # g$grobs[[guide]]$grobs[[guide_order]]
	remove_pattern = paste(g$grobs[[guide]]$grobs[[guide_order]]$layout$name[leg_elem_num_z], collapse = "|")
	g$grobs[[guide]]$grobs[[guide_order]] = gtable::gtable_filter(g$grobs[[guide]]$grobs[[guide_order]], remove_pattern, invert = TRUE, trim = TRUE)
	guide_order = 4 # which(g$grobs[[guide]]$layout$name == "guides")
	leg_elem_num_z = c(4) # g$grobs[[guide]]$grobs[[guide_order]]
	remove_pattern = paste(g$grobs[[guide]]$grobs[[guide_order]]$layout$name[leg_elem_num_z], collapse = "|")
	g$grobs[[guide]]$grobs[[guide_order]] = gtable::gtable_filter(g$grobs[[guide]]$grobs[[guide_order]], remove_pattern, invert = TRUE, trim = TRUE)
	ggplotify::as.ggplot(g)
}

remove_false_lines_in_legend_key_plot_v3_country = function(leg_)
{
	leg_$grobs[[1]] = gtable_filter(leg_$grobs[[1]], "key-3-1-1", invert = TRUE, trim = TRUE)
	return(leg_)
}

###################################################################
############### Draw Box around Legend Key Elements ###############
###################################################################

draw_box_around_key_gradients_plot_v2 = function(p_)
{
	guide_order = 4 # 4th legend
	gt = ggplot2::ggplotGrob(p_)
	leg = gtable::gtable_filter(gt, "guide-box")
	legx = leg$grobs[[1]]$grobs[[guide_order]]
	rects = legx$layout$t[grepl("bg", legx$layout$name)]
	for(i in rects)	{
		legx = gtable::gtable_add_grob(
			legx, grid.rect(gp = gpar(col='#bdbdbd', fill=NA)), t=i, l=2)
	}
	leg$grobs[[1]]$grobs[guide_order][[1]] = legx
	gt$grobs[gt$layout$name == "guide-box"][[1]] = leg
	ggplotify::as.ggplot(gt)
}

draw_box_around_key_gradients_plot_v2_country = function(leg_)
{
	rects = leg_$grobs[[1]]$layout$t[grepl("bg", leg_$grobs[[1]]$layout$name)]
	for(i in rects)	{
		leg_$grobs[[1]] = gtable::gtable_add_grob(
			leg_$grobs[[1]], grid.rect(gp = gpar(col='#bdbdbd', fill=NA)), t=i, l=2)
	}
	return(leg_)
}
