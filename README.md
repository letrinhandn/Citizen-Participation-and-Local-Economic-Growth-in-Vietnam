# Citizen Participation and Local Economic Growth in Vietnam

Replication materials for the LSE GV499 Dissertation (2025).

> Le Tri Nhan. *Citizen Participation and Local Economic Growth in Vietnam: Evidence from Institutional Mediation Channels.* London School of Economics, GV499 Dissertation, 2025.

---

## Abstract

This study examines how citizen participation shapes provincial-level economic growth in Vietnam, with attention to the institutional channels through which this relationship operates. Using panel data from 63 provinces (2012–2019) and indicators drawn from the Provincial Governance and Public Administration Performance Index (PAPI) and the Provincial Competitiveness Index (PCI), the analysis employs a Structural Equation Modelling (SEM) framework with one-year lagged predictors and bootstrapped indirect effects.

The central finding is that citizen participation affects economic performance primarily through institutional mediation rather than through direct mechanisms. Voluntary and collaborative engagement (CP4) exerts the strongest positive indirect influence by improving administrative efficiency (PCI4) and labour and training quality (PCI8). Complaint-oriented participation (CP3) is associated with negative indirect effects, consistent with institutional friction. These results indicate that the quality and responsiveness of local governance is the critical mediating mechanism.

---

## Data

| File | Description |
|---|---|
| `data/vietnam_provincial_panel_2012_2019.xlsx` | Provincial panel dataset, 63 provinces x 2012–2019 |

**Source:** Vietnam PAPI, PCI, and General Statistics Office (GSO). Data are not publicly redistributable; replication requires authorised access.

| Variable | Description |
|---|---|
| `CP1`–`CP4` | PAPI citizen participation subindices |
| `PCI4` | Time costs and regulatory compliance (PCI) |
| `PCI8` | Labour and training quality (PCI) |
| `GRDPperCap2010` | Provincial GRDP per capita, 2010 constant prices |
| `Avg_Income` | Average monthly household income (VND) |

All predictors are lagged one year in the model.

---

## Methods

- **Estimator:** SEM via `lavaan`, MLR with full-information maximum likelihood (FIML) for missing data
- **Cluster:** Province ID (robust standard errors)
- **Indirect effects:** Bootstrapped (1,000 replications, percentile CI)
- **Robustness checks:** Exclusion of top-5% provinces by mean GRDP; year fixed effects via dummy augmentation
- **Case study:** Quang Ninh vs. Dong Thap (longitudinal comparison on CP4, PCI4, PCI8, GRDP)

**R packages:** `lavaan`, `semPlot`, `tidyverse`, `ggplot2`, `car`, `Hmisc`, `openxlsx`, `fixest`, `patchwork`

---

## Repository Structure

```
├── code/
│   └── main_SEM_analysis.R     # Full pipeline: data prep, diagnostics, SEM, robustness
├── data/
│   └── vietnam_provincial_panel_2012_2019.xlsx
└── output/
    ├── tables/                  # Excel: descriptives, VIF, correlation, SEM estimates, fit indices
    └── figures/                 # PNG: distributions, linearity, path diagram, case study
```

---

## Reproduction

Set the working directory to the repository root in RStudio. Verify that the data file is at `data/vietnam_provincial_panel_2012_2019.xlsx`, then run:

```r
source("code/main_SEM_analysis.R")
```

The script creates `output/tables/` and `output/figures/` if they do not exist, writes all results to those directories, and exits with a completion message.

---

## Output Files

| File | Content |
|---|---|
| `01_descriptive_statistics.xlsx` | Means, SDs, min/max for all model variables |
| `02_missing_data.xlsx` | Missing data percentages |
| `03_vif_diagnostics.xlsx` | VIF for multicollinearity check |
| `04_correlation_matrix.xlsx` | Pearson correlation matrix with significance stars |
| `05_sem_main_estimates.xlsx` | Main SEM parameter estimates (standardised) |
| `06_model_fit.xlsx` | CFI, TLI, RMSEA, SRMR fit indices |
| `07_bootstrap_estimates.xlsx` | Bootstrap indirect effects (1,000 reps) |
| `08_trimmed_estimates.xlsx` | Estimates excluding top-5% GRDP provinces |
| `09_year_fe_estimates.xlsx` | Estimates with year dummy controls |
| `10_indirect_effects.xlsx` | Summary table of indirect effects by CP variable |

---

## License

All rights reserved. Academic citation is permitted. Redistribution or modification requires written permission from the author.

**Contact:** letrinhan123@gmail.com
