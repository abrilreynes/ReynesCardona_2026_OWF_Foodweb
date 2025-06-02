# Load necessary libraries
library(dplyr)
library(tidyr)
library(ggplot2)

# Function to make column names unique
make_names_unique <- function(df) {
  names(df) <- make.unique(names(df))
  return(df)
}

# Function to calculate mean and standard deviation for each flux
calculate_stats <- function(df) {
  df <- make_names_unique(df)  # Ensure column names are unique
  
  # Pivot longer to get a long format where each row is a single flux measurement
  long_df <- df %>%
    pivot_longer(everything(), names_to = "Flux", values_to = "Value") %>%
    group_by(Flux) %>%
    summarise(
      Mean = mean(Value, na.rm = TRUE),
      SD = sd(Value, na.rm = TRUE)
    )
  
  # Pivot wider to get separate columns for Mean and SD
  stats_df <- long_df %>%
    pivot_longer(cols = c(Mean, SD), names_to = "Statistic", values_to = "Value") %>%
    pivot_wider(names_from = Statistic, values_from = Value)
  
  return(stats_df)
}

# Function to plot fluxes with error bars
plot_fluxes <- function(stats_df) {
  ggplot(stats_df, aes(x = reorder(Flux, Mean), y = Mean)) +
    geom_bar(stat = "identity", fill = "skyblue", color = "black") +
    geom_errorbar(aes(ymin = Mean - SD, ymax = Mean + SD), width = 0.2) +
    theme_minimal() +
    labs(title = "Mean Fluxes with SD", x = "Flux", y = "Mean Value") +
    theme(axis.text.x = element_text(angle = 90, hjust = 1)) # Rotate labels if many fluxes
}

combine_datasets <- function(dfs, labels) {
  combined_df <- bind_rows(dfs, .id = "FoodWeb") %>%
    mutate(FoodWeb = factor(FoodWeb, labels = labels))
  return(combined_df)
}

filter_fluxes <- function(data, fluxes_of_interest) {
  filtered_data <- data %>%
    filter(Flux %in% fluxes_of_interest)
  return(filtered_data)
}

