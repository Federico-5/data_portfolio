# Are Immigrants Economically Essential? — A Data-Driven Analysis Using CPS Microdata

An econometric study of immigrant vs. native-born labor market outcomes in the United States, using individual-level microdata from the IPUMS Current Population Survey (CPS). Written for ECO B2000 (Statistics and Introduction to Econometrics), Colin Powell School for Civic and Global Leadership, The City College of New York (CUNY), December 2025.

**Team:** Federico Ciandri, Romulo Jimenez, Marwan Kenawy

## Research question

Are immigrants active and economically productive contributors to the U.S. economy, based on their income, employment patterns, industry distribution, and labor supply — and how do these outcomes compare to native-born workers once observable differences are accounted for?

## Data

- **Source:** IPUMS Current Population Survey (CPS) microdata
- **Sample:** working-age adults (25–64) who are in the labor force, employed, and report positive income
- Immigrant status identified via birthplace (`BPL`), nativity (`NATIVITY`), citizenship (`CITIZEN`), and year of immigration (`YRIMMIG`)
- Labor-market variables: employment status (`EMPSTAT`), labor-force participation (`LABFORCE`), occupation (`OCC`), industry (`IND`), usual hours worked (`UHRSWORKT`), weeks worked (`WKSWORK1`), total personal income (`INCTOT`)

## Method

The analysis proceeds in stages, from descriptive statistics to increasingly controlled regressions:

1. **Descriptive statistics & visualization** — weighted income and hours distributions, and industry composition, compared by immigrant status (see `code/part_3_4_5_analysis.R`, Part 3).
2. **Simple regressions** (Part 4) — log weekly earnings regressed on immigrant status alone, then with age, age², gender, and education controls; a separate model estimates returns to years spent in the U.S. among immigrants.
3. **Fixed-effects regressions** (Part 5, via `fixest::feols`) — progressively adding state, then state + industry fixed effects; an interaction model testing whether returns to education differ by immigrant status; robustness checks restricted to full-time workers, split by gender, and split by recent vs. long-term immigrant cohorts.
4. **Returns to experience** (Part 6) — an interaction between immigrant status and work experience to test whether immigrants and natives are rewarded differently for tenure in the labor market.

All regressions are estimated with CPS person weights (`WTFINL`).

## Key findings

- **Labor-force attachment:** immigrants are working-age, employed, and supply nearly as many hours and weeks of work as natives — clearly active labor-market participants, not peripheral workers.
- **Raw earnings gap:** in the simplest specification, immigrants earn roughly 48–50% less than natives.
- **The gap shrinks with controls:** adding age, gender, and education narrows — but does not eliminate — the gap, showing part of the raw difference reflects observable characteristics.
- **The gap flips once location and job are held fixed:** once state, industry, and occupation fixed effects are added, the immigrant coefficient turns slightly *positive* — immigrants earn similar to or slightly more than natives doing comparable work in the same place. This pattern holds up in full-time-only, by-gender, and by-cohort robustness checks.
- **Returns to experience differ:** income rises with experience for both groups, but natives gain more per additional year — immigrants' earnings grow more slowly over time, and the gap widens with experience. This suggests foreign experience may be undervalued, or that immigrants face early-career barriers in the U.S. labor market.

## Conclusion

Much of the raw immigrant–native earnings gap is explained by *where* immigrants live and *which* industries/occupations they work in, rather than lower pay for equal work — once those factors are held constant, immigrant and native workers perform similarly, and often nearly identically, within comparable roles. Slower returns to experience help explain why gaps persist even after controlling for job and location. These results are consistent with the broader academic literature reviewed in the paper (Peri 2016; Lewis & Peri; National Academy of Sciences 2017), which finds small-to-positive average wage effects of immigration on natives and highlights immigrants' role in productivity, task specialization, and long-run fiscal contribution.

## Repository contents

| Path | Description |
|---|---|
| [`report/Are_Immigrants_Economically_Essential.pdf`](report/Are_Immigrants_Economically_Essential.pdf) | Full written paper: introduction, literature review, data, regressions, and conclusion |
| [`code/part_3_4_5_analysis.R`](code/part_3_4_5_analysis.R) | R code for descriptive statistics/graphs (Part 3), simple regressions (Part 4), and fixed-effects regressions (Part 5) |

## Tools

R, dplyr, ggplot2, fixest, scales, IPUMS CPS microdata
