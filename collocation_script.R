current_dir <- getwd() # This gets the current working directory
setwd("/Users/jordanchark/collo") # This sets the working directory


# Import the CSV file into a data frame
collotextasafnbuinn <- read.csv("/Users/jordanchark/collo/161718.csv", sep = ";")
colloicepahc1900 <- read.csv("/Users/jordanchark/collo/icepahc_1900.csv", sep = ";")
progcoll1920 <- read.csv("/Users/jordanchark/collo/1920progcollfix.csv", sep = ";")

# Filter the data to only include rows where Construction is "BUINN"
data_filtered <- subset(collotextasafnbuinn, Construction == "BUINN")
data_filtered2 <- subset(colloicepahc1900, Construction == "BUINN")
data_filtered3 <- subset(progcoll1920, Construction == "PROG")

# Count the frequency of each subordinator with "BUINN"
freq_count <- table(data_filtered$Adv)
freq_count2 <- table(data_filtered2$Adv)
freq_count3 <- table(data_filtered3$Adv)

head(freq_count)
head(freq_count2)
head(freq_count3)

# Calculate the frequency ratio
total_count <- sum(freq_count)
freq_ratio <- freq_count / total_count

total_count2 <- sum(freq_count2)
freq_ratio2 <- freq_count2 / total_count2

total_count3 <- sum(freq_count3)
freq_ratio3 <- freq_count3 / total_count3

# Create a data frame for the results and sort by frequency ratio
result <- data.frame(Adv = names(freq_ratio), Frequency_Ratio = as.vector(freq_ratio))
result <- result[order(-result$Frequency_Ratio),]

result2 <- data.frame(Adv = names(freq_ratio2), Frequency_Ratio2 = as.vector(freq_ratio2))
result2 <- result2[order(-result2$Frequency_Ratio2),]

result3 <- data.frame(Adv = names(freq_ratio3), Frequency_Ratio3 = as.vector(freq_ratio3))
result3 <- result3[order(-result3$Frequency_Ratio3),]

# Calculate the percentage for better interpretability
result$Percentage <- (result$Frequency_Ratio * 100)

result2$Percentage <- (result2$Frequency_Ratio2 * 100)
result3$Percentage <- (result3$Frequency_Ratio3 * 100)

# Display the result
print(result)
print(result2)
print(result3)

# Optionally, you can write this table back to a new CSV file if needed
write.csv(result, "result.csv", row.names = FALSE)


library(xtable)
latex_table1 <- xtable(result, caption = "Frequency ratio and percentage for BUINN in 161718.csv")
latex_table2 <- xtable(result2, caption = "Frequency ratio and percentage for BUINN in icepahc_1900.csv")
latex_table3 <- xtable(result3, caption = "Frequency ratio and percentage for PROG in 1920progcollfix.csv")

# Print the LaTeX tables
print(latex_table1, type = "latex", comment = FALSE)
print(latex_table2, type = "latex", comment = FALSE)
print(latex_table3, type = "latex", comment = FALSE)



#We import the Sub_After stuff
df_advmod <- read.csv("advmod_counts_proportions.csv")
latex_table4 <- xtable(df_advmod, caption = "Freq. of búinn in subordinate clauses expressing sequentiality")
print(latex_table4, type = "latex", comment = FALSE)
