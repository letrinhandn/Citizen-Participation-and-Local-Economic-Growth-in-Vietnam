# Citizen Participation and Local Economic Growth in Vietnam  
**Replication materials for the LSE GV499 Dissertation (2025)**  
**Author:** Le Tri Nhan  

---

## 📘 Overview
This project explores how **citizen participation** affects **local economic growth** in Vietnam, focusing on the **institutional mediation channels** — especially governance quality, regulatory efficiency, and workforce support.

Data cover **63 provinces (2012–2019)**, using **panel data** and **Structural Equation Modeling (SEM)** to test both direct and indirect effects of participation on economic outcomes.

---

## 🧠 Abstract
Citizen participation is key to local development.  
Using PAPI (participation indices) and PCI (governance indices), this research shows that **citizen engagement—especially voluntary contributions—improves institutional quality**, which then leads to **higher provincial economic growth**.  

In short:  
➡️ Participation → Better institutions → Faster growth.

---

## ⚙️ Methods and Tools
- **Software:** R, Python, Stata  
- **Key R packages:** `lavaan`, `tidyverse`, `ggplot2`, `stargazer`, `semPlot`  
- **Main steps:**
  1. Clean and merge panel data (2012–2019)  
  2. Run descriptive statistics  
  3. Estimate SEM with indirect effects  
  4. Visualize results (tables, path diagrams)

---

## 📊 Data
- **Source:** Vietnam’s PAPI, PCI, and GSO statistics (confidential – not shared)  
- **Level:** 63 provinces × 8 years (2012–2019)  

| Variable | Description |
|-----------|--------------|
| `CP1–CP4` | PAPI citizen participation sub-indices |
| `PCI4` | Time costs & regulatory compliance |
| `PCI8` | Labour & training quality |
| `GRDPperCap` | Provincial GDP per capita (log) |
| `Avg_Income` | Average monthly income |

All variables are standardized and lagged 1 year where applicable.

---

## 🧩 Key Findings
- **Indirect-only mediation:** Participation affects growth through institutions, not directly.  
- **Most influential path:**  
  `CP4 (Voluntary contributions) → PCI8 (Labour & training) → GRDP per capita`  
- **Fit statistics:** Excellent model fit (CFI ≈ 1.00, RMSEA ≈ 0.00)  
- **Policy insight:**  
  Grassroots engagement works best when paired with transparent and efficient local governance.

---

## 🚀 How to Reproduce
To replicate the analysis, follow these steps:

**Step 1. Install dependencies**

Run the following in R:
- `install.packages("lavaan")`  
- `install.packages("tidyverse")`  
- `install.packages("ggplot2")`  
- `install.packages("semPlot")`

**Step 2. Prepare data**  
- Place your cleaned or raw data files inside the `data/` folder.  
- Make sure variables follow the structure described above (PAPI, PCI, GRDP, etc.).

**Step 3. Run scripts in order**
1. `01_data_cleaning.R` – Clean and merge panel data  
2. `02_descriptive_stats.R` – Generate descriptive tables and plots  
3. `03_SEM_model.R` – Estimate the SEM model and compute indirect effects  
4. `04_visualizations.py` – Produce visual outputs and figures  

**Step 4. Review results**  
- Outputs (tables, model summaries, and plots) will be saved automatically to the `output/` directory.  
- You can open figures in `/output/figures/` and tables in `/output/tables/`.

✅ *Tip:* Use **RStudio** or **VSCode** for the R scripts and ensure your working directory is set to the project root.

---

## 🧭 Notes
- Model uses **lagged variables** and **bootstrapped indirect effects**.  
- Data are **not public** — replicate only with authorized access.  
- The analysis focuses on **long-term relationships**, not short-term causality.

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
- ✉️ **Email:** letrinhan123@gmail.com  
- 🔗 **LinkedIn:** [linkedin.com/in/letrinhan](https://linkedin.com/in/letrinhan)  
- 💻 **GitHub:** [github.com/letrinhandn](https://github.com/letrinhandn)

   
