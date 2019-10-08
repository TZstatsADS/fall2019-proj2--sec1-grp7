library(readr)
library(dplyr)
library(lubridate)


#Read in the data

#NYPD_Arrest_Data_Year_to_Date_ <- read_csv("~/data/NYPD_Arrest_Data__Year_to_Date_.csv")
#NYPD_Arrests_Data_Historic_ <- read_csv("~/data/NYPD_Arrests_Data__Historic_.csv")


#Data Cleaning and Summarization of Arrest Count

cleaned_NYPD_2019 <- NYPD_Arrest_Data_Year_to_Date_ %>%
  mutate(ARREST_DATE = lubridate::mdy(ARREST_DATE)) %>%
  group_by(ARREST_DATE,ARREST_BORO,ARREST_PRECINCT) %>%
  tally() %>%
  rename(Count = n) 


cleaned_NYPD_2018 <- NYPD_Arrests_Data_Historic_ %>%
  mutate(ARREST_DATE = lubridate::mdy(ARREST_DATE)) %>%
  filter(ARREST_DATE > "2018-09-02" & ARREST_DATE < "2019-01-01") %>%
  group_by(ARREST_DATE,ARREST_BORO,ARREST_PRECINCT) %>%
  tally() %>%
  rename(Count = n)

#Combining historic and 2019 data

cleaned_NYPD_Arrests <- rbind(cleaned_NYPD_2019,cleaned_NYPD_2018)


#Changing Police District ID to City Council District ID

cleaned.1 <- cleaned_NYPD_Arrests %>%
  mutate(CITY_COUNCIL_DISTRICT = if_else(ARREST_PRECINCT == 1 | 
                                           ARREST_PRECINCT == 5 |
                                           ARREST_PRECINCT == 6 |
                                           ARREST_PRECINCT == 7 |
                                           ARREST_PRECINCT == 9,"01",
                                         if_else(ARREST_PRECINCT == 13 |
                                                          ARREST_PRECINCT == 17,"02",
                                          if_else(ARREST_PRECINCT == 10 |
                                                           ARREST_PRECINCT == 14 |
                                                           ARREST_PRECINCT == 18,"03",
                                          if_else(ARREST_PRECINCT == 19,"04",
                                          if_else(ARREST_PRECINCT == 23,"05",
                                          if_else(ARREST_PRECINCT == 20 |
                                                            ARREST_PRECINCT == 24,"06",
                                          if_else(ARREST_PRECINCT == 30 |
                                                            ARREST_PRECINCT == 26 |
                                                            ARREST_PRECINCT == 33,"07",
                                          if_else(ARREST_PRECINCT == 25 |
                                                           ARREST_PRECINCT == 40,"08",
                                          if_else(ARREST_PRECINCT == 28 |
                                                           ARREST_PRECINCT == 32,"09",
                                          if_else(ARREST_PRECINCT == 34 |
                                                      ARREST_PRECINCT == 52 |
                                                      ARREST_PRECINCT == 50,"10",
                                          if_else(ARREST_PRECINCT == 47,"11",
                                          if_else(ARREST_PRECINCT == 49, "12",
                                          if_else(ARREST_PRECINCT == 43,"13",
                                          if_else(ARREST_PRECINCT == 46,"14",
                                          if_else(ARREST_PRECINCT == 48 |
                                                      ARREST_PRECINCT == 42,"15",
                                          if_else(ARREST_PRECINCT == 44,"16",
                                          if_else(ARREST_PRECINCT == 41,"17",
                                          if_else(ARREST_PRECINCT == 45,"18",
                                          if_else(ARREST_PRECINCT == 109,"19","NA")))))))))))))))))))) 

empty.rows <- cleaned.1 %>%
  filter(CITY_COUNCIL_DISTRICT == "NA")




cleaned.2 <- empty.rows %>%
  mutate(CITY_COUNCIL_DISTRICT = if_else(ARREST_PRECINCT == 111,"20",
                                          if_else(ARREST_PRECINCT == 110,"21",
                                          if_else(ARREST_PRECINCT == 114,"22",
                                          if_else(ARREST_PRECINCT == 107 |
                                                      ARREST_PRECINCT == 105,"23",
                                          if_else(ARREST_PRECINCT == 103,"24",
                                          if_else(ARREST_PRECINCT == 115,"25",
                                          if_else(ARREST_PRECINCT == 108,"26",
                                          if_else(ARREST_PRECINCT == 113,"27",
                                          if_else(ARREST_PRECINCT == 106 |
                                                      ARREST_PRECINCT == 102,"28",
                                          if_else(ARREST_PRECINCT == 112,"29",
                                          if_else(ARREST_PRECINCT == 104,"30",
                                          if_else(ARREST_PRECINCT == 101,"31",
                                          if_else(ARREST_PRECINCT == 100,"32",
                                          if_else(ARREST_PRECINCT == 94 |
                                                      ARREST_PRECINCT == 84 |
                                                      ARREST_PRECINCT == 88 | 
                                                      ARREST_PRECINCT == 90 |
                                                      ARREST_PRECINCT == 79 |
                                                      ARREST_PRECINCT == 78,"33",
                                          if_else(ARREST_PRECINCT == 83,"34",
                                          if_else(ARREST_PRECINCT == 77,"35",
                                          if_else(ARREST_PRECINCT == 81,"36",
                                          if_else(ARREST_PRECINCT == 75 |
                                                      ARREST_PRECINCT == 73,"37",
                                          if_else(ARREST_PRECINCT == 72,"38","NA")))))))))))))))))))) 


empty.rows <- cleaned.2 %>%
  filter(CITY_COUNCIL_DISTRICT == "NA")

cleaned.3 <- empty.rows %>%
  mutate(CITY_COUNCIL_DISTRICT = if_else(ARREST_PRECINCT == 76 |
                                                      ARREST_PRECINCT == 66,"39",
                                          if_else(ARREST_PRECINCT == 67,"40",
                                          if_else(ARREST_PRECINCT == 71,"41",
                                          if_else(ARREST_PRECINCT == 69,"42",
                                          if_else(ARREST_PRECINCT == 68,"43",
                                          if_else(ARREST_PRECINCT == 61,"44",
                                          if_else(ARREST_PRECINCT == 63,"45",
                                          if_else(ARREST_PRECINCT == 62,"46",
                                          if_else(ARREST_PRECINCT == 60,"47",
                                          if_else(ARREST_PRECINCT == 70,"48",
                                          if_else(ARREST_PRECINCT == 120 |
                                                      ARREST_PRECINCT == 121,"49",
                                          if_else(ARREST_PRECINCT == 122,"50","NA")))))))))))))

empty.rows <- cleaned.3 %>%
  filter(CITY_COUNCIL_DISTRICT == "NA")


cleaned.1 <- cleaned.1 %>%
  filter(CITY_COUNCIL_DISTRICT != "NA")

cleaned.2 <- cleaned.2 %>%
  filter(CITY_COUNCIL_DISTRICT != "NA")

cleaned.3 <- cleaned.3 %>%
  filter(CITY_COUNCIL_DISTRICT != "NA")


final.cleaned.arrests <- rbind(cleaned.1,cleaned.2,cleaned.3)

final.cleaned.arrests <- final.cleaned.arrests %>%
 group_by(ARREST_DATE,CITY_COUNCIL_DISTRICT) %>%
  summarise(Arrest.Count = sum(Count)) %>%
  rename(cd_id = CITY_COUNCIL_DISTRICT) %>%
  mutate(borough_id = if_else(cd_id %in% c("01","03","02","04","06","05","08","07","09","10","22","43"),
                                "1" ,
                              if_else(cd_id %in% c("08","17","15","13","16","18","14","11","12","10"),
                                      "2",
                              if_else(cd_id %in% c("38","37","35","33","34","36","47","44","46","45","39","40","43","42","48","41"),
                                      "3",
                              if_else(cd_id %in% c("19","09","32","31","28","24","30","23","26","21","20","29","27","22","25"),
                                      "4",
                              if_else(cd_id %in% c("49","50"),"5","NA")))))) %>%
  mutate(borough_cd_id = as.numeric(paste(borough_id, cd_id, sep = "")))


write.csv(final.cleaned.arrests,file = "~/cleaned_NYPD_Arrests.csv")

