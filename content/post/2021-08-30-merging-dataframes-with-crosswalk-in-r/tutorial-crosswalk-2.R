file <- "https://data.nber.org/cbsa-csa-fips-county-crosswalk/cbsa2fipsxw.csv"
df <- readr::read_csv(file = file, col_types = cols(.default = "c"))
df <- df[-1, ]
skimr::skim(df)
table(df$metropolitanmicropolitanstatis)
# substitute for this == way too wordy
table(df$centraloutlyingcounty)
# merge for central, outlying, rural?
table(df$metropolitanmicropolitanstatis, df$centraloutlyingcounty)
df.1 <-
        df %>%
        dplyr::filter(statename == "North Dakota") %>%
        tidyr::unite("fips", fipsstatecode:fipscountycode, sep = "") %>%
        dplyr::arrange(metropolitanmicropolitanstatis, cbsacode)
##----------------------------------------------------------------
#https://www.census.gov/programs-surveys/metro-micro.html
file <- "https://data.nber.org/cbsa-csa-fips-county-crosswalk/cbsa2fipsxw.csv"
df <- readr::read_csv(file = file, col_types = cols(.default = "c"))

cbsa_codes <-
        df %>% 
        janitor::remove_empty() %>% 
        select(fipsstatecode,fipscountycode, centraloutlyingcounty,
               metropolitanmicropolitanstatis) %>% 
        rename(state = fipsstatecode,
               county = fipscountycode,
               class = centraloutlyingcounty,
               status = metropolitanmicropolitanstatis) %>% 
        tidyr::unite("fips", state:county, sep = "") %>% 
        tidyr::unite("cbsa_desig", c(status, class), sep = "-") %>% 
        dplyr::mutate(cbsa_desig = cbsa_desig %>%  tolower) %>% 
        dplyr::mutate(cbsa_desig = gsub("politan statistical area", "", cbsa_desig))
