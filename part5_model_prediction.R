
#TEST DATA PREPARATION:----



#Transform Test Data and add Engineered features::
test_data = dataset_022017 %>% 
  filter(schedule_channel != 'menavip') %>% #to align test-data factors to training set
  separate(scheduled_coordinates, c('scheduled_lat', 'scheduled_lon'), sep=";") %>%
  mutate(
    delivery_hour = as.numeric(format(as.POSIXct(delivery_time, format="%Y-%m-%dt%H:%M"), format="%H")),
    weekday = as.factor(weekdays(as.Date(commitment_date))),
    schedule_channel = as.factor(schedule_channel),
    time_slot_from = as.numeric(time_slot_from),
    time_slot_to = as.numeric(time_slot_to),
    scheduled_lon = as.numeric(scheduled_lon),
    scheduled_lat = as.numeric(scheduled_lat),
    driver_id = as.numeric(driver_id)
  ) %>%
  filter(
    !is.na(delivery_hour),
    !is.na(scheduled_lat),
    !is.na(scheduled_lon)
    )


train_lm <- lm(dist_scheduled_delivered ~  scheduled_lon + scheduled_lat + driver_id + delivery_hour, data = training_data) #feature selection based on RF output

#prediction:
fitted.results <- predict(train_lm,test_data, type = "response" )

#getting plots of probabilities since we may have to change the threshold:
par(mfrow= c(1,1))
hist(fitted.results, breaks=50, main = paste("Regression distr. , mean:", round(mean(fitted.results),2)))
abline(v=mean(fitted.results), col="blue")

test_data$dist_scheduled_delivered <- fitted.results

write_csv(test_data, "predicted_distance_accuracy.csv")

print(paste0("Predicted Distance Output file has been created in ",getwd()))

