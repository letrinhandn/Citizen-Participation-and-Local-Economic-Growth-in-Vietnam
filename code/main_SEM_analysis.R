################################################################################
# Complete SEM Analysis Pipeline: Citizen Participation and Economic Growth
# Vietnam Provincial Panel Data (2012-2019, excluding 2020-2021)
# Author: Le Tri Nhan | LSE GV499 Dissertation (2025)
################################################################################

library(readxl)
library(dplyr)
library(ggplot2)
library(lavaan)
library(semPlot)
library(car)
library(Hmisc)
library(openxlsx)
library(psych)
library(e1071)
library(GGally)
library(gridExtra)
library(patchwork)
library(fixest)
library(tidyr)
library(knitr)

set.seed(12345)

################################################################################
# 1. DATA LOADING AND PREPARATION
################################################################################

data_path <- "your_data_path.xlsx"
df_raw <- read_excel(data_path)

df <- df_raw %>%
  filter(!(YEAR %in% c(2020, 2021))) %>%
  mutate(across(c(CP1, CP2, CP3, CP4, PCI4, PCI8, GRDPperCap2010, Avg_Income), as.numeric)) %>%
  arrange(ID, YEAR) %>%
  group_by(ID) %>%
  mutate(
    CP1_lag = lag(CP1, order_by = YEAR),
    CP2_lag = lag(CP2, order_by = YEAR),
    CP3_lag = lag(CP3, order_by = YEAR),
    CP4_lag = lag(CP4, order_by = YEAR),
    Avg_Income_lag = lag(Avg_Income, order_by = YEAR),
    Avg_Income_lag_m = Avg_Income_lag / 1e6,
    log_GRDPperCap2010 = log(GRDPperCap2010)
  ) %>%
  ungroup()

exo_vars <- c("CP1_lag", "CP2_lag", "CP3_lag", "CP4_lag", "Avg_Income_lag_m")
df <- df %>% filter(if_all(all_of(exo_vars), ~ !is.na(.)))

dir.create("output/tables", recursive = TRUE, showWarnings = FALSE)
dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)

################################################################################
# 2. DESCRIPTIVE STATISTICS
################################################################################

desc_vars <- c("Avg_Income", "CP1", "CP2", "CP3", "CP4", "PCI4", "PCI8", 
               "GRDPperCap2010", "log_GRDPperCap2010")

mk_desc <- function(x) {
  x <- x[!is.na(x)]
  c(Obs = length(x), Mean = mean(x), `Std. Dev.` = sd(x), 
    Min = min(x), Max = max(x))
}

tab_desc <- t(sapply(desc_vars, function(v) mk_desc(df[[v]]))) %>% 
  as.data.frame() %>%
  tibble::rownames_to_column("Variable")

write.xlsx(tab_desc, "output/tables/01_descriptive_statistics.xlsx", overwrite = TRUE)

################################################################################
# 3. MISSING DATA ANALYSIS
################################################################################

miss_vars <- c("log_GRDPperCap2010", "CP1", "CP2", "CP3", "CP4", 
               "PCI4", "PCI8", "Avg_Income")
miss_pct <- sapply(miss_vars, function(v) mean(is.na(df[[v]])) * 100)

tab_missing <- data.frame(
  Variable = names(miss_pct),
  `Missing_Pct` = round(unname(miss_pct), 2)
)

write.xlsx(tab_missing, "output/tables/02_missing_data.xlsx", overwrite = TRUE)

################################################################################
# 4. MULTICOLLINEARITY DIAGNOSTICS
################################################################################

vif_vars <- c("CP1_lag", "CP2_lag", "CP3_lag", "CP4_lag", 
              "PCI4", "PCI8", "Avg_Income_lag_m")
df_vif <- df %>% select(log_GRDPperCap2010, all_of(vif_vars)) %>% na.omit()

vif_model <- lm(log_GRDPperCap2010 ~ ., data = df_vif)
vif_values <- car::vif(vif_model)

tab_vif <- data.frame(
  Variable = names(vif_values),
  VIF = round(as.numeric(vif_values), 3)
)

write.xlsx(tab_vif, "output/tables/03_vif_diagnostics.xlsx", overwrite = TRUE)

################################################################################
# 5. CORRELATION MATRIX
################################################################################

corr_vars <- c("CP1_lag", "CP2_lag", "CP3_lag", "CP4_lag", 
               "PCI4", "PCI8", "Avg_Income_lag_m")
X <- df %>% select(all_of(corr_vars)) %>% na.omit() %>% as.matrix()

rc <- Hmisc::rcorr(X, type = "pearson")
r <- rc$r
p <- rc$P

pstar <- function(pval) ifelse(pval < .01, "**", ifelse(pval < .05, "*", ""))

fmt <- matrix("", nrow = length(corr_vars), ncol = length(corr_vars))
for (i in seq_along(corr_vars)) {
  for (j in seq_along(corr_vars)) {
    if (i == j) {
      fmt[i, j] <- "1.000"
    } else {
      fmt[i, j] <- sprintf("%.3f%s", r[i, j], pstar(p[i, j]))
    }
  }
}

tab_corr <- as.data.frame(fmt, stringsAsFactors = FALSE)
colnames(tab_corr) <- rownames(tab_corr) <- corr_vars
tab_corr <- tibble::rownames_to_column(tab_corr, "Variable")

write.xlsx(tab_corr, "output/tables/04_correlation_matrix.xlsx", overwrite = TRUE)

################################################################################
# 6. DISTRIBUTION CHECKS
################################################################################

hist_vars <- c("GRDPperCap2010", "log_GRDPperCap2010", "Avg_Income",
               "CP1", "CP2", "CP3", "CP4", "PCI4", "PCI8")

mk_hist <- function(v) {
  s <- df[[v]]
  sk <- round(e1071::skewness(s, na.rm = TRUE), 2)
  ggplot(df, aes_string(x = v)) +
    geom_histogram(bins = 30, fill = "#7fc8ff", color = "black") +
    labs(title = v, y = NULL, x = NULL) +
    annotate("text", x = -Inf, y = Inf, label = paste0("Skew: ", sk),
             hjust = -0.1, vjust = 1.4, size = 3) +
    theme_minimal(base_size = 10) +
    theme(plot.title = element_text(face = "bold", size = 10),
          panel.grid.minor = element_blank())
}

hist_list <- lapply(hist_vars, mk_hist)
fig_hist <- wrap_plots(hist_list, ncol = 3)

ggsave("output/figures/fig1_distributions.png", fig_hist, 
       width = 10, height = 8, dpi = 300)

################################################################################
# 7. LINEARITY CHECKS
################################################################################

mk_scatter <- function(xvar, yvar, title) {
  dfp <- df %>% select(all_of(c(xvar, yvar))) %>% na.omit()
  ggplot(dfp, aes_string(x = xvar, y = yvar)) +
    geom_point(color = "grey30", alpha = 0.6, size = 1.2) +
    geom_smooth(method = "lm", se = FALSE, color = "red", linewidth = 0.8) +
    labs(title = title, x = xvar, y = yvar) +
    theme_minimal(base_size = 9) +
    theme(plot.title = element_text(face = "bold", size = 9),
          panel.grid.minor = element_blank())
}

lin_plots <- list(
  mk_scatter("CP1_lag", "PCI4", "CP1 → PCI4"),
  mk_scatter("CP2_lag", "PCI4", "CP2 → PCI4"),
  mk_scatter("CP3_lag", "PCI4", "CP3 → PCI4"),
  mk_scatter("CP4_lag", "PCI4", "CP4 → PCI4"),
  mk_scatter("CP1_lag", "PCI8", "CP1 → PCI8"),
  mk_scatter("CP2_lag", "PCI8", "CP2 → PCI8"),
  mk_scatter("CP3_lag", "PCI8", "CP3 → PCI8"),
  mk_scatter("CP4_lag", "PCI8", "CP4 → PCI8"),
  mk_scatter("PCI4", "log_GRDPperCap2010", "PCI4 → log(GRDP)"),
  mk_scatter("PCI8", "log_GRDPperCap2010", "PCI8 → log(GRDP)"),
  mk_scatter("Avg_Income_lag_m", "log_GRDPperCap2010", "Income → log(GRDP)")
)

fig_linearity <- wrap_plots(lin_plots, ncol = 2)
ggsave("output/figures/fig2_linearity.png", fig_linearity, 
       width = 10, height = 12, dpi = 300)

################################################################################
# 8. MAIN SEM MODEL SPECIFICATION
################################################################################

model_main <- '
  PCI4 ~ a41*CP1_lag + a42*CP2_lag + a43*CP3_lag + a44*CP4_lag + a45*Avg_Income_lag_m
  PCI8 ~ a81*CP1_lag + a82*CP2_lag + a83*CP3_lag + a84*CP4_lag + a85*Avg_Income_lag_m

  log_GRDPperCap2010 ~ b4*PCI4 + b8*PCI8
  
  PCI4 ~~ PCI8

  ind4_CP1 := a41*b4
  ind4_CP2 := a42*b4
  ind4_CP3 := a43*b4
  ind4_CP4 := a44*b4
  ind4_INC := a45*b4

  ind8_CP1 := a81*b8
  ind8_CP2 := a82*b8
  ind8_CP3 := a83*b8
  ind8_CP4 := a84*b8
  ind8_INC := a85*b8

  tot_ind_CP1 := ind4_CP1 + ind8_CP1
  tot_ind_CP2 := ind4_CP2 + ind8_CP2
  tot_ind_CP3 := ind4_CP3 + ind8_CP3
  tot_ind_CP4 := ind4_CP4 + ind8_CP4
  tot_ind_INC := ind4_INC + ind8_INC
'

################################################################################
# 9. MODEL ESTIMATION
################################################################################

fit_main <- sem(
  model_main,
  data = df,
  estimator = "MLR",
  missing = "FIML",
  cluster = "ID",
  fixed.x = TRUE
)

summary(fit_main, standardized = TRUE, fit.measures = TRUE, rsquare = TRUE)

pe_main <- parameterEstimates(fit_main, standardized = TRUE)
write.xlsx(pe_main, "output/tables/05_sem_main_estimates.xlsx", overwrite = TRUE)

################################################################################
# 10. FIT INDICES
################################################################################

fit_stats <- fitMeasures(fit_main, c(
  "chisq", "df", "pvalue", "rmsea", "rmsea.ci.lower", "rmsea.ci.upper",
  "cfi", "tli", "srmr"
))

tab_fit <- data.frame(
  Index = names(fit_stats),
  Value = round(fit_stats, 4)
)

write.xlsx(tab_fit, "output/tables/06_model_fit.xlsx", overwrite = TRUE)

################################################################################
# 11. PATH DIAGRAM
################################################################################

node_labels <- c(
  CP1_lag = "CP1(t-1)", CP2_lag = "CP2(t-1)", 
  CP3_lag = "CP3(t-1)", CP4_lag = "CP4(t-1)",
  Avg_Income_lag_m = "Income(t-1)",
  PCI4 = "PCI4", PCI8 = "PCI8",
  log_GRDPperCap2010 = "log(GRDP)"
)

png("output/figures/fig3_sem_path.png", width = 2400, height = 1600, res = 300)
semPaths(
  fit_main,
  what = "std",
  whatLabels = "est",
  layout = "tree2",
  style = "lisrel",
  residuals = FALSE,
  intercepts = FALSE,
  edge.color = "black",
  color = list(lat = "lightblue", man = "lightyellow"),
  label.cex = 1.0,
  edge.label.cex = 0.85,
  nodeLabels = node_labels,
  curvePivot = TRUE
)
dev.off()

################################################################################
# 12. ROBUSTNESS: BOOTSTRAP
################################################################################

fit_boot <- sem(
  model_main,
  data = df,
  estimator = "ML",
  se = "bootstrap",
  bootstrap = 1000,
  fixed.x = TRUE
)

pe_boot <- parameterEstimates(fit_boot, standardized = TRUE, 
                              ci = TRUE, boot.ci.type = "perc")
write.xlsx(pe_boot, "output/tables/07_bootstrap_estimates.xlsx", overwrite = TRUE)

################################################################################
# 13. ROBUSTNESS: EXCLUDE TOP 5% PROVINCES
################################################################################

mean_grdp <- df %>%
  group_by(ID) %>%
  summarize(mean_GRDP = mean(GRDPperCap2010, na.rm = TRUE), .groups = "drop")

q95 <- quantile(mean_grdp$mean_GRDP, 0.95, na.rm = TRUE)
ids_keep <- mean_grdp %>% filter(mean_GRDP < q95) %>% pull(ID)
df_trim <- df %>% filter(ID %in% ids_keep)

fit_trim <- sem(model_main, data = df_trim, estimator = "MLR", 
                missing = "FIML", cluster = "ID", fixed.x = TRUE)

pe_trim <- parameterEstimates(fit_trim, standardized = TRUE)
write.xlsx(pe_trim, "output/tables/08_trimmed_estimates.xlsx", overwrite = TRUE)

################################################################################
# 14. ROBUSTNESS: YEAR FIXED EFFECTS
################################################################################

year_mat <- model.matrix(~ factor(YEAR), data = df)
year_df <- as.data.frame(year_mat[, -1, drop = FALSE])
colnames(year_df) <- gsub("factor\\(YEAR\\)", "DY", colnames(year_df))
df_year <- bind_cols(df, year_df)

dy_rhs <- paste(colnames(year_df), collapse = " + ")

model_year <- paste0('
  PCI4 ~ a41*CP1_lag + a42*CP2_lag + a43*CP3_lag + a44*CP4_lag + 
         a45*Avg_Income_lag_m + ', dy_rhs, '
  PCI8 ~ a81*CP1_lag + a82*CP2_lag + a83*CP3_lag + a84*CP4_lag + 
         a85*Avg_Income_lag_m + ', dy_rhs, '
  log_GRDPperCap2010 ~ b4*PCI4 + b8*PCI8 + ', dy_rhs, '
  PCI4 ~~ PCI8
  
  ind4_CP4 := a44*b4
  ind8_CP4 := a84*b8
  tot_ind_CP4 := ind4_CP4 + ind8_CP4
')

fit_year <- sem(model_year, data = df_year, estimator = "MLR", 
                missing = "FIML", cluster = "ID", fixed.x = TRUE)

pe_year <- parameterEstimates(fit_year, standardized = TRUE)
write.xlsx(pe_year, "output/tables/09_year_fe_estimates.xlsx", overwrite = TRUE)

################################################################################
# 15. COMPARATIVE CASE STUDY: QUANG NINH VS DONG THAP
################################################################################

normalize_province <- function(x) {
  tolower(gsub("[^[:alnum:]]", "", x))
}

df_case <- df %>%
  mutate(Province_clean = normalize_province(Province)) %>%
  filter(Province_clean %in% c("quangninh", "dongthap"))

if (nrow(df_case) > 0) {
  df_case <- df_case %>%
    mutate(Province_EN = case_when(
      grepl("quangninh", Province_clean) ~ "Quang Ninh",
      grepl("dongthap", Province_clean) ~ "Dong Thap",
      TRUE ~ as.character(Province)
    ))
  
  plot_case <- function(var, ylab) {
    ggplot(df_case, aes(x = YEAR, y = .data[[var]], 
                        color = Province_EN, group = Province_EN)) +
      geom_line(linewidth = 1.2) +
      geom_point(size = 2.5) +
      scale_color_manual(values = c("Quang Ninh" = "#E41A1C", 
                                    "Dong Thap" = "#377EB8")) +
      labs(x = "Year", y = ylab, color = NULL) +
      theme_minimal(base_size = 12) +
      theme(legend.position = "bottom",
            panel.grid.minor = element_blank())
  }
  
  ggsave("output/figures/fig4_case_cp4.png", 
         plot_case("CP4", "CP4"), width = 8, height = 5, dpi = 300)
  ggsave("output/figures/fig5_case_pci4.png", 
         plot_case("PCI4", "PCI4"), width = 8, height = 5, dpi = 300)
  ggsave("output/figures/fig6_case_pci8.png", 
         plot_case("PCI8", "PCI8"), width = 8, height = 5, dpi = 300)
  ggsave("output/figures/fig7_case_grdp.png", 
         plot_case("log_GRDPperCap2010", "log(GRDP per capita)"), 
         width = 8, height = 5, dpi = 300)
}

################################################################################
# 16. RESULTS TABLES
################################################################################

p2star <- function(p) {
  ifelse(p < 0.001, "***", ifelse(p < 0.01, "**", 
         ifelse(p < 0.05, "*", "")))
}

cp_names <- c("CP1_lag", "CP2_lag", "CP3_lag", "CP4_lag", "Avg_Income_lag_m")

grab_indirect <- function(i) {
  r4 <- pe_main %>% filter(label == paste0("ind4_", c("CP1","CP2","CP3","CP4","INC")[i]))
  r8 <- pe_main %>% filter(label == paste0("ind8_", c("CP1","CP2","CP3","CP4","INC")[i]))
  data.frame(
    Variable = cp_names[i],
    `PCI4_est` = round(r4$est, 3),
    `PCI4_se` = round(r4$se, 3),
    `PCI4_sig` = p2star(r4$pvalue),
    `PCI8_est` = round(r8$est, 3),
    `PCI8_se` = round(r8$se, 3),
    `PCI8_sig` = p2star(r8$pvalue),
    check.names = FALSE
  )
}

tab_indirect <- do.call(rbind, lapply(1:5, grab_indirect))
write.xlsx(tab_indirect, "output/tables/10_indirect_effects.xlsx", overwrite = TRUE)

################################################################################
# END
################################################################################

cat("\n", rep("=", 80), "\n", sep = "")
cat("ANALYSIS COMPLETE\n")
cat(rep("=", 80), "\n", sep = "")
cat("\nAll outputs saved in: output/\n")
cat("  - Tables: output/tables/\n")
cat("  - Figures: output/figures/\n\n")