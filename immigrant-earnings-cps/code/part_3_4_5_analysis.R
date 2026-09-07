############################################################
# ECONOMETRICS FINAL PROJECT — PARTS 3, 4, 5
############################################################

library(dplyr)
library(ggplot2)
library(scales)
library(fixest)

############################################################
# PART 3 — SUMMARY STATISTICS AND GRAPHS
############################################################

cps3 <- cps_clean5 %>%
  mutate(
    earnweek = if ("EARNWEEK" %in% names(.)) EARNWEEK else earnweek,
    log_earn = log(earnweek),
    AGE2 = AGE^2,
    immigrant = as.factor(immigrant)
  )

cps3_earn <- cps3 %>%
  filter(!is.na(earnweek), earnweek > 0)

earn_cap <- quantile(cps3_earn$earnweek, 0.99, na.rm = TRUE)

cps3_earn <- cps3_earn %>%
  mutate(earnweek_cap = pmin(earnweek, earn_cap))

cps3_hours <- cps3 %>%
  filter(!is.na(UHRSWORKT), UHRSWORKT >= 1, UHRSWORKT <= 99)

tab1 <- cps3_earn %>%
  group_by(immigrant) %>%
  summarise(
    n = sum(!is.na(earnweek_cap)),
    mean_weekly_earn = weighted.mean(earnweek_cap, WTFINL, na.rm = TRUE),
    sd_weekly_earn = sqrt(
      weighted.mean(
        (earnweek_cap - weighted.mean(earnweek_cap, WTFINL, na.rm = TRUE))^2,
        WTFINL, na.rm = TRUE
      )
    ),
    min_weekly_earn = min(earnweek_cap, na.rm = TRUE),
    max_weekly_earn = max(earnweek_cap, na.rm = TRUE),
    mean_age = weighted.mean(AGE, WTFINL, na.rm = TRUE),
    mean_educ = weighted.mean(EDUC, WTFINL, na.rm = TRUE),
    .groups = "drop"
  )

tab1_hours <- cps3_hours %>%
  group_by(immigrant) %>%
  summarise(
    mean_hours = weighted.mean(UHRSWORKT, WTFINL, na.rm = TRUE),
    sd_hours = sqrt(
      weighted.mean(
        (UHRSWORKT - weighted.mean(UHRSWORKT, WTFINL, na.rm = TRUE))^2,
        WTFINL, na.rm = TRUE
      )
    ),
    .groups = "drop"
  )

tab1_final <- tab1 %>%
  left_join(tab1_hours, by = "immigrant")

print(tab1_final)

ggplot(cps3_earn, aes(x = earnweek_cap, weight = WTFINL, fill = immigrant)) +
  geom_histogram(aes(y = after_stat(count / sum(count))), bins = 12, color = "white") +
  scale_y_continuous(labels = percent_format()) +
  scale_x_log10(labels = dollar_format()) +
  facet_wrap(~ immigrant, ncol = 1) +
  labs(
    title = "Figure 1. Income Distribution by Immigrant Status",
    x = "Weekly earnings (log scale)",
    y = "Percentage of workers",
    fill = NULL
  ) +
  theme_minimal()

ggplot(cps3_hours, aes(x = UHRSWORKT, weight = WTFINL, color = immigrant)) +
  geom_density(linewidth = 1.1) +
  scale_y_continuous(labels = percent_format()) +
  labs(
    title = "Figure 2. Weekly Hours Worked: Immigrants vs. Natives",
    x = "Usual weekly hours",
    y = "Percentage of workers",
    color = "Status"
  ) +
  theme_minimal()

ind_shares <- cps3 %>%
  filter(!is.na(IND)) %>%
  group_by(immigrant, IND) %>%
  summarise(w = sum(WTFINL, na.rm = TRUE), .groups = "drop") %>%
  group_by(immigrant) %>%
  mutate(share = w / sum(w)) %>%
  ungroup()

top_ind <- ind_shares %>%
  group_by(IND) %>%
  summarise(total_share = sum(share), .groups = "drop") %>%
  arrange(desc(total_share)) %>%
  slice(1:15) %>%
  pull(IND)

ggplot(
  ind_shares %>% filter(IND %in% top_ind),
  aes(x = share, y = reorder(as.factor(IND), share), fill = immigrant)
) +
  geom_col(position = "dodge") +
  scale_x_continuous(labels = percent_format()) +
  labs(
    title = "Figure 3. Industry Composition by Nativity",
    x = "Percent of workers",
    y = "Industry (IND code)",
    fill = "Immigrant status"
  ) +
  theme_minimal()

############################################################
# PART 4 — SIMPLE REGRESSIONS
############################################################

cps4 <- cps3 %>%
  filter(!is.na(earnweek), earnweek > 0)

m4_1 <- lm(log_earn ~ immigrant, data = cps4, weights = WTFINL)
m4_2 <- lm(log_earn ~ immigrant + AGE + AGE2 + FEMALE + EDUC, data = cps4, weights = WTFINL)

cps4_imm <- cps4 %>%
  filter(immigrant == "Immigrant") %>%
  mutate(years_us = YEAR - YRIMMIG) %>%
  filter(!is.na(years_us), years_us >= 0)

m4_3 <- lm(log_earn ~ years_us + AGE + AGE2 + FEMALE + EDUC,
           data = cps4_imm, weights = WTFINL)

summary(m4_1)
summary(m4_2)
summary(m4_3)

############################################################
# PART 5 — COMPLEX REGRESSIONS
############################################################

m5_1_state <- feols(
  log_earn ~ i(immigrant, ref = "Immigrant") + AGE + I(AGE^2) + FEMALE + EDUC | STATEFIP,
  data = cps4,
  weights = ~WTFINL
)

m5_2_state_ind <- feols(
  log_earn ~ i(immigrant, ref = "Immigrant") + AGE + I(AGE^2) + FEMALE + EDUC | STATEFIP + IND,
  data = cps4,
  weights = ~WTFINL
)

m5_3_interact <- feols(
  log_earn ~ i(immigrant, ref = "Immigrant") * EDUC + AGE + I(AGE^2) + FEMALE | STATEFIP,
  data = cps4,
  weights = ~WTFINL
)

cps5_fulltime <- cps4 %>%
  filter(!is.na(UHRSWORKT), UHRSWORKT >= 35, UHRSWORKT <= 99)

m5_4_fulltime <- feols(
  log_earn ~ i(immigrant, ref = "Immigrant") + AGE + I(AGE^2) + FEMALE + EDUC | STATEFIP,
  data = cps5_fulltime,
  weights = ~WTFINL
)

cps_men <- cps4 %>% filter(FEMALE == 0)
cps_women <- cps4 %>% filter(FEMALE == 1)

m5_5_men <- feols(
  log_earn ~ i(immigrant, ref = "Immigrant") + AGE + I(AGE^2) + EDUC | STATEFIP + IND + OCC,
  data = cps_men,
  weights = ~WTFINL
)

m5_5_women <- feols(
  log_earn ~ i(immigrant, ref = "Immigrant") + AGE + I(AGE^2) + EDUC | STATEFIP + IND + OCC,
  data = cps_women,
  weights = ~WTFINL
)

cps5_imm_cohort <- cps4 %>%
  filter(immigrant == "Immigrant", !is.na(YRIMMIG)) %>%
  mutate(recent = ifelse(YRIMMIG >= 2010, "Recent", "Long-term"))

m5_6_cohort <- feols(
  log_earn ~ recent + AGE + I(AGE^2) + FEMALE + EDUC | STATEFIP + IND + OCC,
  data = cps5_imm_cohort,
  weights = ~WTFINL
)

summary(m5_1_state)
summary(m5_2_state_ind)
summary(m5_3_interact)
summary(m5_4_fulltime)
summary(m5_5_men)
summary(m5_5_women)
summary(m5_6_cohort)
