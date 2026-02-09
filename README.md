# WANP Data Analysis Exercise
This repository contains my submission for the WANP Data Analysis Exercise. Using the **January 2026 remote round** dataset, I assess whether **combining Cohort 1 (initially assessed June 2024)** and **Cohort 2 (initially assessed November 2025)** into a single analytical cohort is a statistically sound decision.

The analysis is intentionally **focused**: I prioritised variables most relevant to **representativeness** (sampling structure / demographics) and a small set of **headline outcomes**.

---

## Data

- Dataset: `Walloland_WANP_clean_data.xlsx`
- Unit of analysis: Household
- Analysis is **unweighted** (no survey weights provided), per instructions.
- Composite indicators are assumed correct, per instructions.

### Sample size by cohort
- **Cohort 1:** 714 households (**38.2%**)
- **Cohort 2:** 1,155 households (**61.8%**)

(From `cohort_counts.csv`.)

---

## Methodology (scoped)

### 1) Data quality check
I reviewed missingness for key analysis variables to understand any limitations in inference.

### 2) Cohort comparability on structural variables (representativeness proxies)
I compared cohorts on variables linked to sampling design and household composition:
- `governorate`
- `sampling_framework` (building/shelter type)
- `head_hh_gender`
- `sum_hh_members` (household size)

Tests used:
- Categorical: **Chi-square** + **Cramér’s V** (effect size)
- Continuous: **Two-sample t-test** + **Cohen’s d** (effect size)

### 3) Cohort comparability on outcomes (headline indicators)
Within time constraints, I compared cohorts on:
- `fcs` (Food Consumption Score)
- `ecfies` (Early Childhood Feeding Insecurity Score)

In addition, the dataset included an `hhs` field treated as categorical in the script outputs (chi-square + Cramér’s V).

---

## Results

### Missingness (key variables)
- `ecfies` has **very high missingness**: **66.1%** missing (1,235 records).
- `hhs` missing: **0.6%** (11)
- `fcs` missing: **0.3%** (5)
- Structural variables (`cohort`, `governorate`, `sampling_framework`, `head_hh_gender`, `sum_hh_members`) have **0% missingness**.

(From `missingness.csv`.)

**Implication:** ECFIES comparisons should be interpreted cautiously due to substantial missing data.

---

### Structural comparability (sampling/design-relevant variables)

| Variable | p-value | Effect size |
|---|---:|---:|
| governorate | 0.722 | Cramér’s V = 0.000 |
| sampling_framework | 0.371 | Cramér’s V = 0.012 |
| head_hh_gender | 0.530 | Cramér’s V = 0.000 |

(From `categorical_tests.csv`.)

**Interpretation:** Cohorts are **highly similar** in governorate distribution, shelter/building type, and head of household gender. Effect sizes are **negligible**, suggesting minimal risk that combining cohorts would distort representativeness along these dimensions.

---

### Household size
- `sum_hh_members` differs significantly by cohort (**p = 1.67e-09**) with **Cohen’s d = 0.31**.

(From `continuous_tests.csv`.)

**Interpretation:** This is a **small-to-moderate** difference in household size between cohorts. It may reflect cohort composition, differential re-contact/attrition, or evolving population context. Because household size is plausibly associated with vulnerability and food security indicators, it is a key factor to acknowledge and adjust for in interpretation.

---

### Outcome indicators

- `fcs`: **no meaningful difference** between cohorts  
  - p = 0.231  
  - Cohen’s d = 0.056 (very small)

- `ecfies`: **no meaningful difference** between cohorts (but high missingness)  
  - p = 0.505  
  - Cohen’s d = -0.054 (very small)  
  - **66% missingness** limits confidence in this comparison

(From `continuous_tests.csv` and `missingness.csv`.)

- `hhs` (as tested in `categorical_tests.csv`):  
  - p = 0.0668  
  - Cramér’s V = 0.0429 (small)

**Interpretation:** The headline outcomes assessed show **no substantive differences** by cohort based on effect sizes. The `hhs` result is borderline on significance but has a **small** effect size. ECFIES results are limited by missingness.

---

## Recommendation

**Recommendation: Combine Cohort 1 and Cohort 2 for January 2026 analysis, with conditions.**

Based on the variables reviewed, cohorts are **structurally comparable** in terms of governorate, shelter type, and head of household gender, and the key food security outcomes assessed do not show meaningful cohort differences. This supports combining cohorts into a single analytical cohort for reporting and inference.

**Conditions / caveats:**
1. **Household size differs (d ≈ 0.31):**  
   - I recommend retaining `cohort` in the dataset and conducting sensitivity checks or stratified summaries for key indicators where household size may confound results.
2. **ECFIES has substantial missingness (66%):**  
   - Any ECFIES-based inference should be clearly caveated; if possible, investigate the cause of missingness and whether it differs by cohort.
3. **Document cohort implications:**  
   - Cohort 1 is longitudinal and may be affected by re-contact consent/attrition; this should be noted as a potential selection bias risk even if observed structural differences are small.

---

## Assumptions

- Population size and composition remain constant (per instructions).
- Internal displacement has not occurred.
- No survey weights available; analysis is **unweighted**.
- Composite indicators are correct (per instructions).

---

## Limitations

- The analysis is intentionally **selective** given time guidance.
- No survey weights prevents a full assessment of population representativeness.
- Potential selection bias due to re-contact consent/attrition (especially for Cohort 1) cannot be directly tested here.
- `ecfies` has very high missingness, limiting confidence in that comparison.
- Some derived/composite variables are not documented in the Kobo tool; per instructions, these were treated as valid indicators.

---

## Reproducibility

Run the R script in RStudio from the repository root:

1. Ensure `Walloland_WANP_clean_data.xlsx` is in the project directory
2. Run the analysis script (e.g., `Analysis.R`)
3. Outputs are saved as CSV files:
   - `cohort_counts.csv`
   - `missingness.csv`
   - `categorical_tests.csv`
   - `continuous_tests.csv`

---

## What I would do with more time
- Investigate **ECFIES missingness** (pattern by cohort/governorate, and whether missing-at-random is plausible).
- Adjust outcome comparisons for household size (and optionally other demographics) using simple regression sensitivity checks.
- Expand comparisons to a broader set of outcome indicators (using the same framework: composition → outcomes → judgement).

