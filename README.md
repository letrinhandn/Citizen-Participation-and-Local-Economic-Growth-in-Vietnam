# Citizen Participation and Local Economic Growth in Vietnam

Replication materials and data analysis for  
*“Citizen Participation and Local Economic Growth in Vietnam: Evidence from Institutional Mediation Channels”*  
(London School of Economics – GV499 Dissertation, 2025)

---

## 📄 Overview
This repository contains replication code, analytical scripts, and documentation for the dissertation exploring how **citizen participation** influences **local economic growth** in Vietnam through **institutional mediation channels**.

The study employs panel data (2012–2019) and applies **Structural Equation Modeling (SEM)** to assess causal relationships between governance quality, citizen engagement, and economic performance.

---

## 🧠 Abstract
Citizen participation is a critical component of effective governance and local development.  
This research investigates how different forms of civic engagement impact provincial-level economic growth in Vietnam, emphasizing the mediating role of institutional quality.  
Using panel data from 63 provinces between 2012 and 2019, the study integrates **governance indicators** (PCI indices) into a **SEM framework** to identify both direct and indirect effects of participation.  
Findings suggest that citizen participation positively affects economic growth, both directly and indirectly through institutional efficiency, transparency, and business support capacity.

---

## 🧰 Tools and Methods
- **Software:** R, Python, STATA  
- **Key Packages:** `lavaan`, `tidyverse`, `ggplot2`, `stargazer`, `semPlot`  
- **Techniques:** Data cleaning, descriptive statistics, SEM modeling, regression diagnostics, robustness checks, and data visualization  
- **Data:** Provincial-level panel data from the Vietnam Provincial Competitiveness Index (PCI), 2012–2019  

---

## 📂 Repository Structure
/code – R, Python, and STATA scripts
/data – (not included; confidential dataset)
/output – model results, figures, and tables
/docs – dissertation and supplementary materials

---

## 📊 Example Workflow
1. Load data and perform cleaning (`code/01_data_cleaning.R`)
2. Conduct descriptive and correlation analysis (`code/02_descriptive_stats.R`)
3. Estimate SEM models (`code/03_SEM_model.R`)
4. Generate tables and figures (`code/04_visualizations.py`)

All scripts are modular and reproducible within RStudio or STATA environments.

---

## 🧩 Methodological Notes
- **Dependent Variable:** Provincial GDP per capita (log-transformed)  
- **Mediating Variables:** PCI indicators on institutional quality (entry costs, transparency, labor and training)  
- **Independent Variable:** Citizen participation index  
- **Controls:** Infrastructure, education, FDI inflows, and fiscal expenditure  
- **Model:** Structural Equation Modeling (SEM) with bootstrapped indirect effects

---

## 📘 Citation
If you reference or build upon this work, please cite as:

> Le Tri Nhan (2025). *Citizen Participation and Local Economic Growth in Vietnam: Evidence from Institutional Mediation Channels.*  
> London School of Economics, GV499 Dissertation.

---

## 📄 License
**Academic Copyright License (All Rights Reserved)**  
© 2025 Nhan Le Tri.  
This work and all associated materials are protected by copyright.  
No portion may be copied, distributed, or modified without explicit written permission from the author.  
Brief quotations and academic citations are permitted with proper acknowledgment.

---

## 📬 Contact
**Author:** Le Tri Nhan  
- ✉️ Email: letrinhan123@gmail.com
- 🔗 LinkedIn: [linkedin.com/in/letrinhan](https://www.linkedin.com/in/letrinhan)  
- 💻 GitHub: [github.com/letrinhandn](https://github.com/letrinhandn)

---

📘 *This repository follows the academic integrity standards of the London School of Economics and complies with research data protection and intellectual property regulations.*
