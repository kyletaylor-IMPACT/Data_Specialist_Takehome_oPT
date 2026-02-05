#############################################
# WANP WANP Data Analysis Exercise
# Author: Kyle Taylor
# File: analysis.R
#
# Goal:
# Assess whether combining Cohort One and Cohort Two into a single analytical cohort is statistically sound.
#
# How to run:
# 1) In RStudio set working directory
# 2) Install packages
# 3) source("analysis.R")
#############################################

# Packages
install.packages(c("tidyverse", "readxl"), quiet = TRUE)
library(tidyverse)
library(readxl)

# Create dummy WANP dataset
set.seed(123)

n <- 120  # total households

test_df <- tibble(
  cohort = sample(
    c("Cohort One", "Cohort Two"),
    size = n,
    replace = TRUE,
    prob = c(0.55, 0.45)
  ),
  governorate = sample(
    c("North", "South", "East", "West"),
    size = n,
    replace = TRUE
  ),
  sampling_framework = sample(
    c("Permanent shelter", "Temporary shelter"),
    size = n,
    replace = TRUE,
    prob = c(0.7, 0.3)
  ),
  head_hh_gender = sample(
    c("Male", "Female"),
    size = n,
    replace = TRUE,
    prob = c(0.65, 0.35)
  ),
  sum_hh_members = round(rnorm(n, mean = 6, sd = 2)),
  hhs = pmax(0, round(rnorm(n, mean = 3, sd = 1.5))),
  fcs = round(rnorm(n, mean = 45, sd = 10)),
  ecfies = pmax(0, round(rnorm(n, mean = 2, sd = 1)))
)

# Introduce some missing values
test_df <- test_df %>%
  mutate(
    hhs = ifelse(runif(n) < 0.05, NA, hhs),
    fcs = ifelse(runif(n) < 0.05, NA, fcs),
    ecfies = ifelse(runif(n) < 0.05, NA, ecfies)
  )

# Inspect
print(head(test_df))
summary(test_df)

write.csv(test_df, "WANP_df.csv")

# Keep only variables we need
test_df <- test_df %>%
  transmute(
    cohort = as.factor(cohort),
    governorate = as.factor(governorate),
    sampling_framework = as.factor(sampling_framework),
    head_hh_gender = as.factor(head_hh_gender),
    sum_hh_members = as.numeric(sum_hh_members),
    hhs = as.numeric(hhs),
    fcs = as.numeric(fcs),
    ecfies = as.numeric(ecfies)
  )

# 1) Basic counts
cohort_counts <- test_df %>%
  count(cohort) %>%
  mutate(pct = n / sum(n))

write_csv(cohort_counts, "cohort_counts.csv")

# 2) Missingness
missingness <- tibble(
  variable = names(test_df),
  missing_n = sapply(test_df, function(x) sum(is.na(x))),
  missing_pct = missing_n / nrow(test_df)
) %>% arrange(desc(missing_pct))

write_csv(missingness, "missingness.csv")

# 3) Categorical comparisons (Chi-square)
cat_vars <- c("governorate", "sampling_framework", "head_hh_gender")

cat_tests <- map_dfr(cat_vars, function(v) {
  sub <- test_df %>% select(cohort, all_of(v)) %>% drop_na()
  tab <- table(sub[[v]], sub$cohort)
  p <- suppressWarnings(chisq.test(tab))$p.value
  tibble(variable = v, test = "chi-square", p_value = p)
})

write_csv(cat_tests, "categorical_tests.csv")

# 4) Continuous comparisons (t-test)
cont_vars <- c("sum_hh_members", "hhs", "fcs", "ecfies")

cont_tests <- map_dfr(cont_vars, function(v) {
  sub <- test_df %>% select(cohort, all_of(v)) %>% drop_na()
  p <- t.test(sub[[v]] ~ sub$cohort)$p.value
  tibble(variable = v, test = "t-test", p_value = p)
})

write_csv(cont_tests, "continuous_tests.csv")

# 5) Simple descriptive stats (mean/sd) by cohort
summary_stats <- test_df %>%
  group_by(cohort) %>%
  summarise(
    n = n(),
    sum_hh_members_mean = mean(sum_hh_members, na.rm = TRUE),
    sum_hh_members_sd   = sd(sum_hh_members, na.rm = TRUE),
    hhs_mean = mean(hhs, na.rm = TRUE),
    hhs_sd   = sd(hhs, na.rm = TRUE),
    fcs_mean = mean(fcs, na.rm = TRUE),
    fcs_sd   = sd(fcs, na.rm = TRUE),
    ecfies_mean = mean(ecfies, na.rm = TRUE),
    ecfies_sd   = sd(ecfies, na.rm = TRUE),
    .groups = "drop"
  )

write_csv(summary_stats, "summary_by_cohort.csv")

