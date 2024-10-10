library(fpp3)
library(fable)
library(tsibble)
library(tsibbledata)
library(cowplot)
library(ggthemes)
library(colorspace)
head(aus_production)
aus_production %>% 
	pivot_longer(Beer:Gas, names_to = "product", values_to = "volume") %>% 
	as_tsibble(key = product, index = Quarter) %>% 
	filter_index("1990 Q1" ~ "2000 Q1") %>%
	index_by(year = year(Quarter)) %>% 
	group_by(product) %>% 
	summarize(avg_volume = mean(volume)) -> ap_long
ap_long %>%
	group_by(product) %>%
	mutate(base = first(avg_volume),
		   diff = avg_volume - base,
		   pct = (diff / base)) -> ap_long_cum_pct

ap_long_cum_pct %>% 
	ggplot() +
	aes(x = year, y = pct, group = product, color = product) +
	geom_line() +
	scale_y_continuous(name = "", labels = scales::percent_format()) +
	scale_x_continuous(name = "", breaks = seq(1990, 2000, 2)) +
	scale_color_discrete_qualitative(name = "Product", palette = "Dark2") +
	labs(title = "Cumulative Percent Change in Australian Production",
		 subtitle = "1990-2000") +
	theme_cowplot() 
filename <- "./content/post/2024-10-08-monthly-percentage-change-in-prod/aus_production_cum_pct.jpg"
ggsave(filename, width = 8, height = 6, dpi = 300)
# annual pct_change 
ap_long %>% 
	arrange(product, year) %>% 
	group_by(product) %>%
	mutate(base = lag(avg_volume),
		   diff = avg_volume - base,
		   pct = (diff / base)) %>% 
	replace_na(list(pct = 0)) -> ap_long_ann_pct

# plot
ap_long_ann_pct %>% 
	ggplot() +
	aes(x = year, y = pct, group = product, color = product) +
	geom_line() +
	scale_y_continuous(name = "", labels = scales::percent_format()) +
	scale_x_continuous(name = "", breaks = seq(1990, 2000, 2)) +
	scale_color_discrete_qualitative(name = "Product", palette = "Dark2") +
	labs(title = "Annual Percentage Change in Australian Production",
		 subtitle = "1990-2000") +
	theme_cowplot() 
