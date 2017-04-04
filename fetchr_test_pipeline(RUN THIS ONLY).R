library(readr)
dataset_022017 <- read_csv("test_dataset_02_2017.csv") #insert test data here

source("part1_data_extraction.R")
source("part2_feature_engineering.R") #Input needed here to confirm outlier removal
source("part3_eda.R")
source("part4_machine_learning.R")
source("part5_model_prediction.R")
