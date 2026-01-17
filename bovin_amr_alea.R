# ==============================================================================
# Project: Bovine AMR Longitudinal Analysis
# Script: generate_figure1_robust_v9_full_stats.R
# Author: Makiko Fujita-Suzanne
# Date: Jan 17, 2026
# Description: 
#   - Robust data loading & cleaning.
#   - Figure 1 generation (Decoupling visualization).
#   - Statistical Analysis 1: Decoupling (Resistance vs Co-selection).
#   - Statistical Analysis 2: Exposure vs Resistance Correlation.
# ==============================================================================

# 1. Setup
if(!require("ggplot2")) install.packages("ggplot2")
if(!require("patchwork")) install.packages("patchwork")
if(!require("dplyr")) install.packages("dplyr")
if(!require("tidyr")) install.packages("tidyr")

library(ggplot2)
library(patchwork)
library(dplyr)
library(tidyr)

# ==============================================================================
# 2. Data Loading & Cleaning (Robust Method)
# ==============================================================================

# File Names
file_res <- "data/resistance_colistin_2006-2021.csv"
file_exp <- "data/alea_exposure_2006_2021.csv"

# 2.1 Load Resistance Data
if(!file.exists(file_res)) stop(paste("File not found:", file_res))
raw_res <- read.csv(file_res, check.names = FALSE, stringsAsFactors = FALSE)

# Transpose
df_res <- as.data.frame(t(raw_res[,-1]))
colnames(df_res) <- trimws(raw_res[,1]) 
df_res$Year <- as.numeric(rownames(df_res))

# Robust Renaming (Resistance)
col_colistin <- grep("Colistin", colnames(df_res), ignore.case = TRUE)
if(length(col_colistin) > 0) colnames(df_res)[col_colistin] <- "Colistin"

col_mix <- grep("Trim.*sulfa", colnames(df_res), ignore.case = TRUE)
if(length(col_mix) > 0) colnames(df_res)[col_mix] <- "Mix"

# Filter 2006-2024
df_res <- df_res %>% filter(Year >= 2006 & Year <= 2024)
df_res$Colistin <- as.numeric(df_res$Colistin)
df_res$Mix <- as.numeric(df_res$Mix)

# Check columns
if(!("Colistin" %in% colnames(df_res)) | !("Mix" %in% colnames(df_res))) {
  stop("Error: Could not identify 'Colistin' or 'Mix' columns in Resistance file.")
}

# 2.2 Load Exposure Data (ALEA)
if(!file.exists(file_exp)) stop(paste("File not found:", file_exp))
raw_exp <- read.csv(file_exp, check.names = FALSE, stringsAsFactors = FALSE)

# Transpose
df_exp <- as.data.frame(t(raw_exp[,-1]))
colnames(df_exp) <- trimws(raw_exp[,1]) 
df_exp$Year <- as.numeric(rownames(df_exp))

# Robust Renaming (ALEA)
col_poly <- grep("Polymyxin", colnames(df_exp), ignore.case = TRUE)
if(length(col_poly) > 0) colnames(df_exp)[col_poly] <- "Colistin_Exp"

col_sulfa <- grep("Sulfonamide", colnames(df_exp), ignore.case = TRUE)
if(length(col_sulfa) > 0) colnames(df_exp)[col_sulfa] <- "Sulfa_Exp"

col_tmp <- grep("Trimethoprim", colnames(df_exp), ignore.case = TRUE)
if(length(col_tmp) > 0) colnames(df_exp)[col_tmp[1]] <- "TMP_Exp"

# Filter 2006-2020 ONLY
df_exp <- df_exp %>% filter(Year >= 2006 & Year <= 2020)

# Select columns
df_exp <- df_exp %>% select(Year, Colistin_Exp, Sulfa_Exp, TMP_Exp)
df_exp$Colistin_Exp <- as.numeric(df_exp$Colistin_Exp)

# Long Format for Plotting
df_exp_long <- df_exp %>%
  pivot_longer(cols = -Year, names_to = "Antibiotic", values_to = "Exposure")

# ==============================================================================
# 3. Visualization
# ==============================================================================

theme_base <- theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(size = 11),
    axis.text = element_text(size = 10),
    legend.position = "bottom", 
    legend.box = "horizontal",
    legend.title = element_blank()
  )

y_box_min <- 55; y_box_max <- 62; y_text <- 58.5

# --- Plot A: Resistance Trends ---
p1 <- ggplot(df_res, aes(x = Year)) +
  # Ecoantibio Annotations
  annotate("rect", xmin = 2012, xmax = 2016, ymin = y_box_min, ymax = y_box_max, fill = "gray85", alpha = 0.5) +
  annotate("text", x = 2014, y = y_text, label = "Ecoantibio 1", size = 3, fontface = "bold", color="gray30") +
  annotate("rect", xmin = 2017, xmax = 2021, ymin = y_box_min, ymax = y_box_max, fill = "gray85", alpha = 0.5) +
  annotate("text", x = 2019, y = y_text, label = "Ecoantibio 2", size = 3, fontface = "bold", color="gray30") +
  annotate("rect", xmin = 2024, xmax = 2025, ymin = y_box_min, ymax = y_box_max, fill = "gray85", alpha = 0.5) +
  annotate("text", x = 2024.5, y = y_text, label = "Eco 3", size = 3, fontface = "bold", color="gray30") +
  
  # Lines
  geom_line(aes(y = Colistin, color = "Colistin (Resistance)"), size = 1.2) +
  geom_point(aes(y = Colistin, color = "Colistin (Resistance)"), size = 2) +
  geom_line(aes(y = Mix, color = "TMP-SMX (Resistance)"), size = 1.2, linetype = "dashed") +
  geom_point(aes(y = Mix, color = "TMP-SMX (Resistance)"), size = 2, shape = 15) +
  
  # Decoupling Annotation
  geom_vline(xintercept = 2017, linetype = "dotted", color = "black", size = 0.8) +
  annotate("text", x = 2017.3, y = 5, label = "Decoupling (2017)", 
           color = "black", angle = 90, hjust = 0, size = 3.5, fontface = "italic") +
  
  scale_color_manual(values = c("Colistin (Resistance)" = "#e74c3c", "TMP-SMX (Resistance)" = "#f1c40f")) +
  scale_y_continuous(limits = c(0, 65), breaks = seq(0, 60, 10)) + 
  scale_x_continuous(breaks = seq(2006, 2024, 2), limits = c(2006, 2025)) +
  labs(title = "A. Resistance Trends vs. Policy Phases", y = "Resistance Rate (%)", x = NULL) +
  theme_base

# --- Plot B: Exposure Trends ---
p2 <- ggplot(df_exp_long, aes(x = Year, y = as.numeric(Exposure), color = Antibiotic)) +
  geom_line(size = 1.2) + geom_point(size = 2) +
  geom_vline(xintercept = 2017, linetype = "dotted", color = "black", size = 0.8) +
  scale_color_manual(labels = c("Colistin (Exp)", "Sulfonamides (Exp)", "Trimethoprim (Exp)"),
                     values = c("Colistin_Exp" = "#e74c3c", 
                                "Sulfa_Exp" = "#9b59b6", 
                                "TMP_Exp" = "#3498db")) +
  scale_x_continuous(breaks = seq(2006, 2024, 2), limits = c(2006, 2025)) +
  labs(title = "B. Antimicrobial Exposure Trends (ALEA Index)",
       y = "Exposure Level (ALEA)", x = "Year",
       caption = "Data Sources: RESAPATH & ALEA (csv files)") +
  theme_base

# Combine
figure1_robust <- (p1 / p2) + 
  plot_layout(guides = "collect") & 
  theme(legend.position = "bottom")

# Output
ggsave("Figure1_Robust.png", plot = figure1_robust, width = 8, height = 10, dpi = 300, bg = "white")
print(figure1_robust)

# ==============================================================================
# 4. Statistical Analysis
# ==============================================================================
message("\n========== STATISTICAL ANALYSIS REPORT ==========")
SPLIT_YEAR <- 2017

# ------------------------------------------------------------------------------
# Analysis 1: Decoupling (Resistance vs TMP-SMX Resistance)
# ------------------------------------------------------------------------------
message("\n>>> 1. Resistance Decoupling Analysis (Colistin vs TMP-SMX Resistance)")
df_res$Phase <- ifelse(df_res$Year < SPLIT_YEAR, "Phase I (2006-2016)", "Phase II (2017-2024)")

# Correlation
results_corr <- df_res %>% 
  group_by(Phase) %>% 
  summarise(
    N = n(),
    r = cor(Colistin, Mix, use="complete.obs"), 
    p_value = cor.test(Colistin, Mix)$p.value
  )
print(results_corr)

# Interaction Model (Structural Break)
df_res$Period_Binary <- ifelse(df_res$Year < SPLIT_YEAR, 0, 1)
model_interaction <- lm(Colistin ~ Mix * Period_Binary, data = df_res)
p_interaction <- summary(model_interaction)$coefficients["Mix:Period_Binary", "Pr(>|t|)"]

if(p_interaction < 0.05) {
  message(paste0("RESULT: SIGNIFICANT STRUCTURAL BREAK DETECTED (p = ", format.pval(p_interaction, eps=0.001), ")"))
}

# ------------------------------------------------------------------------------
# Analysis 2: Exposure Impact (Colistin Exposure vs Colistin Resistance)
# ------------------------------------------------------------------------------
message("\n>>> 2. Exposure Impact Analysis (Colistin Exposure vs Resistance)")

# Merge Resistance and Exposure Data (Overlapping years only: 2006-2020)
df_merged <- merge(df_res[,c("Year", "Colistin")], df_exp[,c("Year", "Colistin_Exp")], by="Year")
df_merged$Phase <- ifelse(df_merged$Year < SPLIT_YEAR, "Phase I (2006-2016)", "Phase II (2017-2020)")

# Correlation between Exposure and Resistance
results_exp_corr <- df_merged %>% 
  group_by(Phase) %>% 
  summarise(
    N = n(),
    r = cor(Colistin, Colistin_Exp, use="complete.obs"), 
    p_value = cor.test(Colistin, Colistin_Exp)$p.value
  )

# Add Overall Correlation
overall_corr <- data.frame(
  Phase = "Overall (2006-2020)",
  N = nrow(df_merged),
  r = cor(df_merged$Colistin, df_merged$Colistin_Exp, use="complete.obs"),
  p_value = cor.test(df_merged$Colistin, df_merged$Colistin_Exp)$p.value
)

results_exp_final <- rbind(overall_corr, results_exp_corr)
print(results_exp_final)

message("\n==================================================")
