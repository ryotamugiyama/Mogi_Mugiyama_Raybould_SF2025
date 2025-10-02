library(tidyverse)
library(haven)

theme_set(theme_classic(base_line_size = 0.2,
                        base_rect_size = 0.2))
theme_mugi <- theme(legend.position = "bottom",
                    legend.margin = margin(t = -5),
                    strip.background = element_blank(),
                    strip.text.x = element_text(face = "bold"),
                    axis.title = element_text(size = 9, face = "bold"),
                    panel.grid.major = element_line(linewidth = 0.2, linetype = "dashed")
)

nfi <- read_dta("data/nfi_sample.dta")

nfi_df <- nfi %>% 
  mutate(ferdes_1 = if_else(ferdes == 1, 1, 0)) %>% 
  mutate(ferdes_2 = if_else(ferdes == 2, 1, 0)) %>% 
  mutate(ferdes_3 = if_else(ferdes == 3, 1, 0)) %>% 
  mutate(partnership_1 = if_else(partnership == 1, 1, 0)) %>% 
  mutate(partnership_2 = if_else(partnership == 2, 1, 0)) %>% 
  mutate(partnership_3 = if_else(partnership == 3, 1, 0)) %>% 
  mutate(partnership_4 = if_else(partnership == 4, 1, 0)) %>% 
  mutate(gender = as_factor(gender)) %>% 
  mutate(partnership = fct_rev(as_factor(partnership))) %>% 
  mutate(nopartner_dur1_group = fct_rev(as_factor(nopartner_dur1_group)))

## Fig.A2 fertility desire by age and gender -----
nfi_df_1 <-  nfi_df %>% 
  group_by(gender, age) %>% 
  summarize(prop_ferdes1 = mean(ferdes_1),
            prop_ferdes2 = mean(ferdes_2),
            prop_ferdes3 = mean(ferdes_3),
            n = n()) %>%
  ungroup() %>% 
  pivot_longer(cols = c(prop_ferdes1:prop_ferdes3)) %>%
  mutate(prop_ferdes_category = str_sub(name, start = -1, end = -1)) %>% 
  mutate(prop_ferdes_category = as.numeric(prop_ferdes_category)) %>% 
  mutate(prop_ferdes_category = factor(prop_ferdes_category,
                                       levels = 3:1,
                                       labels = c("Positive", "Uncertain", "Negative"))) %>% 
  mutate(value_label = gsub("0\\.", "\\.",
                            sprintf("%.2f", 
                                    round(value, digits = 2)
                            )))
  
nfi_df_1 %>% 
  ggplot(aes(x = age, y = value, fill = prop_ferdes_category)) + 
  geom_col(width = 0.8) + 
  facet_grid(~gender) +
  ggsci::scale_fill_jco() +
  guides(fill = guide_legend(reverse = TRUE)) + 
  theme_mugi + 
  labs(x = "Age", y = "Proportion", fill = "")
ggsave("results/figA2_fertilitydesire_byage.pdf", width = 7, height = 4)

## Fig.A3 partnership status by age and gender -----
nfi_df_2 <-  nfi_df %>% 
  group_by(gender, age) %>% 
  summarize(prop_partnership1 = mean(partnership_1),
            prop_partnership2 = mean(partnership_2),
            prop_partnership3 = mean(partnership_3),
            prop_partnership4 = mean(partnership_4),
            n = n()) %>%
  ungroup() %>% 
  pivot_longer(cols = c(prop_partnership1:prop_partnership4)) %>%
  mutate(prop_partnership_category = str_sub(name, start = -1, end = -1)) %>% 
  mutate(prop_partnership_category = as.numeric(prop_partnership_category)) %>% 
  mutate(prop_partnership_category = factor(prop_partnership_category,
                                       levels = 1:4,
                                       labels = c("Marital partnership", 
                                                  "Coresidential partnership", 
                                                  "Non-coresidential partnership",
                                                  "Non-partnership"))) %>% 
  mutate(value_label = gsub("0\\.", "\\.",
                            sprintf("%.2f", 
                                    round(value, digits = 2)
                            )))

nfi_df_2 %>% 
  ggplot(aes(x = age, y = value, fill = prop_partnership_category)) + 
  geom_col(width = 0.8) + 
  facet_grid(~gender) +
  guides(fill = guide_legend(reverse = TRUE, nrow = 2)) + 
  theme_mugi + 
  ggsci::scale_fill_jco() +
  labs(x = "Age", y = "Proportion", fill = "") 

ggsave("results/figA3_partnership_byage.pdf", width = 7, height = 4)

## Fig.1 fertility desire and partnership status by gender ----

nfi_df_3 <- nfi_df %>% 
  group_by(gender, partnership) %>% 
  summarize(mean_ferdes = mean(ferdes),
            prop_ferdes1 = mean(ferdes_1),
            prop_ferdes2 = mean(ferdes_2),
            prop_ferdes3 = mean(ferdes_3)) %>% 
  ungroup() %>% 
  pivot_longer(cols = c(prop_ferdes1:prop_ferdes3)) %>% 
  mutate(prop_ferdes_category = str_sub(name, start = -1, end = -1)) %>% 
  mutate(prop_ferdes_category = as.numeric(prop_ferdes_category)) %>% 
  mutate(prop_ferdes_category = factor(prop_ferdes_category,
                                     levels = 3:1,
                                     labels = c("Positive", "Uncertain", "Negative"))) %>% 
  mutate(value_label = gsub("0\\.", "\\.",
                            sprintf("%.2f", 
                                    round(value, digits = 2)
                            ))) %>% 
  group_by(gender, partnership) %>% 
  mutate(row = 1:n()) %>%
  mutate(mean_ferdes = if_else(row == 1, mean_ferdes, NA_real_))

nfi_df_3 %>% 
  ggplot(aes(x = value, y = partnership, fill = prop_ferdes_category)) + 
  geom_col(width = 0.8) + 
  facet_grid(~gender) +
  geom_text(aes(label = value_label),
            position = position_stack(vjust = .5),
            color = "white",
            size = 3) + 
  guides(fill = guide_legend(reverse = TRUE)) + 
  ggsci::scale_fill_jco() +
  theme_mugi + 
  theme(plot.subtitle = element_text(size = 10, face = "bold", hjust = -0.5, color = "gray20"),
        panel.grid.major.x = element_line(linewidth = 0.2, 
                                        linetype = "dashed",
                                        color = "gray80"))  + 
  labs(y = "Partnership status", x = "Proportion", fill = "")
  
ggsave("results/fig1_fertility_by_partnership.pdf", width = 7, height = 4)

## Fig.2 fertility desire and partnership status (separating duration) by gender ----

nfi_df_4 <- nfi_df %>% 
  filter(partnership == "Non-partnership") %>% 
  group_by(gender, nopartner_dur1_group) %>% 
  summarize(mean_ferdes = mean(ferdes),
            prop_ferdes1 = mean(ferdes_1),
            prop_ferdes2 = mean(ferdes_2),
            prop_ferdes3 = mean(ferdes_3),
            n = n()) %>% 
  ungroup() %>% 
  pivot_longer(cols = c(prop_ferdes1:prop_ferdes3)) %>% 
  mutate(prop_ferdes_category = str_sub(name, start = -1, end = -1)) %>% 
  mutate(prop_ferdes_category = as.numeric(prop_ferdes_category)) %>% 
  mutate(prop_ferdes_category = factor(prop_ferdes_category,
                                     levels = 3:1,
                                     labels = c("Positive", "Uncertain", "Negative "))) %>% 
  mutate(value_label = gsub("0\\.", "\\.",
                            sprintf("%.2f", 
                                    round(value, digits = 2)
                            ))) %>% 
  rename(partnership = nopartner_dur1_group) %>% 
  mutate(partnership = factor(partnership,
                              levels = 11:1,
                              labels = c("11+ years", "10 years", "9 years", "8 years", "7 years",
                                         "6 years", "5 years", "4 years", "3 years", "2 years", "1 year"))) %>%
  group_by(gender, partnership) %>% 
  mutate(row = 1:n()) %>%
  mutate(mean_ferdes = if_else(row == 1, mean_ferdes, NA_real_))

nfi_df_4 %>% 
  ggplot(aes(x = value, y = partnership, fill = prop_ferdes_category)) + 
  geom_col(width = 0.8) + 
  facet_grid(~gender) +
  geom_text(aes(label = value_label),
            position = position_stack(vjust = .5),
            color = "white",
            size = 3) + 
  guides(fill = guide_legend(reverse = TRUE)) + 
  ggsci::scale_fill_jco() +
  theme_mugi + 
  theme(plot.subtitle = element_text(size = 10, face = "bold", hjust = -0.5, color = "gray20"),
        panel.grid.major.x = element_line(linewidth = 0.2, 
                                          linetype = "dashed",
                                          color = "gray80"))  + 
  labs(y = "Duration of non-partnership", x = "Proportion", fill = "")

ggsave("results/fig2_fertility_by_partnership.pdf", width = 7, height = 5)
