
# Load packages -----------------------------------------------------------

library(tidyverse)
library(lubridate)
library(janitor)
library(glue)

# Deafults ----------------------------------------------------------------

conflicted::conflict_prefer("filter", "dplyr")
theme_set(hrbrthemes::theme_ipsum())

# Import data -------------------------------------------------------------

url_data <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

download.file(url_data, "electric_power_consumption.zip")

unzip("electric_power_consumption.zip")

raw_data <- read_delim(
    "household_power_consumption.txt",
    ";",
    escape_double = FALSE,
    col_types = cols(Time = col_character()),
    trim_ws = TRUE
) %>%
    clean_names()

# Subset data -------------------------------------------------------------

final_data <- raw_data %>%
    mutate(
        total_date = dmy_hms(glue("{date} {time}")),
        date = dmy(date)
    ) %>%
    filter(between(date, dmy(01022007), dmy(02022007)))

# Make plot ---------------------------------------------------------------

final_data %>%
    ggplot(aes(total_date, global_active_power)) +
        geom_line() +
        scale_x_datetime(date_breaks = "1 day") +
        labs(x = "", y = "Global Active Power (kilowatts)")


# Save plot ---------------------------------------------------------------

ggsave("plot2.png", width = 5, height = 5)
