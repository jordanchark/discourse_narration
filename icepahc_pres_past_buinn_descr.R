# Dependencies
library(ggplot2)
library(dplyr)
library(reshape2)
library(cre2)
library(viridis)
library(lme4)

# Data Loading
# Read data from tab-separated files in the working directory
pres <- read.table(file = 'pres_ext.tsv', sep = '\t', header = TRUE)
past <- read.table(file = 'past_ext.tsv', sep = '\t', header = TRUE)

# Data Processing
# Add tense labels
pres$tense <- "present"
past$tense <- "past"

# Rename columns for consistency
pres <- pres %>%
  rename("context" = "label", "date" = "year")
past <- past %>%
  rename("context" = "label", "date" = "year")

# Simplify context labels
pres$context <- gsub(pattern = "^([^-=]*-[^-=]*)(-|=[^-]*|$).*", "\\1", pres$context)
past$context <- gsub(pattern = "^([^-=]*-[^-=]*)(-|=[^-]*|$).*", "\\1", past$context)

# Combine datasets
combined <- rbind(pres, past)

# Frequentize function (from Kauhanen cre library)
frequentize <- function(data) {
  dates <- unique(data$date)
  contexts <- unique(data$context)
  out <- expand.grid(date=dates, context=contexts, applications=0, nonapplications=0, N=0, frequency=0)
  
  for (i in 1:nrow(out)) {
    df <- data[data$date==out[i,]$date & data$context==out[i,]$context, ]
    out[i,]$applications <- sum(df$response)
    out[i,]$N <- length(df$response)
    out[i,]$nonapplications <- out[i,]$N - out[i,]$applications
    out[i,]$frequency <- out[i,]$applications / out[i,]$N
  }
  return(out) 
}

# Calculate frequencies
f_pres_ct <- cre::frequentize(pres)
f_past_ct <- cre::frequentize(past)

# Filter data (post-1600)
f_pres_ct_filtered <- f_pres_ct %>%
  mutate(date = as.numeric(date)) %>%
  filter(date > 1600) %>%
  filter(context != "IP-INF", complete.cases(frequency, applications))

f_past_ct_filtered <- f_past_ct %>%
  mutate(date = as.numeric(date)) %>%
  filter(date > 1600)

# Visualization
# Present Tense Plot
p_pres_ct_filtered <- ggplot(f_pres_ct_filtered, aes(x = date, y = frequency, color = context)) +
  labs(y = "Frequency of búinn", x = "Period (Present Tense)") +
  geom_point(aes(size = applications)) +
  geom_smooth(method = "glm", se = FALSE) + 
  scale_size_area(max_size = 6) +
  coord_cartesian(ylim = c(0, 1)) +
  facet_wrap(~ context) + 
  theme_minimal() +
  scale_color_viridis_d()

# Past Tense Plot
p_past_ct_filtered <- ggplot(f_past_ct_filtered, aes(x = date, y = frequency, color = context)) +
  labs(y = "Frequency of búinn", x = "Period (Past Tense)") +
  geom_point(aes(size = applications)) +
  geom_smooth(method = "glm", se = FALSE) + 
  scale_size_area(max_size = 6) +
  coord_cartesian(ylim = c(0, 1)) +
  facet_wrap(~ context) + 
  theme_minimal() +
  scale_color_viridis_d()

# Display plots
print(p_pres_ct_filtered)
print(p_past_ct_filtered)

# Save plots
png("Fig6past.png", units = "cm", width = 15, height = 10, res = 600)
plot(p_past_ct_filtered)
dev.off()

# Statistical Analysis
# Present tense model
m1_pres <- glmer(response ~ century + (1 | textid), 
                 data = pres, 
                 family = binomial)

# Past tense models
m1_past <- glmer(response ~ context * century + (1 | textid), 
                 data = past, 
                 family = binomial)

m2_past <- glmer(response ~ context + century + (1 | textid), 
                 data = past, 
                 family = binomial)

# Combined models
combined_data <- rbind(pres, past)

m1_combined <- glmer(response ~ tense * century + (1 | textid), 
                    data = combined_data, 
                    family = binomial)

m2_combined <- glmer(response ~ tense + century + (1 | textid), 
                    data = combined_data, 
                    family = binomial)