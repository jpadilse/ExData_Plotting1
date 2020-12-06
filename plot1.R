
# Load packages -----------------------------------------------------------

library(tidyverse)
library(lubridate)
library(janitor)

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
    mutate(date = dmy(date)) %>%
    filter(between(date, dmy(01022007), dmy(02022007)))

# Make plot ---------------------------------------------------------------

final_data %>%
    ggplot(aes(global_active_power)) +
        geom_histogram(fill = "#FF4500", bins = 18) +
        scale_y_continuous(n.breaks = 7) +
        labs(
            title = "Gloabal Active Power",
            x = "Global Active Power (kilowatts)",
            y = "Frequency"
        )

# Save plot ---------------------------------------------------------------

ggsave("plot1.png", width = 5, height = 5)
