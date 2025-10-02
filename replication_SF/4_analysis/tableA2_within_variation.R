library(tidyverse)
library(haven)
library(gtsummary)
library(flextable)

df <- read_dta("data/NFI_sample.dta")

df_var <- df %>% 
  mutate(gender = as_factor(gender)) %>% 
  group_by(id, gender) %>% 
  mutate(ferdes_sd = sd(ferdes)) %>% 
  mutate(ferdes_mean = mean(ferdes)) %>%
  mutate(partnership_sd = sd(partnership)) %>%
  mutate(partnership_mean = mean(partnership)) %>%
  ungroup() %>% 
  mutate(partnership_stay = case_when(
    partnership_sd != 0 ~ 0,
    partnership_sd == 0 & partnership_mean == 1 ~ 1,
    partnership_sd == 0 & partnership_mean == 2 ~ 2,
    partnership_sd == 0 & partnership_mean == 3 ~ 3,
    partnership_sd == 0 & partnership_mean == 4 ~ 4
    )) %>% 
  mutate(ferdes_stay = case_when(
      ferdes_sd != 0 ~ 0,
      ferdes_sd == 0 & ferdes_mean == 1 ~ 1,
      ferdes_sd == 0 & ferdes_mean == 2 ~ 2,
      ferdes_sd == 0 & ferdes_mean == 3 ~ 3
      )) %>% 
  mutate(partnership_stay = factor(partnership_stay,
                                   levels = c(0, 1:4),
                                   labels = c("Change", 
                                              "Stay in marital partnership",
                                              "Stay in coresidential partnership",
                                              "Stay in non-coresidential partnership",
                                              "Stay in non-partnership"))) %>% 
  mutate(ferdes_stay = factor(ferdes_stay,
                                   levels = c(0, 3:1),
                                   labels = c("Change", 
                                              "Stay in want",
                                              "Stay in do not know",
                                              "Stay in do not want"))) %>% 
  ungroup()

df_var_women <- df_var %>% filter(gender == "Women")
df_var_men <- df_var %>% filter(gender == "Men")

df_var_women %>% 
  tbl_cross(partnership_stay, ferdes_stay, percent = "cell") %>% 
  as_flex_table() %>% 
  save_as_docx(path = "results/tableA2_sex1.docx")
df_var_women %>% 
  distinct(id, .keep_all = TRUE) %>% 
  tbl_cross(partnership_stay, ferdes_stay, percent = "cell") %>% 
  as_flex_table() %>%
  save_as_docx(path = "results/tableA2_sex1_indiv.docx")

df_var_men %>% 
  tbl_cross(partnership_stay, ferdes_stay, percent = "cell") %>% 
  as_flex_table() %>%
  save_as_docx(path = "results/tableA2_sex2.docx")
df_var_men %>% 
  distinct(id, .keep_all = TRUE) %>% 
  tbl_cross(partnership_stay, ferdes_stay, percent = "cell") %>% 
  as_flex_table() %>%
  save_as_docx(path = "results/tableA2_sex2_indiv.docx")
