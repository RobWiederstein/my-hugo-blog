# libraries ----
library(magrittr)
library(dplyr)
library(ggplot2)
library(cowplot)
library(classInt)
library(tibble)
library(sf)

# load datasets ----
enrollment <- readRDS("./content/post/2024-09-22-u-s-high-school-football-participation-rates/enrollments.rds") %>% 
	filter(gender == "total")
participant <- readRDS("./content/post/2024-09-22-u-s-high-school-football-participation-rates/participants.rds")
inner_join(participant, enrollment, by = join_by(year, state)) -> a #%>% 
# row 52 enrollment is 2014 AR
a %>% 
	group_by(year) %>% 
	summarize(total_players = sum(players), 
			  total_enrollment = sum(enrollment)) %>% 
	mutate(players_per_100_students = (total_players / total_enrollment) * 100) %>% 
	ungroup() -> us_players_per_student
# annual us players ----
us_players_per_student %>%
	ggplot() +
	aes(year, players_per_100_students) +
	geom_rect(aes(xmin = 2018.1, xmax = 2020.9, 
				  ymin = -Inf, ymax = Inf), 
			  fill = "grey80", alpha = .05) +
	annotate(geom = "segment",
			 x = 2018, xend = 2021, 
			 y = 6.638134, yend = 6.326156, 
			 size = .5, color = "#00A396",
			 linetype = "dashed") +
	geom_line(color = "#00A396") +
	geom_point(color = "#00A396") +
	geom_vline(xintercept = 2015.95, color = "black", linetype = "dashed") +
	geom_vline(xintercept = 2013.75, color = "black", linetype = "dashed") +
	scale_x_continuous(name = "", limits = c(2005, 2022)) +
	scale_y_continuous(name = "Players / 100") +
	theme_half_open() -> p1
p1
# google trends ----
file <- paste0("./content/post/2024-09-22-u-s-high-school-football-",
"participation-rates/google_trends.csv")
google_trends <- readr::read_csv(
	file = file, 
	skip = 3, 
	name_repair = ~janitor::make_clean_names(.),
	show_col_types = FALSE) %>%
	mutate(month = as.Date(paste0(month, "-01"), format = "%Y-%m-%d")) %>%
	filter(month >= as.Date("2005-01-01")) %>% 
	filter(month <= as.Date("2022-01-01")) %>% 
	rename(concussions = football_concussion_united_states)
google_trends %>%
	ggplot() +
	aes(month, concussions) +
	geom_line(color = "grey80") +
	geom_smooth(method = "loess", color = "#00A396", se = FALSE) +
	geom_vline(xintercept = as.Date("2015-12-25"), color = "black", linetype = "dashed") +
	geom_vline(xintercept = as.Date("2013-10-08"), color = "black", linetype = "dashed") +
	scale_x_date(name = "") +
	theme_half_open() +
	theme(legend.position = "none") -> p2
p2
cowplot::plot_grid(p1, p2, ncol = 1, labels = c("A", "B"))
filename <- "~/Desktop/concussions.pdf"
ggsave(filename = filename, width = 8, height = 5, units = "in")
# state level ----
inner_join(participant, enrollment, by = join_by(year, state)) %>% 
group_by(year, state, sport) %>%
summarize(players_per_100_students = (players / enrollment) * 100) %>% 
ungroup() -> players_per_student
# rank ----
players_per_student %>% 
filter(year == max(year)) %>% 
arrange(desc(players_per_100_students)) %>% 
mutate(rank = row_number()) %>%
select(state, rank) -> rank_2022
# merge back ----
left_join(players_per_student, rank_2022, by = "state") -> players_per_student
# reorder ----
forcats::fct_reorder(
players_per_student$state, 
players_per_student$rank) -> players_per_student$state
# national players_per_student stats ----
inner_join(participant, enrollment, by = join_by(year, state)) %>% 
group_by(year, sport) %>%
summarize(total_players = sum(players), 
		  total_enrollment = sum(enrollment)) %>% 
mutate(players_per_100_students = (total_players / total_enrollment) * 100) %>% 
ungroup() -> us_players_per_student
# facet by state ----
players_per_student %>% 
filter(year > 2009) %>% 
ggplot() +
aes(year, players_per_100_students) +
geom_rect(aes(xmin = 2018.5, xmax = 2020.5, 
			  ymin = -Inf, ymax = Inf), fill = "grey80", alpha = .05) +
geom_line(color = "#C87A8A", ) +
geom_line(
	data = us_players_per_student %>% filter(year > 2009),
	mapping = aes(year, players_per_100_students), 
	color = "#00A396") +
scale_x_continuous(breaks = c(2010, 2014, 2018, 2022),
				   labels = c("10", "14", "18", "22")) +
theme_bw() +
facet_wrap(~state, ncol = 6)
paste0("./content/post/2024-09-22-u-s-high-school-football-",
"participation-rates/us_states_fb_players_per_student.pdf") -> filename
ggsave(filename, width = 8, height = 16, dpi = 300, units = "in")

#density ----
players_per_student %>% 
	filter(year == 2010) %>% 
	summarize(players_per_100_students = mean(players_per_100_students)) -> mean_2010
library(ggthemes)
players_per_student %>%
filter(year %in% c(2010, 2014, 2018, 2022)) %>%
mutate(year = as.factor(year)) %>%
ggplot() +
aes(players_per_100_students, group = year, fill = year) +
geom_density(color = "gray50", linewidth = .75) +
geom_vline(xintercept = mean_2010$players_per_100_students, 
		   color = "black", linetype = "dashed") +
scale_x_continuous(name = "players / 100 students") +
	scale_y_continuous(name = "density", expand = expansion(mult = c(0, 0.05))) +
scale_fill_manual(values = c("#FFC5D0", "#D4D8A7", "#99E2D8", "#D5D0FC")) +
facet_wrap(~year, ncol = 1) +
theme_cowplot() -> p1
p1

# histogram ----
library(ggthemes)
players_per_student %>%
filter(year %in% c(2010, 2014, 2018, 2022)) %>%
mutate(year = as.factor(year)) %>%
ggplot() +
aes(players_per_100_students, group = year, fill = year) +
geom_histogram(color = "gray50", binwidth = .5, linewidth = .75) +
geom_vline(xintercept = mean_2010$players_per_100_students, 
		   color = "black", linetype = "dashed") +
scale_x_continuous(name = "players / 100 students") +
scale_y_continuous(name = "count", expand = expansion(mult = c(0, 0.05))) +
scale_fill_manual(values = c("#FFC5D0", "#D4D8A7", "#99E2D8", "#D5D0FC")) +
facet_wrap(~year, ncol = 1) +
theme_cowplot() -> p2

p2
library(cowplot)
plot_grid(p1 + theme(legend.position = "none"),
		  p2 + theme(legend.position = "none"),
		  ncol = 2,
		  labels = c("A", "B"))
paste0("./content/post/2024-09-22-u-s-high-school-football-",
"participation-rates/us_states_fb_players_per_student_hist.pdf") -> filename
ggsave(filename, width = 8, height = 5, dpi = 300, units = "in")

# map 2022 participation rate----
us_states <- readRDS("./content/post/2024-09-22-u-s-high-school-football-participation-rates/us_states.rds")
players_per_student %>%
group_by(year) %>% 
mutate(quintile = cut_number(players_per_100_students, n = 5)) %>%
filter(year %in% c(2022)) -> fb_2022
# color
values <- colorspace::sequential_hcl(n = 5, palette = "YlGnBu", rev = T)
# 2022 map
left_join(us_states, fb_2022, by = c("state" = "state")) %>%
ggplot() +
aes(fill = quintile) +
geom_sf(color = "gray50") +
theme_void() +
labs(title = paste0()) +
scale_fill_manual(name = "Players / 100 \nstudents", values = values)
paste0("./content/post/2024-09-22-u-s-high-school-football-",
	   "participation-rates/map_us_states_fb_players_per_student.pdf") -> filename
ggsave(filename = filename, width = 8, height = 5, dpi = 300, units = "in")

# map difference 2010 vs 2022 ----
values <- colorspace::sequential_hcl(n = 5, palette = "YlGnBu", rev = F)
players_per_student %>% 
filter(year %in% c(2010, 2022)) %>% 
pivot_wider(names_from = year, values_from = players_per_100_students) %>%
mutate(change = `2022` - `2010`) %>% 
mutate(percent_change = (change / `2010`) * 100) %>%
mutate(quintile = cut_number(change, n = 5)) -> states_2010_vs_2022
file <- paste0("./content/post/2024-09-22-u-s-high-school-football-",
			   "participation-rates/states_2010_vs_2022.rds")
saveRDS(states_2010_vs_2022, file = file)

left_join(us_states, states_2010_vs_2022, by = c("state" = "state")) %>%
	ggplot() +
	aes(fill = quintile) +
	geom_sf(color = "gray50") +
	theme_void() +
	scale_fill_manual(name = "Change in Players / 100 \nstudents", values = values) +
	labs(title = )
paste0(
	"./content/post/2024-09-22-u-s-high-school-football-",
	"participation-rates/map_us_states_fb_diff.pdf") -> filename
ggsave(filename, width = 8, height = 5, dpi = 300, units = "in")
	