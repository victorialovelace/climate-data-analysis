events1980 <- read.csv("/Users/victorialovelace/Desktop/STAT3280/Project/StormEvents/1980StormEvents.csv")
events1985 <- read.csv("/Users/victorialovelace/Desktop/STAT3280/Project/StormEvents/1985StormEvents.csv")
events1990 <- read.csv("/Users/victorialovelace/Desktop/STAT3280/Project/StormEvents/1990StormEvents.csv")
events1995 <- read.csv("/Users/victorialovelace/Desktop/STAT3280/Project/StormEvents/1995StormEvents.csv")
events2000 <- read.csv("/Users/victorialovelace/Desktop/STAT3280/Project/StormEvents/2000StormEvents.csv")
events2005 <- read.csv("/Users/victorialovelace/Desktop/STAT3280/Project/StormEvents/2005StormEvents.csv")
events2010 <- read.csv("/Users/victorialovelace/Desktop/STAT3280/Project/StormEvents/2010StormEvents.csv")
events2015 <- read.csv("/Users/victorialovelace/Desktop/STAT3280/Project/StormEvents/2015StormEvents.csv")
events2020 <- read.csv("/Users/victorialovelace/Desktop/STAT3280/Project/StormEvents/2020StormEvents.csv")
events2024 <- read.csv("/Users/victorialovelace/Desktop/STAT3280/Project/StormEvents/2024StormEvents.csv")
#getting necessary columns from each stormEvent dataset
get_columns <- function(df){
  df %>%
    select(STATE, YEAR, EVENT_TYPE, INJURIES_DIRECT, INJURIES_INDIRECT, DEATHS_DIRECT, DEATHS_INDIRECT, DAMAGE_PROPERTY, DAMAGE_CROPS) %>%
    mutate(DAMAGE_PROPERTY = as.character(DAMAGE_PROPERTY),
           DAMAGE_CROPS = as.character(DAMAGE_CROPS)
    )
}

events1980_short <- get_columns(events1980)
events1985_short <- get_columns(events1985)
events1990_short <- get_columns(events1990)
events1995_short <- get_columns(events1995)
events2000_short <- get_columns(events2000)
events2005_short <- get_columns(events2005)
events2010_short <- get_columns(events2010)
events2015_short <- get_columns(events2015)
events2020_short <- get_columns(events2020)
events2024_short <- get_columns(events2024)

allEvents <- bind_rows(events1980_short, events1985_short, events1990_short, events1995_short, events2000_short, events2005_short, events2010_short, events2015_short, events2020_short, events2024_short)