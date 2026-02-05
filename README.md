# WANP Data Analysis Exercise

This repository contains my submission for the WANP Data Analysis Exercise. 
Using the June/Nov 2026 Walloland Assessment for Need Priorities (WANP) dataset, I assess whether combining Cohort One (June 2024) and Cohort Two (Nov 2025) into a single analytical cohort is a statistically sound decision.

---

## Objective

To assess whether Cohort One and Cohort Two can be combined for analysis without introducing bias or undermining representativeness.

---

## Data

- Dataset: `Walloland_WANP_clean_data.xlsx` (June/Nov 2026 WANP dataset)
- Unit of analysis: Household
- Both cohorts were interviewed using the same questionnaire
- Analysis is unweighted (no survey weights available)
- Population size and composition remain constant:
  - No net migration and Mortality rate = fertility rate
  - Internal displacement has occurred.
  
---

## Analytical Approach

The analysis was conducted in three steps.

### 1. Cohort comparability (structure)
I compared Cohort One and Cohort Two on key structural variables that relate to the original sampling design and potential sources of bias:

- Governorate  
- Description of shelter/building type
- Head of household gender  
- Total household size  

These variables were selected because meaningful differences could affect the representativeness of a combined sample.

### 2. Outcome comparability
I compared cohorts on a  set of outcome indicators:

- Household Hunger Score (HHS)  
- Food Consumption Score (FCS)  
- Early Childhood Feeding Insecurity Score (ECFIES)  

Comparisons focused on distributional differences and practical magnitude rather than statistical significance alone.

### 3. Interpretation
Results were interpreted in light of:
- The longitudinal nature of Cohort One  
- Potential attrition and re-contact consent bias  
- Differences in baseline timing between cohorts  
- The absence of survey weights  

---

## Methods

- Descriptive statistics  
- Chi-square tests for categorical variables  
- t-tests for continuous indicators  

---

## Summary of Findings

-Structural characteristics were comparable between cohorts, with no significant differences observed
- Outcome indicators differed significantly between cohorts for Household Hunger Scores (p = 0.01), but not for other indicators such as Food Security Score and Early Childhood Feeding Insecurity Score
- Because structural characteristics were comparable between cohorts, the divergence in Hunger Scores, despite comparable Food Security and Early Childhood Feeding Insecurity Scores, suggests that differences between cohorts may reflect more acute or episodic experiences of hunger rather than broader disparities in food access or feeding practices.


---

## Recommendation

**Recommendation:**  
Combine with conditions: Yes, they can be combined for analysis, but not as a single undifferentiated sample. Pooling is reasonable since cohort are explicitly accounted for, otherwise you risk bias, especially for Hunger Scores.

**Justification:**  
Cohorts One and Two can be pooled for analysis given comparable structural characteristics and similar food security indicators; all models adjusted for cohort to account for differences in recruitment period and data collection modality, particularly for Hunger Scores. Explicitly acknowledging cohort-related limitations.Report key indicators both for the combined sample and by cohort as a sensitivity check.

---

## Assumptions

- Population size and composition are constant over time  
- Internal displacement has occurred  
- No survey weights are available; analysis is unweighted  
- Composite indicators are valid  

---

## Limitations

- No weighting limits conclusions about population-level representativeness  
- Potential selection bias due to re-contact consent and attrition in Cohort One  

---

## Reproducibility

1. Open RStudio  
2. Set the working directory
3. Install required packages (`tidyverse`, `readxl`, etc.)  
4. Run `analysis.R`

