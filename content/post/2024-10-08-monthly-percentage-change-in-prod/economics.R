library(ggplot2)
library(colorspace)
head(economics)
economics %>% 
	pivot_longer(
		cols = c(pce:unemploy), 
		names_to = "indicator", 
		values_to = "value") %>% 
	as_tsibble(index = date, key = indicator) %>% 
	
	index_by(year_month = ~ yearmonth(.)) %>%
	group_by(indicator) %>% 
	summarise(value = mean(value)) %>% 
	filter_index("2005-01-01" ~ "2014-12-01") -> econ_long

econ_long %>%
	arrange(indicator, year_month) %>% 
	group_by(indicator) %>% 
	mutate(base = first(value),
		   diff = value - base,
		   pct = diff / base) -> econ_cum_ann_pct

econ_cum_ann_pct %>%
	ggplot() +
	aes(year_month, pct, color = indicator) +
	geom_rect(aes(xmin = as.Date("2007-12-31"),
				  xmax = as.Date("2009-06-01"),
				  ymin = -Inf, 
				  ymax = Inf 
	), fill = "gray90", color = "gray90", alpha = 0.1) +
	annotate("text", x = as.Date("2008-10-01"), y = -0.45, label = "Great Recession", size = 4) +
	geom_line() +
	scale_color_discrete_qualitative(name = "Indicator", palette = "Dark2") +
	scale_x_yearmonth(name = "") +
	scale_y_continuous(name = "", label = scales::label_percent()) +
	theme_minimal() +
	theme_cowplot() +
	labs(title = "U.S. Economic Indicators",
		 subtitle = "Cumulative Annual Percentage Change") 

econ_long %>% 
	arrange(indicator, year_month) %>% 
	group_by(indicator) %>% 
	mutate(base = lag(value),
		   diff = value - base,
		   pct = diff / base) -> econ_avg_ann_pct

econ_avg_ann_pct %>% 
	ggplot() +
	aes(year_month, pct, color = indicator) +
	geom_rect(aes(xmin = as.Date("2007-12-31"),
				  xmax = as.Date("2009-06-01"),
				  ymin = -Inf, 
				  ymax = Inf 
				  ), fill = "gray90", color = "gray90", alpha = 0.1) +
	annotate("text", x = as.Date("2008-10-01"), y = -0.45, label = "Great Recession", size = 4) +
	geom_line() +
	scale_color_discrete_qualitative(name = "Indicator", palette = "Dark2") +
	scale_x_yearmonth(name = "") +
	scale_y_continuous(name = "", label = scales::label_percent()) +
	theme_minimal() +
	theme_cowplot() +
	labs(title = "U.S. Economic Indicators",
		 subtitle = "Average Annual Percentage Change")

