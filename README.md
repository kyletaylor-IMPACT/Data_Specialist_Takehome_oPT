# WANP Data Analysis Exercise

This repository contains my submission for the WANP Data Analysis Exercise. Using the **January 2026 remote round** dataset, I assess whether **combining Cohort 1 (initially assessed June 2024)** and **Cohort 2 (initially assessed November 2025)** into a single analytical cohort is a statistically sound decision.

The analysis is intentionally **focused**, in line with the guidance for a non-exhaustive exercise. I prioritised variables most relevant to **sample representativeness** (sampling structure and basic demographics) and a small set of **headline food security outcomes** used for operational decision-making.

---

## Data

- Dataset: `Walloland_WANP_clean_data.xlsx`
- Unit of analysis: Household
- Analysis is **unweighted** (no survey weights provided), per instructions.
- Composite and derived indicators are assumed correct, per instructions.

### Sample size by cohort
- **Cohort 1:** 714 households (**38.2%**)
- **Cohort 2:** 1,155 households (**61.8%**)

---

## Methodology (scoped)

### 1) Data quality and missingness
I reviewed missingness for key structural and outcome variables to identify potential limitations for inference.

### 2) Cohort comparability on structural variables
To assess whether the combined sample remains representative, I compared cohorts on variables closely linked to the original sampling design:

- `governorate`
- `sampling_framework` (building/shelter type)
- `head_hh_gender`
- `sum_hh_members` (household size)

Tests used:
- **Categorical:** Chi-square tests with **Cramér’s V**
- **Continuous:** Two-sample t-tests with **Cohen’s d**

### 3) Cohort comparability on outcome indicators
Within time constraints, I compared cohorts on:
- `fcs` (Food Consumption Score)
- `ecfies` (Early Childhood Feeding Insecurity Score)

The dataset also includes an `hhs` variable, analysed as categorical using chi-square tests.

### 4) Sensitivity checks
To test the robustness of results:
- I investigated **ECFIES missingness patterns** by cohort and context
- I estimated **adjusted regression models** for outcomes, controlling for household size and key structural variables

---

## Results

### Missingness

- `ecfies` shows **very high missingness**: **66.1%**
- `hhs` missing: **0.6%**
- `fcs` missing: **0.3%**
- Structural variables have **no missingness**

Given the high proportion of missing ECFIES values, any inference using this indicator must be interpreted cautiously.

#### ECFIES missingness patterns
ECFIES missingness was examined by cohort and governorate, and through a logistic regression with missingness as the outcome.

Key findings:
- Missingness rates are high in both cohorts, with **no strong independent association with cohort membership**
- Missingness is associated with **household size** and some **contextual characteristics** (e.g. shelter type)

These results suggest that ECFIES missingness is **not completely random**, but is driven more by household- and context-level factors than by cohort composition alone.

---

### Structural comparability

Cohorts are highly similar across key sampling and demographic variables:

| Variable | p-value | Effect size |
|--------|--------:|-------------|
| governorate | 0.722 | Cramér’s V = 0.000 |
| sampling_framework | 0.371 | Cramér’s V = 0.012 |
| head_hh_gender | 0.530 | Cramér’s V = 0.000 |

Household size differs by cohort (**p < 0.001**, **Cohen’s d = 0.31**), representing a small-to-moderate difference that may plausibly influence vulnerability indicators.

---

### Outcome indicators (unadjusted)

- **FCS:** no meaningful difference (d = 0.056)
- **ECFIES:** no meaningful difference (d = −0.054), but interpretation limited by missingness
- **HHS (categorical):** borderline significance (p = 0.067) with small effect size (V = 0.043)

---

### Sensitivity checks: adjusted outcome comparisons

To assess whether outcome similarities persisted after accounting for compositional differences, I estimated linear regression models for FCS and ECFIES adjusting for:

- Household size
- Governorate
- Shelter type
- Head of household gender

**FCS:**  
Cohort membership was **not significantly associated** with FCS after adjustment, indicating that the absence of cohort differences is robust to basic compositional controls.

**ECFIES:**  
Similarly, no statistically meaningful cohort effect was observed after adjustment. However, high missingness substantially limits confidence in these estimates.

---

## Recommendation

**Recommendation: Combine Cohort 1 and Cohort 2 for January 2026 analysis, with explicit caveats.**

The analysis indicates that Cohort 1 and Cohort 2 are **structurally comparable** and that key outcome indicators do not differ meaningfully between cohorts, both before and after adjustment for household size and contextual variables.

### Conditions for combination

1. **Household size differences:**  
   Retain `cohort` in the dataset and conduct sensitivity checks where household size may confound results.

2. **High ECFIES missingness:**  
   Clearly caveat any ECFIES-based findings and avoid strong conclusions without further investigation of missingness mechanisms.

3. **Longitudinal considerations:**  
   Acknowledge potential selection and attrition bias in Cohort 1 due to re-contact consent dynamics.

---

## Assumptions

- Population size and composition remain constant
- Internal displacement has occurred
- No survey weights available
- Composite indicators are valid

---

## Limitations

- Selective scope consistent with time guidance
- No weighting limits population inference
- Missingness in ECFIES constrains interpretation
- Attrition and consent bias cannot be fully assessed

---

## Reproducibility

Run `Analysis.R` in RStudio from the repository root.  
Outputs are written as CSV files documenting all comparisons and sensitivity checks.


