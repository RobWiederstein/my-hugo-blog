library(fmsb)
library(dplyr)
library(tidyr)
df <- readRDS("./content/post/2023-01-11-building-energy-usage-exploratory-data-analysis/electric_usage.rds")
df1 <-
        df |> 
        mutate(hour = lubridate::hour(day), .after = day) |> 
        group_by(hour) |> 
        summarize(appliances = mean(appliances_avg),
               lights = mean(lights_avg)) |> 
        select(hour, appliances, lights) |> 
        ungroup() |> 
        t() |> 
        as.data.frame() |> 
        setNames(0:23) |> 
        filter(!row_number() %in% c(1))
df2 <- rbind(rep(200, 24), rep(0, 24), df1)
# The default radar chart 
radarchart(df2,
           pcol = colorspace::qualitative_hcl(2, palette = "Dark2"))
