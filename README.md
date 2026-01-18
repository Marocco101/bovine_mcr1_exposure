# The Ecoantibio Paradox: Analysis of Exposure vs. Resistance in French Cattle
### Unintended Consequences of Antibiotic Stewardship in French Livestock

**Author:** Makiko FUJITA-SUZANNE  
**Date:** January 2026

---
## Summary & Key Implications

**Main Objective:** To quantify the relationship between colistin exposure (ALEA) and phenotypic resistance rates (RESAPATH) in the French bovine sector.

### Summary of Findings
* **The Ecoantibio Paradox:** Identified a fundamental shift in resistance dynamics starting around 2017.
* **Correlation Break:** While a strong positive correlation existed prior to 2017 ($r = 0.86, p < 0.001$), this link vanished in the subsequent period ($r = -0.52, p = 0.26$).
* **Usage vs. Persistence:** Colistin resistance has shown a gradual resurgence since 2019 despite historically low antimicrobial exposure.

### Key Implication
These results demonstrate that traditional antimicrobial stewardship focused solely on usage reduction is no longer sufficient. The "paradoxical" persistence suggests that resistance has transitioned to an autonomous phase.

---

## 1. Overview (Executive Summary)

France's "Ecoantibio" plans achieved a historic reduction in veterinary antibiotic consumption. However, epidemiological surveillance reveals a disturbing paradox in the bovine sector: **Since 2017, Colistin resistance in *E. coli* has stabilized and persisted, despite negligible colistin exposure.**

This project investigates the hypothesis that the resistance mechanism has shifted from a **"Plasmid-mediated, Co-selection driven"** state to a **"Chromosomally integrated, Autonomous"** state. We term this phenomenon the **"Genetic Trap."**

---

## 2. Statistical Analysis & Key Findings

I performed a segmented longitudinal analysis (2006–2024) using R. The results confirm a statistically significant **Structural Break** in resistance dynamics around 2017.

### Part 1: The Decoupling of Co-selection
I tested the relationship between **Colistin Resistance** and its historical driver, **TMP-SMX Resistance** (the co-selecting agent).

| Period | N | Correlation ($r$) | P-value | Interpretation |
| :--- | :---: | :---: | :---: | :--- |
| **Phase I (2006-2016)** | 11 | **0.848** | **< 0.001** (***) | **Strong Coupling.** Resistance was driven by plasmid-mediated co-selection. |
| **Phase II (2017-2024)** | 8 | **0.505** | 0.202 (n.s.) | **Decoupling.** The link is broken. Resistance is now autonomous. |

* **Structural Break Test:** An Interaction Model (`Colistin ~ Mix * Period`) confirmed that the change in relationship is highly significant (**$p < 0.001$**).

### Part 2: The Limits of Stewardship (Exposure vs. Resistance)
I also analyzed the direct impact of **Colistin Exposure (ALEA)** on resistance rates.

| Period | N | Correlation ($r$) | P-value | Interpretation |
| :--- | :---: | :---: | :---: | :--- |
| **Overall (2006-2020)** | 15 | **0.923** | **< 0.001** (***) | **High Correlation.** Historically, reducing usage reduced resistance. |
| **Phase I (2006-2016)** | 11 | **0.864** | **< 0.001** (***) | **Responsive.** Policy interventions worked effectively. |
| **Phase II (2017-2020)** | 4 | **0.735** | **0.265 (n.s.)** | **Stagnation.** Despite significantly low usage, resistance is no longer significantly declining. |

**Insight:** In Phase II, the correlation loses statistical significance. This suggests we have hit a "floor" where further reductions in antibiotic usage yield diminishing returns in reducing resistance.

---

## 3. Visual Evidence

The figure below visualizes the **Decoupling Event (2017)**.
* **Top Panel:** Colistin resistance (Red) detaches from the co-selecting agent trend (Yellow) after 2017.
* **Bottom Panel:** Colistin exposure (Red) remains historically low, yet resistance persists.

![Figure 1: Decoupling Analysis](Figure1_Robust.jpg)

---

## 4. Biological Hypothesis: The "Genetic Trap"

Why does resistance persist without selection pressure?  Statistical data from my preliminary analysis supports the following biological model:

1.  **The Plasmid Era (Phase I):**
    * The *mcr-1* gene resided on unstable plasmids (e.g., IncHI2).
    * It was maintained by the "co-selection" pressure of TMP-SMX (hence the strong correlation $r=0.85$).
    * *Result:* Reducing usage worked effectively. Success of Ecoantibio Plan. 

2.  **The Chromosomal Era (Phase II):**
    * Around 2017, *mcr-1* likely translocated to the **chromosome** via the *Tn6330* transposon.
    * Once integrated, the biological cost of maintaining resistance becomes negligible.
    * *Result:* Resistance becomes "hard-wired" and vertically transmitted. It no longer responds to antibiotic stewardship (Decoupling).

**Next Step:** My PhD project will validate this hypothesis via **Whole Genome Sequencing (WGS)** to confirm the physical location of *mcr-1* in Phase II isolates.

---

