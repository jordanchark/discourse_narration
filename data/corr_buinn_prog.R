# 1. Setup and Package Loading
library(dplyr)
library(ggplot2)
library(ggrepel)
library(viridis)

# Note: This script assumes you have two preprocessed datasets:
# - buinn_all: Dataset containing BÚINN information
# - merged_data: Dataset containing PROG information
# Both datasets should have columns: textid, relative_frequency, simplified_genre

# 2. Data Merging and Cleaning
# Merge the datasets by textid
merged_data2 <- buinn_all %>%
  left_join(merged_data, by = "textid")

# Drop rows with missing values
merged_data2 <- merged_data2 %>%
  drop_na(relative_frequency.x, relative_frequency.y)

# 3. Calculate Overall Correlation
correlation_test <- cor.test(merged_data2$relative_frequency.x, merged_data2$relative_frequency.y)
correlation <- correlation_test$estimate
p_value <- correlation_test$p.value

correlation_test

# Format results
rounded_p_value <- formatC(p_value, format = "e", digits = 2)
rounded_cor <- round(correlation, 3)

# 4. Calculate Summary Statistics
aggregate_stats <- merged_data2 %>%
  summarise(
    mean_x = mean(relative_frequency.x, na.rm = TRUE),
    median_x = median(relative_frequency.x, na.rm = TRUE),
    var_x = var(relative_frequency.x, na.rm = TRUE),
    mean_y = mean(relative_frequency.y, na.rm = TRUE),
    median_y = median(relative_frequency.y, na.rm = TRUE),
    var_y = var(relative_frequency.y, na.rm = TRUE)
  )

# 5. Prepare Valid Data for Plotting
valid_data <- merged_data2 %>%
  filter(!is.na(relative_frequency.x) & 
           !is.na(relative_frequency.y) & 
           !source %in% c("1540.ntacts.rel-bib.psd", "1210.jartein.rel-sag.psd"))

# Calculate final correlation for plot
overall_correlation <- cor(merged_data2$relative_frequency.x, merged_data2$relative_frequency.y, method = "pearson")
overall_correlation

correlation_test <- cor.test(merged_data2$relative_frequency.x, merged_data2$relative_frequency.y, method = "pearson")
correlation <- correlation_test$estimate
p_value <- correlation_test$p.value

correlation_test


# 6. Create Final Correlation Plot
corrplotbuinnprog <- ggplot(data = valid_data, aes(x = relative_frequency.x, y = relative_frequency.y)) +
  geom_point(aes(color = simplified_genre), size = 3) +
  geom_smooth(method = "lm", se = FALSE, color = "black", linetype = "dotted") +
  scale_color_viridis_d(name = "Genre") +
  labs(title = "Correlation plot: BÚINN and PROG",
       x = "Relative frequency BÚINN",
       y = "Relative frequency PROG",
       color = "Genre",
       subtitle = paste0("Correlation coefficient: ", round(overall_correlation, 2))) +
  theme_minimal() +
  theme(legend.position = "bottom")

# 7. Save Plot
# Output will be saved in the working directory
png("fig11corrbuinnprog.png", units = "cm", width = 15, height = 10, res = 600)
plot(corrplotbuinnprog)
dev.off()

# Print summary statistics
print("Summary Statistics:")
print(aggregate_stats)
print(paste("Overall correlation:", rounded_cor))
print(paste("P-value:", rounded_p_value))
