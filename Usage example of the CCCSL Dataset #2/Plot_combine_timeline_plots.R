###################################################
# 
# Author: Michael Gruber, VetMedUni Wien, Dec. 2020
# 
# The algorithm combines the bubbles and timeline
# graphs into one graphical file
#
###################################################

#######

height_image1 = 20
height_image2 = 10

save.height = height_image1 + height_image2
save.width = 22
save.format = ".jpg"
output_folder = "./"

if(!dir.exists(file.path(output_dir, output_folder))) dir.create(file.path(output_dir, output_folder))


###################################################################
######################### Combine Plots ###########################
###################################################################

for (iso_country in unique(DATASET_NPI$iso3))
{
	name_country = DATASET_NPI %>%
		dplyr::filter(iso3 == iso_country) %>%
		dplyr::select(Country) %>%
		unique()
	iso_country = gsub("[*]", "", iso_country)

	input_folder = "./"
	image1 = magick::image_read(file.path(output_dir, input_folder, paste0(iso_country, "_Bubbles", save.format)))

	input_folder = "./"
	image2 = magick::image_read(file.path(output_dir, input_folder, paste0(iso_country, "_Lines", save.format)))

	p1 = cowplot::ggdraw() +
		cowplot::draw_image(image2, x = 0, y = 0.02, width = 1, height = 1, scale = 1, halign = 0.5, valign = 0) +
		cowplot::draw_image(image1, x = 0, y = 0.31, width = 1, height = 1, scale = 1, halign = 0.5, valign = 0)

	ggplot2::ggsave(file.path(output_dir, output_folder, paste0(iso_country, "_Combined_", name_country, save.format)), plot = p1,
		dpi = plopt$save_dpi, width = save.width, height = save.height, units = plopt$units)
}
