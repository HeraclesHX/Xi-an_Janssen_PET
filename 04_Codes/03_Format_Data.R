# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ProjectName:  Xi'an Jassen PET
# Purpose:      Format the data for the plot described in PPT
# programmer:   Xin Huang
# Date:         06-20-2017
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

library(openxlsx)
library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyr)


##-- generate the data for the report

#- here is the eda data
eda_dat_tgt <- eda_dat %>%
  filter(target.department == "Y") %>%
  select(doctorid, department, hospital, region, hcp.major,
         most.recent.modify.date.m) %>%
  mutate(Year = substr(most.recent.modify.date.m, 1, 4),
         Quarter = ifelse(as.numeric(substr(most.recent.modify.date.m, 6, 7)) %in%
                            c(1, 2, 3),
                          "Q1", 
                          ifelse(as.numeric(substr(most.recent.modify.date.m, 6, 7)) %in% 
                                   c(4, 5, 6),
                                       "Q2",
                                       ifelse(as.numeric(substr(most.recent.modify.date.m, 6, 7)) %in% 
                                                c(7, 8, 9),
                                              "Q3",
                                              "Q4")))) %>%
  distinct() %>%
  arrange(doctorid, most.recent.modify.date.m) %>%
  group_by(doctorid, Year, Quarter) %>%
  filter(row_number() == n()) %>%
  ungroup() %>%
  mutate(region = toupper(region))
  
#- here is the doc tier information
doc_tier <- call_dat %>%
  select(doctorid, doctor.tier, call.date) %>%
  mutate(doctorid = as.character(doctorid),
         Year = substr(call.date, 1, 4),
         Quarter = ifelse(as.numeric(substr(call.date, 6, 7)) %in% c(1, 2, 3),
                          "Q1", 
                          ifelse(as.numeric(substr(call.date, 6, 7)) %in% c(4, 5, 6),
                                 "Q2",
                                 ifelse(as.numeric(substr(call.date, 6, 7)) %in% c(7, 8, 9),
                                        "Q3",
                                        "Q4")))) %>%
  arrange(doctorid, call.date) %>%
  distinct() %>%
  group_by(doctorid, Year, Quarter) %>%
  filter(row_number() == n()) %>% 
  group_by(doctorid) %>%
  filter(row_number() == n()) %>%
  ungroup() %>%
  select(doctorid, doctor.tier)
  

#- merge the eda data with the doc information
eda_dat_tgt_with_tier <- eda_dat_tgt %>%
  left_join(doc_tier, by = c("doctorid"))

table(eda_dat_tgt_with_tier$doctor.tier, useNA = "always")
# A    B    C    U    <NA> 
# 591  584  577  134  222 

#- filter out the docs who are not tier A and B
#- calculate the doc cnt by quarter
doc_cnt_qtr <- eda_dat_tgt_with_tier %>%
  # filter(doctor.tier %in% c("A", "B")) %>%
  group_by(Year, Quarter) %>%
  summarise(doc_cnt = n())

#- calculate the region distribution of doc
doc_region_dist_qtr <- eda_dat_tgt_with_tier %>%
  # filter(doctor.tier %in% c("A", "B")) %>%
  group_by(Year, Quarter, region) %>%
  summarise(doc_cnt = n()) %>%
  group_by(Year, Quarter) %>%
  mutate(doc_cnt_total = sum(doc_cnt),
         doc_cnt_pct = doc_cnt / doc_cnt_total) %>%
  ungroup()


#- calculate the tier distribution of doc
doc_tier_dist_qtr <- eda_dat_tgt_with_tier %>%
  # filter(doctor.tier %in% c("A", "B")) %>%
  group_by(Year, Quarter, doctor.tier) %>%
  summarise(doc_cnt = n()) %>%
  group_by(Year, Quarter) %>%
  mutate(doc_cnt_total = sum(doc_cnt),
         doc_cnt_pct = doc_cnt / doc_cnt_total) %>%
  ungroup()

#- calculate the department distribution of doc
doc_department_dist_qtr <- eda_dat_tgt_with_tier %>%
  # filter(doctor.tier %in% c("A", "B")) %>%
  group_by(Year, Quarter, department) %>%
  summarise(doc_cnt = n()) %>%
  group_by(Year, Quarter) %>%
  mutate(doc_cnt_total = sum(doc_cnt),
         doc_cnt_pct = doc_cnt / doc_cnt_total) %>%
  ungroup()


#- calculate the change trend of perception score of doc
doc_perception_score_qtr <- eda_dat_tgt_with_tier %>%
  # filter(doctor.tier %in% c("A", "B")) %>%
  group_by(Year, Quarter, hcp.major) %>%
  summarise(doc_cnt = n()) %>%
  group_by(Year, Quarter) %>%
  mutate(doc_cnt_total = sum(doc_cnt),
         doc_cnt_pct = doc_cnt / doc_cnt_total) %>%
  ungroup()

#- calculate the change trend of perception score of doc by region
doc_perception_score_region_qtr <- eda_dat_tgt_with_tier %>%
  # filter(doctor.tier %in% c("A", "B")) %>%
  group_by(Year, Quarter, region, hcp.major) %>%
  summarise(doc_cnt = n()) %>%
  group_by(Year, Quarter, region) %>%
  mutate(doc_cnt_total = sum(doc_cnt),
         doc_cnt_pct = doc_cnt / doc_cnt_total) %>%
  group_by(Year, Quarter, hcp.major) %>%
  do(plyr::rbind.fill(., data.frame(Year = first(.$Year),
                                    Quarter = first(.$Quarter),
                                    region = "National",
                                    hcp.major = first(.$hcp.major),
                                    doc_cnt = sum(.$doc_cnt, na.rm = TRUE),
                                    doc_cnt_total = sum(.$doc_cnt_total, na.rm = TRUE),
                                    doc_cnt_pct = sum(.$doc_cnt, na.rm = TRUE)/
                                      sum(.$doc_cnt_total, na.rm = TRUE)))) %>%
  left_join(doc_cnt_qtr, by = c("Year", "Quarter")) %>%
  mutate(doc_cnt_pct = ifelse(region == "National", 
                              doc_cnt.x / doc_cnt.y,
                              doc_cnt_pct)) %>%
  ungroup()

#- calculate the change trend of perception score of doc by doc tier
doc_perception_score_tier_qtr <- eda_dat_tgt_with_tier %>%
  # filter(doctor.tier %in% c("A", "B")) %>%
  group_by(Year, Quarter, doctor.tier, hcp.major) %>%
  summarise(doc_cnt = n()) %>%
  group_by(Year, Quarter, doctor.tier) %>%
  mutate(doc_cnt_total = sum(doc_cnt),
         doc_cnt_pct = doc_cnt / doc_cnt_total) %>%
  group_by(Year, Quarter, hcp.major) %>%
  do(plyr::rbind.fill(., data.frame(Year = first(.$Year),
                                    Quarter = first(.$Quarter),
                                    doctor.tier = "All Physicians",
                                    hcp.major = first(.$hcp.major),
                                    doc_cnt = sum(.$doc_cnt, na.rm = TRUE),
                                    doc_cnt_total = sum(.$doc_cnt_total, na.rm = TRUE),
                                    doc_cnt_pct = sum(.$doc_cnt, na.rm = TRUE)/
                                      sum(.$doc_cnt_total, na.rm = TRUE)))) %>%
  left_join(doc_cnt_qtr, by = c("Year", "Quarter")) %>%
  mutate(doc_cnt_pct = ifelse(doctor.tier == "All Physicians", 
                              doc_cnt.x / doc_cnt.y,
                              doc_cnt_pct)) %>%
  ungroup()

doc_perception_score_tier_qtr$doctor.tier <-
  factor(doc_perception_score_tier_qtr$doctor.tier,
         levels = c("All Physicians", "A", "B", "C", "U", NA))


#- calculate the change trend of perception score of doc by department
doc_perception_score_department_qtr <- eda_dat_tgt_with_tier %>%
  # filter(doctor.tier %in% c("A", "B")) %>%
  group_by(Year, Quarter, department, hcp.major) %>%
  summarise(doc_cnt = n()) %>%
  group_by(Year, Quarter, department) %>%
  mutate(doc_cnt_total = sum(doc_cnt),
         doc_cnt_pct = doc_cnt / doc_cnt_total) %>%
  group_by(Year, Quarter, hcp.major) %>%
  do(plyr::rbind.fill(., data.frame(Year = first(.$Year),
                                    Quarter = first(.$Quarter),
                                    department = "All Department",
                                    hcp.major = first(.$hcp.major),
                                    doc_cnt = sum(.$doc_cnt, na.rm = TRUE),
                                    doc_cnt_total = sum(.$doc_cnt_total, na.rm = TRUE),
                                    doc_cnt_pct = sum(.$doc_cnt, na.rm = TRUE)/
                                      sum(.$doc_cnt_total, na.rm = TRUE)))) %>%
  left_join(doc_cnt_qtr, by = c("Year", "Quarter")) %>%
  mutate(doc_cnt_pct = ifelse(department == "All Department", 
                              doc_cnt.x / doc_cnt.y,
                              doc_cnt_pct)) %>%
  ungroup()



##-- for the 15th and 16th question 
eda_dat_15_q <- eda_dat %>%
  filter(target.department == "Y",
         substr(questions, 1, 3) == "Q15") %>%
  select(doctorid, department, hospital, region, hcp.major, questions, answers,
         most.recent.modify.date.m) %>%
  left_join(doc_tier, by = c("doctorid")) %>%
  # filter(doctor.tier %in% c("A", "B")) %>%
  mutate(Year = substr(most.recent.modify.date.m, 1, 4),
         Quarter = ifelse(as.numeric(substr(most.recent.modify.date.m, 6, 7)) %in% c(1, 2, 3),
                          "Q1", 
                          ifelse(as.numeric(substr(most.recent.modify.date.m, 6, 7)) %in% c(4, 5, 6),
                                 "Q2",
                                 ifelse(as.numeric(substr(most.recent.modify.date.m, 6, 7)) %in% c(7, 8, 9),
                                        "Q3",
                                        "Q4")))) %>%
  distinct() %>%
  arrange(doctorid, most.recent.modify.date.m) %>%
  group_by(doctorid, Year, Quarter) %>%
  filter(row_number() == n()) %>%
  ungroup() %>%
  group_by(Year, Quarter, hcp.major) %>%
  mutate(doc_cnt_total = n()) %>%
  separate_rows(answers, sep = ";") %>%
  group_by(Year, Quarter, hcp.major, answers, doc_cnt_total) %>%
  summarise(doc_cnt = n()) %>%
  mutate(doc_cnt_pct = doc_cnt / doc_cnt_total) %>%
  group_by(Year, Quarter, answers) %>%
  do(plyr::rbind.fill(., data.frame(Year = first(.$Year),
                                    Quarter = first(.$Quarter),
                                    hcp.major = "Overall",
                                    answers = first(.$answers),
                                    doc_cnt = sum(.$doc_cnt, na.rm = TRUE),
                                    doc_cnt_total = sum(.$doc_cnt_total, na.rm = TRUE),
                                    doc_cnt_pct = sum(.$doc_cnt, na.rm = TRUE)/
                                      sum(.$doc_cnt_total, na.rm = TRUE)))) %>%
  ungroup()


eda_dat_16_q <- eda_dat %>%
  filter(target.department == "Y",
         substr(questions, 1, 3) == "Q16") %>%
  select(doctorid, department, hospital, region, hcp.major, questions, answers,
         most.recent.modify.date.m) %>%
  left_join(doc_tier, by = c("doctorid")) %>%
  # filter(doctor.tier %in% c("A", "B")) %>%
  mutate(Year = substr(most.recent.modify.date.m, 1, 4),
         Quarter = ifelse(as.numeric(substr(most.recent.modify.date.m, 6, 7)) %in% c(1, 2, 3),
                          "Q1", 
                          ifelse(as.numeric(substr(most.recent.modify.date.m, 6, 7)) %in% c(4, 5, 6),
                                 "Q2",
                                 ifelse(as.numeric(substr(most.recent.modify.date.m, 6, 7)) %in% c(7, 8, 9),
                                        "Q3",
                                        "Q4")))) %>%
  distinct() %>%
  arrange(doctorid, most.recent.modify.date.m) %>%
  group_by(doctorid, Year, Quarter) %>%
  filter(row_number() == n()) %>%
  ungroup() %>%
  group_by(Year, Quarter, hcp.major) %>%
  mutate(doc_cnt_total = n()) %>%
  separate_rows(answers, sep = ";") %>%
  group_by(Year, Quarter, hcp.major, answers, doc_cnt_total) %>%
  summarise(doc_cnt = n()) %>%
  mutate(doc_cnt_pct = doc_cnt / doc_cnt_total) %>%
  group_by(Year, Quarter, answers) %>%
  do(plyr::rbind.fill(., data.frame(Year = first(.$Year),
                                    Quarter = first(.$Quarter),
                                    hcp.major = "Overall",
                                    answers = first(.$answers),
                                    doc_cnt = sum(.$doc_cnt, na.rm = TRUE),
                                    doc_cnt_total = sum(.$doc_cnt_total, na.rm = TRUE),
                                    doc_cnt_pct = sum(.$doc_cnt, na.rm = TRUE)/
                                      sum(.$doc_cnt_total, na.rm = TRUE))))%>%
  ungroup()

##-- the summary of doc with perception score increased
smmy_psc_qtr <- eda_dat_tgt %>%
  left_join(doc_tier, by = c("doctorid")) %>%
  # filter(doctor.tier %in% c("A", "B")) %>%
  mutate(quarter = paste(Year, Quarter, sep = "_"),
         hcp.major = as.numeric(hcp.major)) %>%
  select(-Year, -Quarter, -most.recent.modify.date.m) %>%
  spread(quarter, hcp.major) %>%
  mutate(`2016_Q4_adv` = 
           ifelse(ifelse(is.na(`2016_Q4`), 1, `2016_Q4`) - 
                    ifelse(is.na(`2016_Q3`), 1, `2016_Q3`) > 0, 1, 0),
         `2017_Q1_adv` = 
           ifelse(ifelse(is.na(`2017_Q1`), 1, `2017_Q1`) - 
                    ifelse(is.na(`2016_Q4`), 1, `2016_Q4`) > 0, 1, 0),
         `2017_Q2_adv` = 
           ifelse(ifelse(is.na(`2017_Q2`), 1, `2017_Q2`) - 
                    ifelse(is.na(`2017_Q1`), 1, `2017_Q1`) > 0, 1, 0))

#- national level summary
smmy_psc_qtr_smmy_nat <- smmy_psc_qtr %>%
  group_by("National_Level") %>%
  summarise(`2016_Q4_adv` = sum(`2016_Q4_adv`, na.rm = TRUE),
            `2017_Q1_adv` = sum(`2017_Q1_adv`, na.rm = TRUE),
            `2017_Q2_adv` = sum(`2017_Q2_adv`, na.rm = TRUE),
            `2016_Q4_total` = sum(!is.na(`2016_Q4`), na.rm = TRUE),
            `2017_Q1_total` = sum(!is.na(`2017_Q1`), na.rm = TRUE),
            `2017_Q2_total` = sum(!is.na(`2017_Q2`), na.rm = TRUE),
            `2016_Q4_adv_ratio` = sum(`2016_Q4_adv`, na.rm = TRUE) / 
              sum(`2016_Q4`, na.rm = TRUE),
            `2017_Q1_adv_ratio` = sum(`2017_Q1_adv`, na.rm = TRUE) /
              sum(`2017_Q1`, na.rm = TRUE),
            `2017_Q2_adv_ratio` = sum(`2017_Q2_adv`, na.rm = TRUE) /
              sum(`2017_Q2`, na.rm = TRUE)) %>%
  gather(key, value, -`"National_Level"`) %>%
  mutate(Quarter = substr(key, 1, 7),
         dimension = substr(key, 9, nchar(key))) %>%
  select(-key) %>%
  spread(dimension, value)


#- regional level summary
smmy_psc_qtr_smmy_region <- smmy_psc_qtr %>%
  group_by(region) %>%
  summarise(`2016_Q4_adv` = sum(`2016_Q4_adv`, na.rm = TRUE),
            `2017_Q1_adv` = sum(`2017_Q1_adv`, na.rm = TRUE),
            `2017_Q2_adv` = sum(`2017_Q2_adv`, na.rm = TRUE),
            `2016_Q4_total` = sum(!is.na(`2016_Q4`), na.rm = TRUE),
            `2017_Q1_total` = sum(!is.na(`2017_Q1`), na.rm = TRUE),
            `2017_Q2_total` = sum(!is.na(`2017_Q2`), na.rm = TRUE),
            `2016_Q4_adv_ratio` = sum(`2016_Q4_adv`, na.rm = TRUE) / 
              sum(`2016_Q4`, na.rm = TRUE),
            `2017_Q1_adv_ratio` = sum(`2017_Q1_adv`, na.rm = TRUE) /
              sum(`2017_Q1`, na.rm = TRUE),
            `2017_Q2_adv_ratio` = sum(`2017_Q2_adv`, na.rm = TRUE) /
              sum(`2017_Q2`, na.rm = TRUE)) %>%
  gather(key, value, -region) %>%
  mutate(Quarter = substr(key, 1, 7),
         dimension = substr(key, 9, nchar(key))) %>%
  select(-key) %>%
  spread(dimension, value)

#- doctor tier level summary
smmy_psc_qtr_smmy_tier <- smmy_psc_qtr %>%
  group_by(doctor.tier) %>%
  summarise(`2016_Q4_adv` = sum(`2016_Q4_adv`, na.rm = TRUE),
            `2017_Q1_adv` = sum(`2017_Q1_adv`, na.rm = TRUE),
            `2017_Q2_adv` = sum(`2017_Q2_adv`, na.rm = TRUE),
            `2016_Q4_total` = sum(!is.na(`2016_Q4`), na.rm = TRUE),
            `2017_Q1_total` = sum(!is.na(`2017_Q1`), na.rm = TRUE),
            `2017_Q2_total` = sum(!is.na(`2017_Q2`), na.rm = TRUE),
            `2016_Q4_adv_ratio` = sum(`2016_Q4_adv`, na.rm = TRUE) / 
              sum(`2016_Q4`, na.rm = TRUE),
            `2017_Q1_adv_ratio` = sum(`2017_Q1_adv`, na.rm = TRUE) /
              sum(`2017_Q1`, na.rm = TRUE),
            `2017_Q2_adv_ratio` = sum(`2017_Q2_adv`, na.rm = TRUE) /
              sum(`2017_Q2`, na.rm = TRUE)) %>%
  gather(key, value, -doctor.tier) %>%
  mutate(Quarter = substr(key, 1, 7),
         dimension = substr(key, 9, nchar(key))) %>%
  select(-key) %>%
  spread(dimension, value)

#- department level summary
smmy_psc_qtr_smmy_department <- smmy_psc_qtr %>%
  group_by(department) %>%
  summarise(`2016_Q4_adv` = sum(`2016_Q4_adv`, na.rm = TRUE),
            `2017_Q1_adv` = sum(`2017_Q1_adv`, na.rm = TRUE),
            `2017_Q2_adv` = sum(`2017_Q2_adv`, na.rm = TRUE),
            `2016_Q4_total` = sum(!is.na(`2016_Q4`), na.rm = TRUE),
            `2017_Q1_total` = sum(!is.na(`2017_Q1`), na.rm = TRUE),
            `2017_Q2_total` = sum(!is.na(`2017_Q2`), na.rm = TRUE),
            `2016_Q4_adv_ratio` = sum(`2016_Q4_adv`, na.rm = TRUE) / 
              sum(`2016_Q4`, na.rm = TRUE),
            `2017_Q1_adv_ratio` = sum(`2017_Q1_adv`, na.rm = TRUE) /
              sum(`2017_Q1`, na.rm = TRUE),
            `2017_Q2_adv_ratio` = sum(`2017_Q2_adv`, na.rm = TRUE) /
              sum(`2017_Q2`, na.rm = TRUE)) %>%
  gather(key, value, -department) %>%
  mutate(Quarter = substr(key, 1, 7),
         dimension = substr(key, 9, nchar(key))) %>%
  select(-key) %>%
  spread(dimension, value)


#- advanced doc distribution on the 15th 16th questions

smmy_psc_qtr_gather <- smmy_psc_qtr %>%
  select(-`2016_Q3`, -`2016_Q4`, -`2017_Q1`, -`2017_Q2`) %>%
  gather(quarter, adv_flag, `2016_Q4_adv`:`2017_Q2_adv`) %>%
  filter(adv_flag == 1) %>%
  mutate(quarter = substr(quarter, 1, 7)) %>%
  separate(quarter, c("Year", "Quarter"), "_")%>%
  select(doctorid, Year, Quarter, adv_flag)

eda_dat_15_q_adv <- eda_dat %>%
  filter(target.department == "Y",
         substr(questions, 1, 3) == "Q15") %>%
  select(doctorid, department, hospital, region, hcp.major, questions, answers,
         most.recent.modify.date.m) %>%
  left_join(doc_tier, by = c("doctorid")) %>%
  # filter(doctor.tier %in% c("A", "B")) %>%
  mutate(Year = substr(most.recent.modify.date.m, 1, 4),
         Quarter = ifelse(as.numeric(substr(most.recent.modify.date.m, 6, 7)) %in% c(1, 2, 3),
                          "Q1", 
                          ifelse(as.numeric(substr(most.recent.modify.date.m, 6, 7)) %in% c(4, 5, 6),
                                 "Q2",
                                 ifelse(as.numeric(substr(most.recent.modify.date.m, 6, 7)) %in% c(7, 8, 9),
                                        "Q3",
                                        "Q4")))) %>%
  distinct() %>%
  arrange(doctorid, most.recent.modify.date.m) %>%
  group_by(doctorid, Year, Quarter) %>%
  filter(row_number() == n(),
         !(Year == "2016" & Quarter == "Q3")) %>%
  left_join(smmy_psc_qtr_gather, by = c("doctorid", "Year", "Quarter")) %>%
  ungroup() %>%
  group_by(Year, Quarter) %>%
  mutate(doc_cnt_total_adv = sum(adv_flag, na.rm = TRUE),
         doc_cnt_total = n()) %>%
  separate_rows(answers, sep = ";") %>%
  group_by(Year, Quarter, answers, doc_cnt_total, doc_cnt_total_adv, adv_flag) %>%
  summarise(doc_cnt = n()) %>%
  mutate(doc_cnt_pct = doc_cnt / doc_cnt_total_adv) %>%
  ungroup()

eda_dat_16_q_adv <- eda_dat %>%
  filter(target.department == "Y",
         substr(questions, 1, 3) == "Q16") %>%
  select(doctorid, department, hospital, region, hcp.major, questions, answers,
         most.recent.modify.date.m) %>%
  left_join(doc_tier, by = c("doctorid")) %>%
  # filter(doctor.tier %in% c("A", "B")) %>%
  mutate(Year = substr(most.recent.modify.date.m, 1, 4),
         Quarter = ifelse(as.numeric(substr(most.recent.modify.date.m, 6, 7)) %in% c(1, 2, 3),
                          "Q1", 
                          ifelse(as.numeric(substr(most.recent.modify.date.m, 6, 7)) %in% c(4, 5, 6),
                                 "Q2",
                                 ifelse(as.numeric(substr(most.recent.modify.date.m, 6, 7)) %in% c(7, 8, 9),
                                        "Q3",
                                        "Q4")))) %>%
  distinct() %>%
  arrange(doctorid, most.recent.modify.date.m) %>%
  group_by(doctorid, Year, Quarter) %>%
  filter(row_number() == n(),
         !(Year == "2016" & Quarter == "Q3")) %>%
  left_join(smmy_psc_qtr_gather, by = c("doctorid", "Year", "Quarter")) %>%
  ungroup() %>%
  group_by(Year, Quarter) %>%
  mutate(doc_cnt_total_adv = sum(adv_flag, na.rm = TRUE),
         doc_cnt_total = n()) %>%
  separate_rows(answers, sep = ";") %>%
  group_by(Year, Quarter, answers, doc_cnt_total, doc_cnt_total_adv, adv_flag) %>%
  summarise(doc_cnt = n()) %>%
  mutate(doc_cnt_pct = doc_cnt / doc_cnt_total_adv) %>%
  ungroup()


##-- combine meeting data into eda data

meeting_data_m <- meeting_dat %>%
  mutate(Year = substr(imeeting.time, 7, 10),
         Quarter = ifelse(as.numeric(substr(imeeting.time, 1, 2)) %in% c(1, 2, 3),
                          "Q1", 
                          ifelse(as.numeric(substr(imeeting.time, 1, 2)) %in% c(4, 5, 6),
                                 "Q2",
                                 ifelse(as.numeric(substr(imeeting.time, 1, 2)) %in% c(7, 8, 9),
                                        "Q3",
                                        "Q4")))) %>%
  group_by(Year, Quarter, doctor.id, imeeting.type) %>%
  summarise(meeting_cnt = n())

eda_dat_tgt_with_meeting <- eda_dat_tgt %>%
  left_join(doc_tier, by = c("doctorid")) %>%
  # filter(doctor.tier %in% c("A", "B")) %>%
  left_join(meeting_data_m, by = c("Year", "Quarter", "doctorid" = "doctor.id")) %>%
  group_by(Year, Quarter, imeeting.type, hcp.major) %>%
  summarise(doc_cnt = n_distinct(doctorid),
            meeting_cnt = sum(meeting_cnt),
            avg_meeting_cnt = meeting_cnt / doc_cnt) 

eda_dat_tgt_with_meeting_all <- eda_dat_tgt %>%
  left_join(doc_tier, by = c("doctorid")) %>%
  # filter(doctor.tier %in% c("A", "B")) %>%
  left_join(meeting_data_m, by = c("Year", "Quarter", "doctorid" = "doctor.id")) %>%
  group_by(Year, Quarter, imeeting.type) %>%
  summarise(doc_cnt = n_distinct(doctorid),
            meeting_cnt = sum(meeting_cnt),
            avg_meeting_cnt = meeting_cnt / doc_cnt)

eda_dat_tgt_with_meeting_all$hcp.major <- "Overall"
eda_dat_tgt_with_meeting_all <- rbind(eda_dat_tgt_with_meeting,
                                      eda_dat_tgt_with_meeting_all)


eda_dat_tgt_with_meeting_adv <- eda_dat_tgt %>%
  left_join(doc_tier, by = c("doctorid")) %>%
  # filter(doctor.tier %in% c("A", "B"),
  #        Year != "2016")  %>%
  left_join(meeting_data_m, by = c("Year", "Quarter", "doctorid" = "doctor.id")) %>%
  left_join(smmy_psc_qtr_gather, by = c("Year", "Quarter", "doctorid")) %>%
  group_by(Year, Quarter, imeeting.type, adv_flag) %>%
  summarise(doc_cnt = n_distinct(doctorid),
            meeting_cnt = sum(meeting_cnt, na.rm = TRUE),
            avg_meeting_cnt = meeting_cnt / doc_cnt) %>%
  filter(adv_flag == 1) %>%
  mutate(adv_flag = as.character(adv_flag)) %>%
  group_by(Year, Quarter, imeeting.type) %>%
  mutate(doc_cnt_all = sum(doc_cnt, na.rm = TRUE),
         meeting_cnt_all = sum(meeting_cnt, na.rm = TRUE),
         avg_meeting_cnt_all = meeting_cnt_all / doc_cnt_all) %>%
  select(-doc_cnt_all, -meeting_cnt_all)

eda_dat_tgt_with_meeting_adv_all <- eda_dat_tgt %>%
  left_join(doc_tier, by = c("doctorid")) %>%
  # filter(doctor.tier %in% c("A", "B"),
  #        Year != "2016")  %>%
  left_join(meeting_data_m, by = c("Year", "Quarter", "doctorid" = "doctor.id")) %>%
  left_join(smmy_psc_qtr_gather, by = c("Year", "Quarter", "doctorid")) %>%
  group_by(Year, Quarter, imeeting.type) %>%
  summarise(doc_cnt = n_distinct(doctorid),
            meeting_cnt = sum(meeting_cnt, na.rm = TRUE),
            avg_meeting_cnt = meeting_cnt / doc_cnt)

eda_dat_tgt_with_meeting_adv_all$adv_flag <- "All" 
eda_dat_tgt_with_meeting_adv_all$avg_meeting_cnt_all <- 999 

eda_dat_tgt_with_meeting_adv_all <- rbind(eda_dat_tgt_with_meeting_adv,
                                          eda_dat_tgt_with_meeting_adv_all) %>%
  arrange(Year, Quarter, imeeting.type)

eda_dat_tgt_with_meeting_adv_all$adv_flag <- 
  ifelse(eda_dat_tgt_with_meeting_adv_all$adv_flag == "1", 
         "Physicians with Progression",
         "Overall Physicians")



##-- combine call data into eda data
call_dat_m <- call_dat %>%
  mutate(Year = substr(call.date, 1, 4),
         Quarter = ifelse(as.numeric(substr(call.date, 6, 7)) %in% c(1, 2, 3),
                          "Q1", 
                          ifelse(as.numeric(substr(call.date, 6, 7)) %in% c(4, 5, 6),
                                 "Q2",
                                 ifelse(as.numeric(substr(call.date, 6, 7)) %in% c(7, 8, 9),
                                        "Q3",
                                        "Q4")))) %>%
  group_by(Year, Quarter, doctorid) %>%
  summarise(call_cnt = n()) %>%
  mutate(doctorid = as.character(doctorid))

eda_dat_tgt_with_call <- eda_dat_tgt %>%
  left_join(doc_tier, by = c("doctorid")) %>%
  # filter(doctor.tier %in% c("A", "B")) %>%
  left_join(call_dat_m, by = c("Year", "Quarter", "doctorid")) %>%
  group_by(Year, Quarter, region, hcp.major) %>%
  summarise(doc_cnt = n_distinct(doctorid),
            call_cnt = sum(call_cnt, na.rm = TRUE),
            avg_call_cnt = call_cnt / doc_cnt)  %>%
  group_by(Year, Quarter, hcp.major) %>%
  do(plyr::rbind.fill(., data.frame(Year = first(.$Year),
                                    Quarter = first(.$Quarter),
                                    hcp.major = first(.$hcp.major),
                                    region = "Total",
                                    doc_cnt = sum(.$doc_cnt, na.rm = TRUE),
                                    call_cnt = sum(.$call_cnt, na.rm = TRUE),
                                    avg_call_cnt = sum(.$call_cnt, na.rm = TRUE) /
                                      sum(.$doc_cnt, na.rm = TRUE))))

eda_dat_tgt_with_call_all <- eda_dat_tgt_with_call%>%
  group_by(Year, Quarter, region) %>%
  summarise(doc_cnt = sum(doc_cnt, na.rm = TRUE),
            call_cnt = sum(call_cnt, na.rm = TRUE),
            avg_call_cnt = call_cnt / doc_cnt)

eda_dat_tgt_with_call_all$hcp.major <- "Overall"
eda_dat_tgt_with_call_all <- rbind(eda_dat_tgt_with_call,
                                   eda_dat_tgt_with_call_all)



eda_dat_tgt_with_call_adv <- eda_dat_tgt %>%
  left_join(doc_tier, by = c("doctorid")) %>%
  # filter(doctor.tier %in% c("A", "B"),
  #        Year != "2016")  %>%
  left_join(call_dat_m, by = c("Year", "Quarter", "doctorid")) %>%
  left_join(smmy_psc_qtr_gather, by = c("Year", "Quarter", "doctorid")) %>%
  group_by(Year, Quarter, region, adv_flag) %>%
  summarise(doc_cnt = n_distinct(doctorid),
            call_cnt = sum(call_cnt, na.rm = TRUE),
            avg_call_cnt = call_cnt / doc_cnt) %>%
  filter(adv_flag == 1) %>%
  mutate(adv_flag = as.character(adv_flag)) %>%
  group_by(Year, Quarter, region) %>%
  mutate(doc_cnt_all = sum(doc_cnt, na.rm = TRUE),
         call_cnt_all = sum(call_cnt, na.rm = TRUE),
         avg_call_cnt_all = call_cnt_all / doc_cnt_all) %>%
  select(-doc_cnt_all, -call_cnt_all)

eda_dat_tgt_with_call_adv_all <- eda_dat_tgt %>%
  left_join(doc_tier, by = c("doctorid")) %>%
  # filter(doctor.tier %in% c("A", "B"),
  #        Year != "2016")  %>%
  left_join(call_dat_m, by = c("Year", "Quarter", "doctorid")) %>%
  left_join(smmy_psc_qtr_gather, by = c("Year", "Quarter", "doctorid")) %>%
  group_by(Year, Quarter, region) %>%
  summarise(doc_cnt = n_distinct(doctorid),
            call_cnt = sum(call_cnt, na.rm = TRUE),
            avg_call_cnt = call_cnt / doc_cnt)

eda_dat_tgt_with_call_adv_all$adv_flag <- "All" 
eda_dat_tgt_with_call_adv_all$avg_call_cnt_all <- 999 

eda_dat_tgt_with_call_adv_all <- rbind(eda_dat_tgt_with_call_adv,
                                          eda_dat_tgt_with_call_adv_all) %>%
  arrange(Year, Quarter, region)

eda_dat_tgt_with_call_adv_all$adv_flag <- 
  ifelse(eda_dat_tgt_with_call_adv_all$adv_flag == "1",
         "Physicians with Progression",
         "Overall Physicians") 

eda_dat_tgt_with_call_adv_all <- eda_dat_tgt_with_call_adv_all %>%
  group_by(Year, Quarter, adv_flag) %>%
  do(plyr::rbind.fill(., data.frame(Year = first(.$Year),
                                    Quarter = first(.$Quarter),
                                    adv_flag = first(.$adv_flag),
                                    region = "Total",
                                    doc_cnt = sum(.$doc_cnt, na.rm = TRUE),
                                    call_cnt = sum(.$call_cnt, na.rm = TRUE),
                                    avg_call_cnt = sum(.$call_cnt, na.rm = TRUE) / 
                                      sum(.$doc_cnt, na.rm = TRUE))))
