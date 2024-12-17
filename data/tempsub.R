# 1. Setup and Package Loading
library(dplyr)
library(ggplot2)
library(ggrepel)
library(viridis)
library(lme4)
library(xtable)

# Note: This script requires the following input files in the working directory:
# - temp_er_treebankcsv.csv
# - thegar_naer_simp_treebank.csv (or thegar_naer_treebank.csv)
# - A dataset containing genre information with columns: textid, genre

# 2. Data Loading
df_t_er <- read.table(file = 'temp_er_treebankcsv.csv', sep = ';', header = TRUE)
df_t_tn <- read.table(file = 'thegar_naer_simp_treebank.csv', sep = ';', header = TRUE)
# Alternative file if needed:
# df_t_tn <- read.table(file = 'thegar_naer_treebank.csv', sep = ';', header = TRUE)

# 3. Data Processing
# Combine datasets and calculate frequencies
combined_df <- bind_rows(df_t_er, df_t_tn) %>%
  group_by(year, text, t.T) %>%
  summarize(total_rT = sum(r.T), .groups = "drop") %>%
  mutate(relative_frequency = (total_rT / t.T)*1000)

# Merge with genre information
combined_df2 <- merge(combined_df, df2[c("textid", "genre")], 
                     by.x = "text", by.y = "textid", all.x = TRUE)

# 4. Create Filtered Datasets
filtered_ts <- combined_df2 %>%
  filter(year >= 1540 & year <= 1900)

filtered_ts_nar <- combined_df2 %>%
  filter(Genre == "nar")

filtered_ts_nar2 <- filtered_ts_nar %>%
  mutate(
    Text = as.factor(text),
    scaled_Year = scale(year)
  )

# 5. Statistical Analysis
# Linear model with genre
model <- lm(relative_frequency ~ year + Genre, data = filtered_ts)

# Simple linear model
model2 <- lm(relative_frequency ~ year, data = combined_df2)

# Models for narrative texts
model_rf <- lm(relative_frequency ~ scaled_Year, data = filtered_ts_nar2)
model_rf_int <- lm(relative_frequency ~ 1, data = filtered_ts_nar2)

# Compare models
anova_result <- anova(model_rf_int, model_rf)

# Mixed effects model for narrative texts
model_nar_int <- lmer(relative_frequency ~ 1 + (1|text), data = filtered_df_nar)

# 6. Visualization
temporal_plot <- ggplot(combined_df2, aes(x = year, y = relative_frequency, color = Genre)) +
  geom_point() +
  scale_color_viridis_d() + 
  scale_size(range = c(1, 10)) +
  geom_text_repel(aes(label = text),
                  size = 3,
                  max.overlaps = 10,
                  box.padding = 0.5) +
  labs(
    title = "Temporal subordinate clauses by text",
    x = "Year",
    y = "Relative Frequency (per 1000 clauses)"
  ) +
  theme_minimal()

# 7. Create LaTeX Table
# Sort data for table
sorted_df <- combined_df2 %>%
  filter(year > 1539) %>%
  arrange(year)

# Create LaTeX table
latex_table_tempsub <- xtable(sorted_df, 
                             caption = "Temporal subordinate clauses by text (IcePAHC)")

# 8. Print Results
print("Model Summary:")
print(summary(model))
print("\nNarrative Texts Model Summary:")
print(summary(model_rf))
print("\nMixed Effects Model Summary:")
print(summary(model_nar_int))
print("\nANOVA Results:")
print(anova_result)

# Optional: Save table to file
# print(latex_table_tempsub, file = "temporal_subordinate_table.tex")