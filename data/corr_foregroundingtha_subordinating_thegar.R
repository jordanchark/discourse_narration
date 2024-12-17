# 1. Setup and Package Loading
library(lme4)
library(ggplot2)
library(tidyverse)

# Note: The script assumes the data files are in the same directory as the script
# Required files in working directory:
# - summarythaprevb.txt
# - summarythegar.txt

# 2. Data Processing Function Definition
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
  data_list <- unique(data_list, by = "source")
  
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
data1 <- process_summary("summarythaprevb.txt")
data2 <- process_summary("summarythegar.txt")

data1 <- distinct(data1, source, .keep_all = TRUE)

# 4. Data Filtering and Merging
common_sources <- intersect(data1$source, data2$source)
data1 <- data1[data1$source %in% common_sources, ]
data2 <- data2[data2$source %in% common_sources, ]

# Split genre columns
data1 <- data1 %>%
  separate(genre, c("genre1", "genre2"), sep = "-", remove = FALSE)

data2 <- data2 %>%
  separate(genre, c("genre1", "genre2"), sep = "-", remove = FALSE)

# Add tha columns and merge
data1$tha <- 1
data2$tha <- 0
data <- rbind(data1, data2)

# 5. Calculate Relative Frequencies
data <- data %>%
  group_by(year, tha) %>%
  mutate(relative_frequency = hits / sum(total) * 100)

data1 <- data1 %>%
  group_by(source) %>%
  mutate(relative_frequency = hits / sum(total) * 100)

data2 <- data2 %>%
  group_by(source) %>%
  mutate(relative_frequency = hits / sum(total) * 100)

# Create simplified genre variables
data$simplified_genre <- gsub("-(.*)", "", data$genre)
data1$simplified_genre <- gsub("-(.*)", "", data1$genre)
data2$simplified_genre <- gsub("-(.*)", "", data2$genre)

# 6. Create Subset Data
data_s1 <- data1 %>%
  mutate(simplified_genre = ifelse(simplified_genre == "psd", "rel", simplified_genre))

data_s2 <- data2 %>%
  mutate(simplified_genre = ifelse(simplified_genre == "psd", "rel", simplified_genre))

# 7. Correlation Analysis
merge2 <- merge(data_s1, data_s2, by = "textid", suffixes = c("_1", "_2"))
merge <- merge2  # Create merge dataset
merge <- merge %>%
  rename(genre = simplified_genre_1)
merge <- merge %>% 
  distinct(source, .keep_all = TRUE)

correlation_test <- cor.test(merge$relative_frequency_1, merge2$relative_frequency_2)
correlation <- correlation_test$estimate
p_value <- correlation_test$p.value

correlation_test 

# 8. Create Narrative Data Subset
narr_data <- merge %>% 
  filter(genre1_1 == "nar")

# 9. Create Final Correlation Plot
library(viridis)  # For the viridis color palette

corrplot <- ggplot(merge, aes(x = relative_frequency_1, y = relative_frequency_2, color = genre)) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", se = FALSE, color = "black", linetype = "dashed") +
  scale_color_viridis_d(name = "Genre") +
  labs(title = "Correlation of relative frequencies by Text and Year (IcePAHC)",
       x = "Relative frequency of foregrounding þá",
       y = "Relative frequency of subordinating þegar",
       subtitle = paste0("Correlation coefficient: ", round(correlation, 2))) +
  theme_bw() +
  theme(legend.position = "bottom")

# 10. Save Plot
# Output will be saved in the working directory
png("newfig9corr_thegar_tha.png", units = "cm", width = 15, height = 10, res = 600)
plot(corrplot)
dev.off()
