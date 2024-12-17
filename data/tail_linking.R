# 1. Setup and Package Loading
library(tidyverse)
library(lme4)
library(lmerTest)
library(viridis)
library(ggrepel)

# Note: This script requires 'complete_data.csv' in the working directory
# The file should contain columns: Text, Year, Genre, subjtopic-V n, V-subjtopic n, XP-V-subjtopic n

# 2. Data Loading and Processing
data <- read_csv("complete_data.csv")

# Convert proportions to binary outcomes and scale variables
data <- data %>%
  mutate(
    Text = as.factor(Text),
    scaled_Year = scale(Year),
    total_counts = `subjtopic-V n` + `V-subjtopic n` + `XP-V-subjtopic n`,
    successes = `XP-V-subjtopic n`,
    failures = total_counts - `XP-V-subjtopic n`
  ) 

# 3. Create Filtered Datasets
# Filter for specific time period
filtered_data <- data %>%
  filter(Year >= 1540 & Year <= 1900)

# Filter for post-New Testament data
filtered_data_postnt <- data %>%
  filter(Year > 1540)

# Filter out narrative genre
filtered_data_nar <- data %>% 
  filter(Genre != "nar")

# 4. Statistical Analysis
# Full model with interaction
model_nonsubjinit <- glmer(cbind(successes, failures) ~ scaled_Year * Genre + (1|Text), 
                          data = filtered_data, 
                          family = binomial, 
                          control = glmerControl(optimizer = "bobyqa"))

# Simplified model without interaction
model2 <- glmer(cbind(successes, failures) ~ scaled_Year + Genre + (1|Text), 
                data = filtered_data, 
                family = binomial, 
                control = glmerControl(optimizer = "bobyqa"))

# Model for post-NT data
filtered_model <- glmer(cbind(successes, failures) ~ Year + (1|Text), 
                       data = filtered_data_postnt, 
                       family = binomial, 
                       control = glmerControl(optimizer = "bobyqa"))

# 5. Create Visualization
yourFig <- ggplot(filtered_data_postnt, aes(x = Year, y = `XP-V-subjtopic %`, color = Genre)) +
  geom_point() +
  scale_color_viridis_d() + 
  geom_smooth(method = 'lm', formula = y ~ x, se = FALSE) +
  scale_size(range = c(1, 10)) +
  geom_text_repel(aes(label = Text),
                  size = 3,
                  max.overlaps = 10,
                  box.padding = 0.5) +
  labs(
    title = "XP-V-subjtopic % over time",
    x = "Year",
    y = "XP-V-subjtopic %"
  ) +
  theme_minimal()

# 6. Save Plot
png("tailinking.png", units = "cm", width = 25, height = 15, res = 600)
plot(yourFig)
dev.off()

# 7. Print Statistical Results
cat("\nModel with interaction:\n")
print(summary(model_nonsubjinit))

cat("\nModel without interaction:\n")
print(summary(model2))

cat("\nModel comparison (ANOVA):\n")
print(anova(model_nonsubjinit, model2))

cat("\nFiltered model (post-NT):\n")
print(summary(filtered_model))