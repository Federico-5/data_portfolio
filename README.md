# Federico Ciandri — Data Analytics Portfolio

Ciao, I'm Federico — a Business Analytics graduate student focused on data-driven decision making. This repository collects academic and independent projects applying statistics, econometrics, and data cleaning/visualization to real-world datasets.

- MS in Business Analytics (Data Analysis), Baruch College – Zicklin School of Business (expected May 2027)
- BA Business Administration, City College of New York, Summa Cum Laude (May 2024)
- Python, R, MySQL, Excel
- Fluent in English, Italian, and Spanish

## Projects

### [NYC Parking Violations Analysis](nyc-parking-violations/)
Python/pandas exploratory analysis of 10,000 NYC parking and camera-issued violations pulled from the NYC Open Data API — cleaning inconsistent categorical data and identifying which violation types, boroughs, and precincts drive citywide enforcement activity.

**Tools:** Python, pandas, matplotlib, REST API integration

### [Are Immigrants Economically Essential? — CPS Microdata Analysis](immigrant-earnings-cps/)
An econometrics research paper (ECO B2000, CCNY) using IPUMS CPS microdata to test whether immigrant and native-born workers differ in income, employment, and labor supply once education, location, industry, and occupation are controlled for — progressing from simple regressions to fixed-effects models.

**Tools:** R, dplyr, ggplot2, fixest (fixed-effects regression)

## Structure
data-portfolio/
├── nyc-parking-violations/
│ ├── notebook/ Jupyter notebook (data pull, cleaning, EDA)
│ ├── data/ raw dataset (CSV)
│ ├── images/ exported charts
│ └── docs/ summary write-up and slide deck
└── immigrant-earnings-cps/
├── report/ full written paper (PDF)
└── code/ R script for regressions and figures


Each project folder has its own README with methodology, findings, and a guide to its contents.
