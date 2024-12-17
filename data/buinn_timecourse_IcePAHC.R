# Dependencies
library(ggplot2)
library(dplyr)
library(viridis)
library(ggrepel)
library(readr)

#### Part 1: Time Course Analysis ####

# Data Processing Function
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
  
  # Extract year, textid, and genre information
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

# Load and Process Time Course Data
buinn_all <- process_summary("infbuinnsum.txt")
buinn_all <- distinct(buinn_all, source, .keep_all = TRUE)

# Data Preparation for Time Course
buinn_all$simplified_genre <- gsub("-(.*)", "", buinn_all$genre)
buinn_all <- buinn_all %>%
  group_by(textid) %>%
  mutate(relative_frequency = hits / sum(total) * 100) %>%
  filter(simplified_genre != "psd")  # Remove psd genre

# Create Time Course Plot
buinn_all_plot <- ggplot(subset(buinn_all, year >= 1600), 
                        aes(x = year, y = relative_frequency, 
                            color = simplified_genre, size = hits)) +
  geom_point(alpha = 0.7) +
  scale_color_viridis_d() + 
  scale_size(range = c(1, 10)) +
  geom_text_repel(aes(label = textid),
                  size = 3,
                  max.overlaps = 10,
                  box.padding = 0.5) +
  labs(title = "Búinn in IcePAHC (1600 onwards)",
       x = "Year",
       y = "Rel. freq") +
  theme_minimal() +
  theme(legend.position = "right")

#### Part 2: Tense Distribution Analysis ####

# Load and Process Tense Data
buinn_tense <- read.csv(file = "buinn-mine-an-fixfinal.csv", sep = ",", header = TRUE)

# Filter and Process Tense Data
buinn_tense_filtered <- buinn_tense %>%
  filter(Anterior == "Yes") %>%
  filter(Clause != "Relative") %>%
  filter(!is.na(Clause)) %>%
  filter(!is.na(Tense)) %>%
  mutate(century = (YEAR - 1) %/% 100 + 1)

# Aggregate Tense Data
buinn_tense_agg <- buinn_tense_filtered %>%
  mutate(Tense = recode(Tense, "Samsett" = "Compound")) %>%
  group_by(century, Clause, YEAR, GENRE, Tense) %>%
  summarise(count = n(), .groups = 'drop')

# Create Century Distribution Plot
fig2buinn <- ggplot(buinn_tense_agg, aes(x = century, y = count, fill = Tense)) +
  geom_col(position = "stack") +
  facet_wrap(~Clause, nrow = 2) +
  scale_fill_viridis_d() +
  scale_x_continuous(limits = c(15, NA), breaks = seq(16, 20, by = 2)) +
  labs(title = "BÚINN by Century in IcePAHC",
       x = "Century",
       y = "Count",
       fill = "Tense") +
  theme_minimal()

#### Save Plots ####

# Save Time Course Plot
png("Fig3BuinnTimeCourse.png", units = "cm", width = 15, height = 10, res = 600)
plot(buinn_all_plot)
dev.off()

# Save Century Distribution Plot
png("Fig2Buinndescr.png", units = "cm", width = 15, height = 10, res = 600)
plot(fig2buinn)
dev.off()