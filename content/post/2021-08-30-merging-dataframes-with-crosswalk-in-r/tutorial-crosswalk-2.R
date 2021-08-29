file <- "https://data.nber.org/cbsa-csa-fips-county-crosswalk/cbsa2fipsxw.csv"
df <- readr::read_csv(file = file)
df.1 <-
        df %>%
        dplyr::filter(statename == "North Dakota") %>%
        tidyr::unite("fips", fipsstatecode:fipscountycode, sep = "") %>%
        dplyr::arrange(metropolitanmicropolitanstatis, cbsacode)
