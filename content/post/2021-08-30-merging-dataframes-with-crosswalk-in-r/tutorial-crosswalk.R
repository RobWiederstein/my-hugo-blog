# Part I - the Challenge ----
# I often work with localized data at the closest level.
# It's because it's interesting in that there's lots of 
# state and national level data, but there's little available,
# at say, the city and county level.  
# However, later in a project, you might want to change the level.  So
# how do you do that?  This series
# of posts is going to demonstrate how to do that and end with
# an example using the Census Core-Based Statistical Area (CBSA) 
# to Federal Information Processing Series (FIPS) County Crosswalk.

# Our fictional world is 6 cities, in 3 counties, in 2 states, in one nation.
# with population data in two years.Data I'm used to working with/preparing.
#
city <- tibble(city = 1:6,
               pop_2020 = 1,
               pop_2021 = 2)


# Let's say you want to group it differently?
# You are going to need a crosswalk. 

# Our crosswalk
crosswalk <- tibble(country = 1,
                 state = c(rep(1:2, 3)),
                 county= c(rep(1:3, 2)),
                 city = 1:6
)

crosswalk
# merge data using the crosswalk
df <- dplyr::left_join(crosswalk, city, by = "city")
df

# We'll group by different levels of government.

df %>% group_by(country) %>% summarize(total_pop_2020 = sum(pop_2020))
df %>% group_by(state) %>% summarize(total_pop_2020 = sum(pop_2020))
df %>% group_by(county) %>% summarize(total_pop_2020 = sum(pop_2020))

# Let's finalize it by grouping at the state level

df.1 <- 
        df %>% 
        group_by(state) %>% 
        summarize(total_2020 = sum(pop_2020),
                  total_2021 = sum(pop_2021)
                  )
# convert to long
df.2 <- df.1 %>% 
        tidyr::pivot_longer(!state, names_to = "name", values_to = "value")
# create year
df.3 <-
        df.2 %>% 
        separate(name, into = c("variable", "year"), sep = "_")

#https://www.nber.org/research/data/census-core-based-statistical-area-cbsa-federal-information-processing-series-fips-county-crosswalk

