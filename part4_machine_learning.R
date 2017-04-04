library(randomForest)
library(rpart)
library(party)


set.seed(2322)


#DATA TRANSFORMATION FOR MODEL INPUT: ----

training_data_sample = training_data %>%
  sample_frac(0.1) %>%
  filter(!is.na(dist_scheduled_delivered)) %>%
  group_by(dist_band =(cut(dist_scheduled_delivered, breaks= seq(0, 10000, by = 500)))) %>%  #distance bands 
  arrange(as.numeric(dist_band)) %>%
  ungroup()

training_data_sample$dist_band <- droplevels(training_data_sample$dist_band)

rf_delivery <- randomForest(dist_band ~ delivery_hour + weekday + 
                              supplier_name + time_slot_from + time_slot_to + customer_name + schedule_channel + driver_id + scheduled_lon + scheduled_lat,
                            data=training_data_sample,
                             myTree = 4,
                             importance=TRUE
                            )

feature_importance <- varImpPlot(rf_delivery) #top features will be used for Multiple Regression model---> prediction
print(feature_importance_df)
