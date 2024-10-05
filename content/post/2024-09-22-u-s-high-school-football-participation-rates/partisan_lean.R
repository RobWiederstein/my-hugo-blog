# libraries ----
library(magrittr)
library(dplyr)
library(ggplot2)
library(cowplot)
library(classInt)
library(tibble)
library(sf)

# load datasets ----
combine_datasets <- function(){
enrollment <- readRDS("./content/post/2024-09-22-u-s-high-school-football-participation-rates/enrollments.rds") %>% 
	filter(gender == "total")
participant <- readRDS("./content/post/2024-09-22-u-s-high-school-football-participation-rates/participants.rds")
full_join(participant, enrollment, by = join_by(year, state)) %>% 
	filter(year %in% c(2008, 2012, 2016, 2021)) %>% 
	mutate(year = ifelse(year == 2021, 2020, year)) -> football

file <- paste0("./content/post/2024-09-22-u-s-high-school-football",
"-participation-rates/1976-2020-president.csv")
readr::read_csv(
	file = file,
	show_col_types = FALSE,
	skip = 1
) %>% 
filter(party_detailed %in% c("REPUBLICAN")) %>% 
filter(year %in% c(2008, 2012, 2016, 2020)) %>% 
mutate(pct_repub = candidatevotes / totalvotes)	 %>% 
select(year, state_po, office, party_detailed, pct_repub) %>% 
	rename(state = state_po) -> partisan_lean
inner_join(football, partisan_lean, by = c("year", "state")) %>% 
mutate(part_rate = (players / enrollment) * 100) %>% 
select(year, state, part_rate, pct_repub ) %>% 
group_by(year) %>%
mutate(part_rate_scaled = scale(part_rate)) %>% 
mutate(pct_repub_scaled = scale(pct_repub))
}
df <- combine_datasets()
df %>% 
	filter(year %in% c(2008, 2020)) %>% 
	ggplot() +
	aes(pct_repub_scaled, part_rate_scaled) +
	geom_point() +
	geom_smooth(method = "lm") +
	scale_x_continuous(limits = c(-4, 4)) +
	scale_y_continuous(limits = c(-4, 4)) +
	facet_wrap(~year, nrow = 1) +
	theme_bw() +
	theme(aspect.ratio=1)

df %>%
filter(year == 2008) %>% 
lm(part_rate_scaled ~ pct_repub_scaled, data = .) %>% 
	summary() %>% 
	print()
