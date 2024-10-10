# combine with enrollments
part <- readRDS("./content/post/2024-10-05-forecasting-u-s-high-school-football-participation/participants.rds")
enrl <- readRDS("./content/post/2024-10-05-forecasting-u-s-high-school-football-participation/enrollments.rds") %>% 
	filter(gender == "total") %>% 
	select(!gender) %>% 
	rename(students = enrollment)
full_join(part, enrl, by = join_by(year, state)) %>% 
	mutate(players_per_100 = (players / students) * 100) -> combined
# boxplot
combined %>% 
	ggplot() +
	aes(x = year, y = players_per_100, group = year) +
	geom_rect(aes(xmin = 2018.75, xmax = 2020.25, ymin = -Inf, ymax = Inf),
			  fill = "gray90", alpha = .95) +
	#range limited due to NC
	scale_y_continuous(name = "pp_100 ",
					   limits = c(0, 30.5)) +
	scale_x_continuous(name = "", 
					   limits = c(2002, 2023),
					   expand = expansion(mult = c(0, 0.05))) +
	geom_text(aes(x = 2019.5, y = 15, label = "COVID-19"), angle = -90, size = 5) +
	geom_boxplot() +
	theme_half_open() -> p1
p1
# outliers 1.5 IQR
combined %>% 
	group_by(year) %>%
	#calculate z-scores
	mutate(pp100 = ((players_per_100 - mean(players_per_100, na.rm=TRUE)) /
						sd(players_per_100, na.rm=TRUE))) %>% 
	mutate(q25 = quantile(pp100, probs = c(.25), na.rm = T)) %>% 
	mutate(q75 = quantile(pp100, probs = c(.75), na.rm = T)) %>% 
	mutate(iqr = q75 - q25) %>% 
	rowwise() %>% 
	mutate(ub = q75 + (1.5 * iqr)) %>% 
	mutate(lb = q25 - (1.5 * iqr)) %>% 
	ungroup() %>% 
	mutate(outlier = ifelse(pp100 < lb | pp100 > ub, "TRUE", "FALSE")) -> outliers
# plot outliers
outliers %>% 
	ggplot() +
	aes(x = year, y = pp100, group = year) +
	geom_boxplot(outlier.shape = NA) +
	geom_text(outliers %>% filter(outlier == "TRUE"),
			  mapping = aes( x = year, y = pp100, label = state),
			  hjust = .5, vjust = -.1, color = "#56B4E9") +
	geom_rect(aes(xmin = 2018.75, xmax = 2020.25, ymin = -Inf, ymax = Inf),
			  fill = "gray90", alpha = .95) +
	geom_text(aes(x = 2019.5, y = 4, label = "COVID-19"), angle = -90, size = 5) +
	scale_x_continuous(name = "", 
					   limits = c(2002, 2023),
					   expand = expansion(mult = c(0, 0.05))) +
	scale_y_continuous(name = "pp_100 (Z-score)",
					   limits = c(0, 7.5)) +
	theme_half_open() -> p2
p2
# plot outliers removed
outliers %>% 
	filter(outlier == "FALSE") %>% 
	ggplot() +
	aes(x = year, y = players_per_100, group = year) +
	geom_boxplot() +
	geom_rect(aes(xmin = 2018.75, xmax = 2020.25, ymin = -Inf, ymax = Inf), 
			  fill = "gray90", alpha = .95) +
	geom_text(aes(x = 2019.5, y = 8, label = "COVID-19"), angle = -90, size = 5) +
	scale_x_continuous(name = "", 
					   limits = c(2002, 2023),
					   expand = expansion(mult = c(0, 0.05))) +
	scale_y_continuous(name = "pp_100") +
	theme_half_open() -> p3
p3
cowplot::plot_grid(p1, p2, p3, 
				   ncol = 1, 
				   align = "h",
				   axis = "b",
				   labels = c("A", "B", "C"))
filename <- paste0(
	"./content/post/2024-10-05-forecasting-u-s-high-school-football-",
	"participation/pp100_boxplots.jpg")
ggsave(filename, height = 8, width = 8, dpi = 300, units = "in")
# plot w and w/o outliers ----
## without outliers ----
outliers %>% 
	filter(grepl("FALSE", outlier)) %>%
	group_by(year) %>%
	summarise(n = n(),
			  players = sum(players, na.rm = T),
			  students = sum(students, na.rm = T)) %>% 
	mutate(pp100 = (players / students) * 100) -> outliers_F
## with outliers ----
outliers %>% 
	tidyr::drop_na() %>% 
	group_by(year) %>%
	summarise(n = n(),
			  players = sum(players, na.rm = T),
			  students = sum(students, na.rm = T)) %>%
	mutate(pp100 = (players / students) * 100) -> outliers_T

## plot with and without outliers ----
outliers_F %>%
	ggplot() +
	aes(x = year, y = pp100) +
	geom_rect(aes(xmin = 2018.75, xmax = 2020.25, ymin = -Inf, ymax = Inf), 
			  fill = "gray90", alpha = .95) +
	geom_text(aes(x = 2019.5, y = 7, label = "COVID-19"), angle = -90, size = 5) +
	geom_line() +
	geom_line(data = outliers_T, aes(x = year, y = pp100), color = "#56B4E9") +
	scale_y_continuous(name = "Players / 100 students") +
	scale_x_continuous(name = "") +
	geom_text(x = 2012.25, y = 7, label = "Outliers removed", color = "black", size = 5) +
	geom_text(x = 2014, y = 7.5, label = "Outliers retained", color = "#56B4E9", size = 5) +
	theme_half_open()
filename <- paste0(
	"./content/post/2024-10-05-forecasting-u-s-high-school-football-",
	"participation/trend_w_outliers.jpg"
)
ggsave(filename = filename, height = 5, width = 8, unit = "in", dpi = 300)
# convert to time series
library(tsibble)
tribble(
	~year, ~pp100,
	2019, NA,
	2020, NA
) -> missing_data 
outliers_F %>% 
	select(year, pp100) %>% 
	bind_rows(missing_data) %>% 
	arrange(year) %>% 
	#interpolate missing values
	mutate(pp100 = zoo::na.approx(pp100)) %>%
	tsibble(index = year) -> fb_ts
saveRDS(fb_ts, "./data/football_ts.rds")
fb_ts
# forecast
library(fable)
library(fpp3)
#split
fb_train <- fb_ts |> filter(year %in% 2003:2017)
fb_test <- fb_ts |> filter(year %in% 2018:2020)
#fit
library(fable)
library(fable.prophet)
fb_fit <- fb_train |> 
	model(`mean` = MEAN(pp100),
		  `naive` = NAIVE(pp100),
		  `drift` = RW(pp100 ~ drift()),
		  `arima` = ARIMA(pp100),
		  `ets` = ETS(pp100),
		  `nnetar` = NNETAR(pp100),
		  `croston` = CROSTON(pp100),
		  `theta` = THETA(pp100),
		  `prophet` = prophet(pp100 ~ season(period = 1, order = 2,
		  								  type = "multiplicative"))
	)
#forecast
fb_fc <- fb_fit |> forecast(h = 5)

# plot
values = colorspace::qualitative_hcl(n = 5, palette = "pastel")
fb_fc %>% 
	autoplot(fb_ts,
			 level = NULL) + 
	theme_cowplot() +
	scale_y_continuous(name = "Players / 100 students") +
	scale_x_continuous(name = "")
filename <- paste0(
	"./content/post/2024-10-05-forecasting-u-s-high-school-football-",
	"participation/forecast_models_compared.jpg"
)
ggsave(filename, height = 5, width = 8, unit = "in", dpi = 300)
# accuracy
(accuracy(fb_fc, fb_ts) %>% 
	arrange(RMSE) -> tbl_accuracy)
paste0(
	"./content/post/2024-10-05-forecasting-u-s-high-school-football-",
	"participation/tbl_accuracy.rds"
) -> file
saveRDS(tbl_accuracy, file = file)
# predict

fb_fit <- fb_ts %>% 
	model(`prophet` =  prophet(pp100 ~ season(period = 1, order = 2,
											  type = "multiplicative")))
fb_fc <- fb_fit %>% forecast(h = 5)
fb_fc %>% 
	autoplot(fb_ts) + 
	theme_cowplot() + 
	scale_x_continuous(
		name = "",
		breaks = seq(2005, 2030, 5)
	) +
	scale_y_continuous(
		name = "Players / 100 students"
	)
filename <- paste0(
	"./content/post/2024-10-05-forecasting-u-s-high-school-football-participation/",
	"football_participation_forecast.jpg"
)
ggsave(filename = filename, height = 5, width = 8, units = "in", dpi = 300)
