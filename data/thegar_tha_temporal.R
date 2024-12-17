# 1. Setup and Package Loading
library(tidyverse)
library(lme4)
library(viridis)

# Note: This script requires the following input files in the working directory:
# - summarytha.txt
# - summarythegar.txt

# 2. Helper Function Definition
process_summary <- function(file) {
  text_lines <- suppressWarnings(readLines(file))
  text_lines <- text_lines[-c(1, length(text_lines))]
  
  process_line <- function(line) {
    matches <- regmatches(line, regexec("(\\S+)\\s+(\\d+)\\s*/\\s*(\\d+)\\s*/\\s*(\\d+)", line))[[1]]
    return(matches[-1])
  }
  
  data_list <- lapply(text_lines, process_line)
  data <- do.call(rbind, data_list)
  data <- data.frame(data, stringsAsFactors = FALSE)
  
  colnames(data) <- c("source", "hits", "tokens", "total")
  data$hits <- as.numeric(data$hits)
  data$tokens <- as.numeric(data$tokens)
  data$total <- as.numeric(data$total)
  
  # Extracting year, textid, and genre information
  extract_info <- function(source) {
    if (startsWith(source, "ntmatthew")) {
      textid_genre <- strsplit(source, ".", fixed = TRUE)[[1]]
      textid <- textid_genre[1]
      genre <- textid_genre[2]
      return(c("1540", textid, genre))
    }
    
    year <- substr(source, 1, 4)
    textid_genre <- strsplit(substr(source, 6, nchar(source)), ".", fixed = TRUE)[[1]]
    textid <- textid_genre[1]
    genre <- textid_genre[2]
    
    return(c(year, textid, genre))
  }
  
  extra_data <- do.call(rbind, lapply(data$source, extract_info))
  data <- cbind(data, as.data.frame(extra_data, stringsAsFactors = FALSE))
  colnames(data)[5:7] <- c("year", "textid", "genre")
  data$year <- as.numeric(data$year)
  
  return(data)
}

# 3. Data Loading and Initial Processing
# Read and process data files
data1 <- process_summary("summarytha.txt")
data2 <- process_summary("summarythegar.txt")

# Combine hits from both datasets
combined_hits <- merge(data1[, c("source", "hits")], data2[, c("source", "hits")], 
                      by="source", suffixes=c("_data1", "_data2"))

# Calculate totals and proportions
combined_hits$total_hits <- combined_hits$hits_data1 + combined_hits$hits_data2
combined_hits$proportion_data1 <- combined_hits$hits_data1 / combined_hits$total_hits
combined_hits$proportion_data2 <- combined_hits$hits_data2 / combined_hits$total_hits

# Merge with original data
combined_data <- merge(data1, combined_hits, by="source")
combined_data <- combined_data %>%
  mutate(simplified_genre = str_extract(genre, "^[^-]+"))

# 4. Statistical Analysis
# Fit logistic regression model
model_1 <- glm(proportion_data2 ~ year, data = combined_data, family = quasibinomial)

# Create predictions
predictions_2 <- data.frame(
  year = combined_data$year,
  pred_proportion = predict(model_1, type = "response")
)

# 5. Create Final Visualization
p2 <- ggplot(combined_data, aes(x = year, y = proportion_data2)) +
  geom_point(aes(color = simplified_genre, size = total_hits)) +
  scale_color_viridis_d(name = "Genre") +
  geom_line(data = predictions_2, aes(y = pred_proportion), color = "blue") +
  labs(title = "Þegar vs. Þá as a Temporal Conjunction",
       x = "Year",
       y = "Proportion of Þegar",
       color = "Genre",
       size = "Total Hits") +
  theme_minimal()

# 6. Save Plot
png("fig10temporalconj.png", units = "cm", width = 15, height = 10, res = 600)
plot(p2)
dev.off()

# 7. Print Statistical Results
cat("\nModel Summary:\n")
print(summary(model_1))

p_value <- summary(model_1)$coefficients[2,4]
cat("\nP-value:", formatC(p_value, digits = 2, format = "e"))
cat("\nBeta coefficient:", round(coef(model_1)[2], 4))