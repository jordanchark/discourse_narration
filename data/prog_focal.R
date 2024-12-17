# 1. Setup and Package Loading
library(tidyverse)

# Note: This script requires the following input files in the working directory:
# - icepahc_allptcp.csv
# - infbuinnsum.txt

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

# 3. Data Loading and Initial Processing
allptcp <- read.csv(file = "icepahc_allptcp.csv", sep = ",", header = TRUE)
buinn_all <- process_summary("infbuinnsum.txt")

# 4. Variable Analysis
# Join datasets and create long format
df_joined <- allptcp %>%
  left_join(buinn_all[, c("textid", "total")], by = "textid")

df_long <- df_joined %>%
  gather(key = "variable", value = "value", prog, fara, taka, na.rm = TRUE) %>%
  group_by(textid, year, variable) %>%
  summarize(count = sum(value)) %>%
  ungroup()

df_long <- df_long %>%
  left_join(buinn_all[, c("textid", "total")], by = "textid") %>%
  mutate(relative_frequency = count / total * 100)

# 5. FOCAL Analysis
# Process PROG data by FOCAL value
df_prog3 <- allptcp %>%
  filter(prog == 1) %>%
  count(century, FOCAL) %>%
  group_by(century) %>%
  mutate(total = sum(n)) %>%
  ungroup() %>%
  mutate(prop = n / total) %>%
  filter(century < 20) 

# 6. Create Final FOCAL Plot
Fig9focal <- ggplot(df_prog3, aes(fill = as.factor(FOCAL), y = prop, x = as.factor(century))) + 
  geom_bar(position = "fill", stat = "identity") +
  scale_fill_viridis_d(option = "turbo") +  
  labs(x = "Century", y = "Proportion", fill = "FOCAL") +
  theme_minimal() +
  scale_x_discrete(drop = FALSE) +
  theme_minimal()

# 7. Save Plot
png("Figure9focal.png", units = "cm", width = 15, height = 10, res = 600)
plot(Fig9focal)
dev.off()