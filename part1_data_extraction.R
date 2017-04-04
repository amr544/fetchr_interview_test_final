library(readr)
library(plyr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggmap)

#remove scientific notation:
options(scipen=999)
rm(list=ls())

#set working directory:
setwd("C:/Users/amr54/Desktop/Misc/Test")

# GATHER TRAINING AND TEST DATASETS:----

#Training Sets:
dataset_102016 <- read_csv("anon_dataset_10_2016.csv")
dataset_112016 <- read_csv("anon_dataset_11_2016.csv")
dataset_122016 <- read_csv("anon_dataset_12_2016.csv")
dataset_012017 <- read_csv("anon_dataset_01_2017.csv")

training_data = rbind.data.frame(dataset_102016,dataset_112016,dataset_122016,dataset_012017 )

#Test Sets:
#dataset_022017 <- read_csv("test_dataset_02_2017.csv") #Pipeline controls Test Data Input


# TRAINING DATA BINDING AND TRANSFORMATION:----

training_data = dataset_102016 %>% 
  bind_rows(dataset_112016, dataset_122016, dataset_012017%>% mutate(driver_id = as.numeric(driver_id))) %>%
  filter(delivery_coordinates != "0;0", !is.na(delivery_coordinates) ) %>%
  separate(scheduled_coordinates, c('scheduled_lat', 'scheduled_lon'), sep=";") %>%
  separate(delivery_coordinates, c('deliver_lat', 'deliver_lon'), sep=";") %>%
  mutate(
    scheduled_lon = as.numeric(scheduled_lon),
    scheduled_lat = as.numeric(scheduled_lat),
    deliver_lon = as.numeric(deliver_lon),
    deliver_lat = as.numeric(deliver_lat)
  )