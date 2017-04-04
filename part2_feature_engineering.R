library(geosphere) #to extract geospatial distance information
library(RJSONIO) #to parse JSON objects
library(RCurl) #to extract URL information



#FEATURE ENGINEERING: ----

#1. Distance between Scheduled pickup and Delivery Pickup:

training_data$scheduled_coordinates <- cbind(training_data$scheduled_lon,training_data$scheduled_lat)
training_data$delivery_coordinates <- cbind(training_data$deliver_lon,training_data$deliver_lat)
training_data$dist_scheduled_delivered <- distHaversine(training_data$scheduled_coordinates, training_data$delivery_coordinates) 


#2. Weekdays, Hours of Day and distance Flag:

training_data = training_data %>% filter(!is.na(dist_scheduled_delivered)) %>%
  mutate(
    delivery_hour = as.numeric(format(as.POSIXct(delivery_time, format="%Y-%m-%dt%H:%M"), format="%H")),
    weekday = as.factor(weekdays(as.Date(commitment_date))),
    schedule_channel = as.factor(schedule_channel),
    time_slot_from = as.numeric(time_slot_from),
    time_slot_to = as.numeric(time_slot_to),
    dist_flag = if_else(dist_scheduled_delivered > mean(dist_scheduled_delivered),1,0)
  ) %>%
  filter(
    !is.na(delivery_hour)
  )


{
# #3. City:
# 
# 
# google_api <- function(latitude, longitude ){
# 
# google_url <- "http://maps.googleapis.com/maps/api/geocode/json?latlng="
# google_url_2 <- "&sensor=true"
# google_link <- paste0(google_url,latitude,",",longitude,google_url_2)
# google_url <- getURL(google_link)
# 
# return(google_url)
# }
# 
# google_response <- sapply(training_data$deliver_lat[1:1000],google_api, longitude = training_data$deliver_lon[1:1000])
# 
# 
# google_parse <- fromJSON(google_response[i])
# city_name_json <- google_parse$results[[1]]$address_components[[5]]$long_name
# unlist(city_name_json)
}


#Remove Outliers in the distance data:
source("http://goo.gl/UUyEzD") #Online R-script for Outlier Removal using Tukey's methoud of 1.5*IQR. For more coding info just paste the link
outlierKD(training_data,dist_scheduled_delivered) #type yes for outlier removal


