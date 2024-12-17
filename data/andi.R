# 1. Setup and Package Loading
library(tidyverse)
library(viridis)
library(ggrepel)

# Note: This script requires 'pplandi.txt' in the working directory

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
  data <- unique(data, by = "source")
  
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

# 3. Data Loading and Processing
andi_all <- process_summary("pplandi.txt")

# Initial data processing
andi_all <- distinct(andi_all, source, .keep_all = TRUE)
andi_all$simplified_genre <- gsub("-(.*)", "", andi_all$genre)
andi_all <- andi_all %>%
  group_by(textid) %>%
  mutate(relative_frequency = hits / sum(total) * 100)

# Create filtered dataset excluding 'psd' genre
andi_all2 <- andi_all %>% 
  filter(simplified_genre != "psd")

# 4. Create Final Visualization
andiplot <- ggplot(andi_all2, aes(x = year, y = relative_frequency, color = simplified_genre, size = hits)) +
  geom_point(alpha = 0.7) +
  scale_color_viridis_d() + 
  scale_size(range = c(1, 10)) +
  geom_text_repel(data = subset(andi_all2, relative_frequency > 0.5),  # Apply labels conditionally
                  aes(label = textid),
                  size = 3,
                  force = 2,
                  box.padding = 0.5,
                  point.padding = 0.3,
                  segment.size = 0.2) +
  labs(title = "Participle -andi in IcePAHC",
       x = "Year",
       y = "Rel. freq.",
       subtitle = "") +
  theme_minimal() +
  theme(legend.position = "right")

# 5. Save Plot
png("fig12andi.png", units = "cm", width = 15, height = 10, res = 600)
plot(andiplot)
dev.off()