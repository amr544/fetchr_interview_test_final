#EDA:----


#Plot Sample Scheduled and Delivered Coordinates:----

Dubai <- get_map(location = 'dubai', zoom = "auto")
AbuDhabi <- get_map(location = 'abudhabi', zoom = "auto")
Sharjah <- get_map(location = 'sharjah', zoom = 12)


sample_training = training_data %>% sample_n(100) 


print(
ggmap(Dubai) + 
  geom_point(data = sample_training, aes(x = scheduled_lon, y = scheduled_lat),color = 'red') +
  geom_point(data = sample_training, aes(x = deliver_lon, y = deliver_lat),color = 'blue')
)

print(
ggmap(AbuDhabi) + 
  geom_point(data = sample_training, aes(x = scheduled_lon, y = scheduled_lat),color = 'red') +
  geom_point(data = sample_training, aes(x = deliver_lon, y = deliver_lat),color = 'blue')
)

print(
ggmap(Sharjah) + 
  geom_point(data = sample_training, aes(x = scheduled_lon, y = scheduled_lat),color = 'red') +
  geom_point(data = sample_training, aes(x = deliver_lon, y = deliver_lat),color = 'blue')
)



#Plot Historgram for Distance distribution with mean and median:
print(training_data %>% filter(!is.na(dist_scheduled_delivered)) %>%
  ggplot(aes(x = dist_scheduled_delivered)) +
  geom_histogram( aes(fill = ..count..), alpha = I(2/5), color = "black") +
  scale_fill_gradient("Count", low = "red", high = "green") + 
  geom_vline(xintercept = mean(training_data$dist_scheduled_delivered, na.rm = TRUE),  colour="red", linetype = "longdash") +
  geom_vline(xintercept = median(training_data$dist_scheduled_delivered, na.rm = TRUE),  colour="blue", linetype = "longdash")
)
