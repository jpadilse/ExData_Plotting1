
# Load packages -----------------------------------------------------------

library(tidyverse)
library(lubridate)
library(janitor)
library(glue)
library(cowplot)

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

plot_1 <- final_data %>%
    ggplot(aes(total_date, global_active_power)) +
    geom_line() +
    scale_x_datetime(date_breaks = "1 day") +
    labs(x = "", y = "Global Active Power (kilowatts)")

plot_2 <- final_data %>%
    pivot_longer(
        c("sub_metering_1", "sub_metering_2", "sub_metering_3"),
        names_to = "var",
        values_to = "value"
    ) %>%
    ggplot(aes(total_date, value, colour = var)) +
    geom_line() +
    scale_x_datetime(date_breaks = "1 day") +
    labs(x = "", y = "Energy sub metering", colour = "") +
    theme(
        legend.box.background = element_rect(fill = "white"),
        legend.position = c(.975, .975),
        legend.justification = c("right", "top"),
        legend.box.just = "right"
    )

plot_3 <- final_data %>%
    ggplot(aes(total_date, voltage)) +
        geom_line() +
        scale_x_datetime(date_breaks = "1 day") +
        labs(x = "", y = "Voltage", colour = "")

plot_4 <- final_data %>%
    ggplot(aes(total_date, global_reactive_power)) +
    geom_line() +
    scale_x_datetime(date_breaks = "1 day") +
    labs(x = "", y = "Global Reactive Power", colour = "")

plot_grid(plot_1, plot_2, plot_3, plot_4)

# Save plot ---------------------------------------------------------------

ggsave("plot4.png", width = 7.5, height = 7.5)
