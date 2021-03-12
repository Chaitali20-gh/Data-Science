#global.R

library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(googleVis)
library(DT)
library(tidyverse)
library(data.table)
library(ggthemes)
library(RColorBrewer)
library(stringr)




init_auto <- fread(file = "./automation_data_by_state.csv")
# Add Category
automation <- init_auto %>% mutate(.,category_m=ifelse(grepl("Education",Occupation),"Education",
                                                           ifelse(grepl("Engineer",Occupation),
                                                                  "Engineering",
                                                                  ifelse(grepl("Health",Occupation),
                                                                         "Healthcare",
                                                                         ifelse(grepl("Medical",Occupation),
                                                                                "Healthcare",
                                                                                ifelse(grepl("Software",Occupation),
                                                                                       "Technology",
                                                                                       ifelse(grepl("Teachers",Occupation),
                                                                                              "Education",
                                                                                              ifelse(grepl("Computer",Occupation),
                                                                                                     "Technology",
                                                                                                     ifelse(grepl("Therapists",Occupation),
                                                                                                            "Healthcare",
                                                                                                            ifelse(grepl("Technicians",Occupation),
                                                                                                                   "Machinery/Repairing Services",
                                                                                                                   ifelse(grepl("Repairers",Occupation),
                                                                                                                          "Machinery/Repairing Services",
                                                                                                                          ifelse(grepl("Equipment",Occupation),
                                                                                                                                 "Machinery/Repairing Services",                                                           
                                                                                                                                 
                                                                                                                                 ifelse(grepl("Machine",Occupation),
                                                                                                                                        "Machinery/Repairing Services",
                                                                                                                                        ifelse(grepl("Food",Occupation),
                                                                                                                                               "Food Service",
                                                                                                                                               ifelse(grepl("Cooks",Occupation),
                                                                                                                                                      "Food Service",
                                                                                                                                                      ifelse(grepl("Social",Occupation),
                                                                                                                                                             "Social Service",
                                                                                                                                                             ifelse(grepl("Sales",Occupation),
                                                                                                                                                                    "Sales",
                                                                                                                                                                    ifelse(grepl("Clerks",Occupation),
                                                                                                                                                                           "Clerical Departments",
                                                                                                                                                                           ifelse(grepl("Operators",Occupation),
                                                                                                                                                                                  "Clerical Departments",
                                                                                                                                                                                  ifelse(grepl("Workers",Occupation),
                                                                                                                                                                                         "Clerical Departments","Other"))))))))))))))))))))

#Job title list
choice <- select(automation,Occupation)


# Populate State Specific data
auto_map_new <-automation  %>% select(-c(SOC)) %>% group_by(Occupation) %>% 
  gather(key = "State",value = "Count",Alabama:Wyoming, na.rm = TRUE) %>% mutate(State_prob = round(Count*Probability))

Overview_data <-auto_map_new %>% group_by(State) %>% 
  summarize(total = sum(State_prob))

# Top 10 high risk jobs
Risk_max <- automation %>% select(.,Probability,Occupation) %>% arrange(.,desc(Probability)) %>% head(10)
