library(readr)
library(dplyr)
library(lubridate)

#Read in the data

NYPD_Arrest_Data_Year_to_Date_ <- read_csv("~/data/NYPD_Arrest_Data__Year_to_Date_.csv")
NYPD_Arrests_Data_Historic_ <- read_csv("~/data/NYPD_Arrests_Data__Historic_.csv")


#Data Cleaning and Summarization of Arrest Count

cleaned_NYPD_2019 <- NYPD_Arrest_Data_Year_to_Date_ %>%
  mutate(ARREST_DATE = lubridate::mdy(ARREST_DATE)) %>%
  group_by(ARREST_DATE,ARREST_PRECINCT) %>%
  tally() %>%
  rename(Count = n) 


cleaned_NYPD_2018 <- NYPD_Arrests_Data_Historic_ %>%
  mutate(ARREST_DATE = lubridate::mdy(ARREST_DATE)) %>%
  filter(ARREST_DATE > "2018-09-02" & ARREST_DATE < "2019-01-01") %>%
  group_by(ARREST_DATE,ARREST_PRECINCT) %>%
  tally() %>%
  rename(Count = n)

#Combining historic and 2019 data

cleaned_NYPD_Arrests <- rbind(cleaned_NYPD_2019,cleaned_NYPD_2018)

write.csv(cleaned_NYPD_Arrests,file = "~/output/cleaned_NYPD_Arrests.csv")


