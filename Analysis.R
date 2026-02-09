# Load dataset
df <- read_excel("Walloland_WANP_clean_data.xlsx")

# Load Kobo tool (survey sheet only)
survey <- read_excel("WANP Tool.xlsx", sheet = "survey")

# Extract variable names
data_vars <- names(df)
kobo_vars <- survey$name

# Variables in dataset NOT in Kobo tool
extra_vars <- setdiff(data_vars, kobo_vars)

# View them
extra_vars

### Load dataset
df <- read_excel("Walloland_WANP_clean_data.xlsx") 

# Load Kobo tool (survey sheet only)
survey <- read_excel("WANP Tool.xlsx", sheet = "survey")

# Extract variable names
data_vars <- names(df)
kobo_vars <- survey$name

# Variables in dataset NOT in Kobo tool
extra_vars <- setdiff(data_vars, kobo_vars)

# View them
extra_vars

##The cleaned dataset contains several derived and composite variables (e.g. HHS, FCS, ECFIES) that are not present in the Kobo XLSForm; these were treated as analytically valid indicators.

# 1) Basic counts
cohort_counts <- df %>%
  count(cohort) %>%
  mutate(pct = n / sum(n))

write_csv(cohort_counts, "cohort_counts.csv")

# Keep only variables we need
analyse_df <- df %>%
  transmute(
    cohort = as.factor(cohort),
    governorate = as.factor(governorate),
    sampling_framework = as.factor(sampling_framework),
    head_hh_gender = as.factor(head_hh_gender),
    sum_hh_members = as.numeric(sum_hh_members),
    hhs = as.factor(fsl_hhs_cat),
    fcs = as.numeric(fsl_fcs_score),
    ecfies = as.numeric(ecfies_comp_score)
  )

# 1) Basic counts
cohort_counts <- analyse_df %>%
  count(cohort) %>%
  mutate(pct = n / sum(n))

write_csv(cohort_counts, "cohort_counts.csv")

# 2) Missingness
missingness <- tibble(
  variable = names(analyse_df),
  missing_n = sapply(analyse_df, function(x) sum(is.na(x))),
  missing_pct = missing_n / nrow(analyse_df)
) %>% arrange(desc(missing_pct))

write_csv(missingness, "missingness.csv")

# 3) Categorical comparisons (Chi-square/Cramer's V)
cat_vars <- c("governorate", "sampling_framework", "head_hh_gender", "hhs")

categorical_tests <- map_dfr(cat_vars, function(v) {
  sub <- analyse_df %>% select(cohort, all_of(v)) %>% drop_na()
  tab <- table(sub[[v]], sub$cohort)
  
  chisq_p <- suppressWarnings(chisq.test(tab))$p.value
  cramers_v <- effectsize::cramers_v(tab)$Cramers_v
  
  tibble(
    variable = v,
    test = "Chi-square",
    p_value = chisq_p,
    cramers_v = cramers_v
  )
})

write_csv(categorical_tests, "categorical_tests.csv")

# 4) Continuous comparisons (t-test/Cohen's D)
cont_vars <- c("sum_hh_members", "fcs", "ecfies")
continuous_tests <- map_dfr(cont_vars, function(v) {
  sub <- analyse_df %>% select(cohort, all_of(v)) %>% drop_na()
  
  t_p <- t.test(sub[[v]] ~ sub$cohort)$p.value
  cohens_d <- effectsize::cohens_d(sub[[v]] ~ sub$cohort)$Cohens_d
  
  tibble(
    variable = v,
    test = "t-test",
    p_value = t_p,
    cohens_d = cohens_d
  )
})

write_csv(continuous_tests, "continuous_tests.csv")

# 5) Simple descriptive stats (mean/sd) by cohort
summary_stats <- analyse_df %>%
  group_by(cohort) %>%
  summarise(
    n = n(),
    sum_hh_members_mean = mean(sum_hh_members, na.rm = TRUE),
    sum_hh_members_sd   = sd(sum_hh_members, na.rm = TRUE),
    fcs_mean = mean(fcs, na.rm = TRUE),
    fcs_sd   = sd(fcs, na.rm = TRUE),
    ecfies_mean = mean(ecfies, na.rm = TRUE),
    ecfies_sd   = sd(ecfies, na.rm = TRUE),
    .groups = "drop"
  )

write_csv(summary_stats, "summary_by_cohort.csv")


