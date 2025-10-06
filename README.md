# Citizen Participation and Local Economic Growth in Vietnam  
**Replication materials for the LSE GV499 Dissertation (2025)**  
**Author:** Le Tri Nhan  

---

## 📘 Overview
This repository provides replication materials and analysis code for the dissertation:  
> *"Citizen Participation and Local Economic Growth in Vietnam: Evidence from Institutional Mediation Channels."*  

The project investigates how **citizen participation** impacts **provincial economic growth** in Vietnam,  
emphasizing the **mediating role of institutional quality** — particularly regulatory efficiency and labour training capacity.  

Data include **63 provinces from 2012–2019** and the model uses **Structural Equation Modeling (SEM)** to test both direct and indirect effects.

---

## 🧠 Abstract
Citizen participation enhances local governance and can indirectly promote economic growth.  
By combining **PAPI (citizen participation)** and **PCI (governance quality)** indicators within a panel SEM framework,  
the study finds that **voluntary civic engagement (CP4)** strengthens institutional capacity (PCI4, PCI8),  
which then drives higher provincial **GDP per capita**.

**In short:**  
➡️ Participation → Better Institutions → Faster Growth.

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

