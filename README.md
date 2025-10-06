# Citizen Participation and Local Economic Growth in Vietnam  
**Replication materials for the LSE GV499 Dissertation (2025)**  
**Author:** Le Tri Nhan  

---

## 📘 Overview
This repository contains replication materials and analytical code for the dissertation:  
> *"Citizen Participation and Local Economic Growth in Vietnam: Evidence from Institutional Mediation Channels."*  

The dissertation investigates how citizen participation influences provincial-level economic growth in Vietnam, focusing on the **institutional mediation mechanisms** that shape this relationship.  
Using panel data from **63 provinces during 2012–2019**, the study integrates indicators from the **Provincial Governance and Public Administration Performance Index (PAPI)** and the **Provincial Competitiveness Index (PCI)** within a **Structural Equation Modeling (SEM)** framework.  
This approach enables the identification of both direct and indirect causal pathways between civic engagement, institutional performance, and economic outcomes.

---

## 🧠 Abstract
This study examines the relationship between citizen participation, institutional quality, and local economic growth in Vietnam.  
The empirical findings demonstrate that **citizen participation affects economic performance primarily through institutional mediation channels**, rather than direct economic mechanisms.  
Among the different forms of participation, **voluntary and collaborative engagement (CP4)** exerts the strongest positive indirect influence by enhancing **administrative efficiency (PCI4)** and **labour and training quality (PCI8)**.  
Conversely, **complaint-oriented participation (CP3)** is associated with negative indirect effects through institutional inefficiency.  
These results highlight that **effective and responsive local governance** is the critical mechanism through which civic engagement translates into sustainable provincial economic development.

---

## ⚙️ Methods and Tools
- **Software:** R (main), Python (optional), Stata (for reference)
- **Key Packages:** `lavaan`, `tidyverse`, `ggplot2`, `semPlot`, `car`, `Hmisc`, `openxlsx`
- **Techniques:**  
  - Panel SEM (2012–2019)  
  - Bootstrapped indirect effects  
  - Robustness tests (outlier trimming)  
  - Case study comparisons (Quang Ninh vs Dong Thap)

---

## 📊 Data
- **File:** `vietnam_provincial_panel_2012_2019.xlsx`  
- **Source:** Provincial-level indicators from Vietnam’s PAPI, PCI, and GSO datasets (confidential)  
- **Level:** 63 provinces × 8 years (2012–2019)  

| Variable | Description |
|-----------|--------------|
| `Province` | Province name |
| `Year` | Year (2012–2019) |
| `CP1–CP4` | PAPI citizen participation subindices |
| `PCI4` | Time costs & regulatory compliance |
| `PCI8` | Labour & training quality |
| `GRDPperCap2010` | Provincial GDP per capita (2010 constant prices) |
| `Avg_Income` | Average monthly income (VND) |

All variables are standardized and lagged by one year in the analysis.

---

## 📂 Repository Structure
```
Citizen-Participation-VN/
├── code/
│   └── main_SEM_analysis.R              # main SEM pipeline (full model + robustness)
├── data/
│   └── vietnam_provincial_panel_2012_2019.xlsx   # aggregated dataset (not public)
├── output/
│   ├── tables/                         # regression and SEM outputs
│   └── figures/                        # diagrams and plots
└── README.md
```
---

## 🚀 How to Reproduce
**Step 1.** Open RStudio and set the working directory to the repository root.  

**Step 2.** Ensure the data file is located in `data/vietnam_provincial_panel_2012_2019.xlsx`.  

**Step 3.** Run the analysis by executing: source("code/main_SEM_analysis.R")

**Step 4.** Results will be saved automatically to the output/ folder:

- output/tables/ → Descriptive stats, SEM results, bootstrap & robustness tables

- output/figures/ → Path diagrams and provincial comparisons

✅ Tip: The script will automatically create lag variables and perform all diagnostics.

---

## 🧩 Key Outputs
- **Main SEM results:** `SEM_main_results.xlsx`  
- **Bootstrap robustness (1,000 reps):** `SEM_bootstrap_results.xlsx`  
- **Trimmed outlier robustness:** `SEM_trimmed_results.xlsx`  
- **Fit indices summary:** `SEM_fit_indices.xlsx`  
- **Case study charts:** Quang Ninh vs Dong Thap (`CP4`, `PCI4`, `PCI8`, `GRDP`)

---

## 🧭 Notes
- The model uses **lagged predictors** and **bootstrapped indirect effects**.  
- Data are **confidential** — replication requires authorized access.  
- The focus is on **long-term institutional mediation**, not short-term shocks.

---

## 📚 Citation
> Le Tri Nhan (2025). *Citizen Participation and Local Economic Growth in Vietnam: Evidence from Institutional Mediation Channels.*  
> London School of Economics, GV499 Dissertation.

---

## 🔏 License
**© 2025 Le Tri Nhan. All Rights Reserved.**  
Use or modification requires written permission.  
Academic citation is encouraged.

---

## 📬 Contact
- ✉️ **Email:** [letrinhan123@gmail.com](mailto:letrinhan123@gmail.com)  
- 🔗 **LinkedIn:** [linkedin.com/in/letrinhan](https://linkedin.com/in/letrinhan)  
- 💻 **GitHub:** [github.com/letrinhandn](https://github.com/letrinhandn)

