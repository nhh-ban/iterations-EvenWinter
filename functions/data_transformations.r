# ----------------------
# This script contains data transformation functions.
# ----------------------

# Creating function to transform data frame.
transform_metadata_to_df <- function(metadata){
  metadata[[1]] %>% 
    
    # Traversing all entries in metadata list, and transforming them to data
    # frames with the map() function.
    map(as_tibble) %>% 
    
    # combining the list of data frames into one data frame with list_rbind().
    list_rbind() %>% 
    
    # Using map_chr on latestData column to mutate its contents to character
    # format. Defaluts to NA when empty.
    mutate(latestData = map_chr(latestData, 1, .default = NA_character_)) %>% 
    
    # Transforming the time with the as_datetime()
    # function to preserve date and time. 
    mutate(latestData = as_datetime(latestData)) %>% 
    
    # Unpacking location column into latitude and longitude columns by using
    # the unnest_wider() function twice.
    unnest_wider(location) %>% 
    unnest_wider(latLon)
  
}

# Creating function to return date time variable in ISO8601 format, with added
# offset in days, and the letter "Z" appended to end of date string.
to_iso8601 <- function(date_time, offset_days = 0) {
  time = date_time + days(offset_days)
  return(paste0(iso8601(time),"Z"))
}


# Creating function to transform json-return from AOI to a data frame that
# is usable for plotting.
transform_volumes <- function(AOI_return) {
  AOI_return %>% 
    toJSON() %>%  # Converting to json string.
    fromJSON(flatten=TRUE) %>%  # Converting back to list.
    as.data.frame %>%  # Converting to data frame.
    map(unlist) %>%    # Unlisting contents of each column in data frame.
    as_tibble() %>%    # Creating a tibble
    rename(from = 1, to = 2, volume = 3) %>%   # Renaming columns
    mutate(from = as_datetime(from),           # Formating from and to columns
           to = as_datetime(to))               # to datetime. 
}



