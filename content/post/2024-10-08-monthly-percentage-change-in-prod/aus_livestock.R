aus_livestock %>% 
	rename_with(~ tolower(.)) %>%
	filter(!state %in% c("Australian Capital Territory",
						"Northern Territory")) %>%
	filter_index("2008 Jan" ~ "2018 Dec") %>% 
	index_by(year = year(month)) %>% 
	group_by(year, animal, state) %>% 
	summarize(total = sum(count)) %>% 
	arrange(state, year, animal) -> al_long

al_long %>% 
	ggplot() +
	aes(year, total, group = animal, color = animal) +
	geom_line() +
	labs(title = "Australian Livestock Slaughter",
		 subtitle = "2008-2018") +
	scale_x_continuous(name = "", breaks = c(2008, 2013, 2018)) +
	scale_y_continuous(name = "", breaks = c(0, 3e6, 6e6, 9e6), 
					   label = c("0m", "3m", "6m", "9m")) +
	colorspace::scale_color_discrete_qualitative(name = "Livestock", palette = "Dark2") +
	facet_wrap(~state,  ncol = 2) +
	theme_bw()

al_long %>%
	arrange(state, animal) %>% 
	group_by(state, animal) %>%
	mutate(base = first(total),
		   diff = total-base, 
		   pct = diff / base) -> al_ann_cum_pct
al_ann_cum_pct %>% 
	ggplot() +
	aes(year, pct, color = animal) +
	scale_y_continuous(name = "", labels = scales::percent) +
	scale_x_continuous(name = "", breaks = c(2008, 2013, 2018)) +
	colorspace::scale_color_discrete_qualitative(name = "Livestock", palette = "Dark2") +
	geom_line() +
	labs(title = "Australian Livestock Slaughter",
		 subtitle = "Cumulative Percentage Change") +
	facet_wrap(. ~ state, ncol = 2) +
	theme_bw()

al_long %>%
	arrange(state, animal) %>% 
	group_by(state, animal) %>%
	mutate(base = lag(total),
		   diff = total-base, 
		   pct = diff / base) %>% 
	replace_na(list(pct = 0)) -> al_ann_pct

al_ann_pct %>%
	ggplot() +
	aes(year, pct, color = animal) +
	scale_y_continuous(name = "", labels = scales::percent) +
	scale_x_continuous(name = "", breaks = c(2008, 2013, 2018)) +
	colorspace::scale_color_discrete_qualitative(name = "Livestock", palette = "Dark2") +
	geom_line() +
	facet_wrap(. ~ state, ncol = 2) +
	labs(title = "Australian Livestock Slaughter",
		 subtitle = "Annual Percentage Change") +
	theme_bw()

