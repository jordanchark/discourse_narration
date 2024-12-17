# Dependencies
library(ggplot2)
library(dplyr)
library(viridis)
library(ggrepel)

# Data Loading and Processing
# Read progressive construction data
progpost <- read.csv(file = "progpost.csv", sep = ";", header = TRUE)

# Calculate instances per text
progpost_agg <- progpost %>%
  group_by(textid, year, genre) %>%
  summarize(num_instances = n())

# Join with total counts from buinn data for relative frequency calculation
merged_data <- progpost_agg %>%
  left_join(buinn_all[, c("textid", "total")], by = "textid") %>%
  mutate(relative_frequency = num_instances / total * 100) %>%
  select(-total)  # Remove total column after calculation

# Create Progressive Description Plot
progressive_descrplot_fig7 <- ggplot(merged_data, 
                                    aes(x = year, 
                                        y = relative_frequency, 
                                        color = genre, 
                                        size = num_instances)) +
  geom_point(alpha = 0.7) +
  scale_color_viridis_d() +
  geom_text_repel(aes(label = textid),
                  size = 3,
                  max.overlaps = 10,
                  box.padding = 0.5) +
  labs(title = "Relative Frequency of PROG in IcePAHC",
       x = "Year",
       y = "Rel. freq.") +
  theme_minimal() +
  theme(legend.position = "bottom")

# Save Plot
png("progressive_descrplot_fig7.png", units = "cm", width = 15, height = 10, res = 600)
plot(progressive_descrplot_fig7)
dev.off()