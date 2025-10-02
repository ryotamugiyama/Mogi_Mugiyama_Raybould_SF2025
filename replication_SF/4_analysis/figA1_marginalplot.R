library(tidyverse)
library(haven)

theme_set(theme_classic(base_line_size = 0.2,
                        base_rect_size = 0.2))
theme_mugi <- theme(strip.background = element_blank(),
                    strip.text.x = element_text(face = "bold"),
                    axis.title = element_text(size = 9, face = "bold"),
                    panel.grid.major = element_line(linewidth = 0.2, linetype = "dashed")
)

df_samplesize <- read_dta("data/nfi_sample.dta") 

df_samplesize2 <- df_samplesize %>% 
  filter(is.na(ferdes23) == FALSE) %>%
  count(age, partnership, .drop = FALSE) %>% 
  mutate(outcome = 2)
df_samplesize3 <- df_samplesize %>% 
  filter(is.na(ferdes13) == FALSE) %>%
  count(age, partnership, .drop = FALSE) %>% 
  mutate(outcome = 3)
df_samplesize4 <- df_samplesize %>% 
  filter(is.na(ferdes12) == FALSE) %>%
  count(age, partnership, .drop = FALSE) %>% 
  mutate(outcome = 4)
df_samplesize_all <- bind_rows(df_samplesize2, df_samplesize3, df_samplesize4)

df <- data.frame()
for (y in 2:4){
  for (i in 1:4){
  df_temp <- read_csv(paste0("results/figA1_margin_y", y, "_par", i, ".csv")) %>% 
    mutate(partnership = i) %>% 
    mutate(outcome = y)
  df <- bind_rows(df, df_temp)
}
}

df_revised <- df %>% 
  rename(var = 1) %>% 
  mutate(var = str_remove_all(var, pattern = "._at")) %>% 
  mutate(var = as.numeric(var)) %>% 
  separate(ci95, sep = ",", into = c("ci95_low", "ci95_high")) %>%
  mutate(ci95_low = as.numeric(ci95_low),
         ci95_high = as.numeric(ci95_high),
         age = as.numeric(var) + 19) %>%
  mutate(partnership_lab = factor(partnership,
                              levels = 1:4,
                              labels = c("Marital partnership",
                                         "Coresidential partnership",
                                         "Non-coresidential partnership",
                                         "Non-partnership"))) %>% 
  left_join(df_samplesize_all, by = c("outcome","age", "partnership")) %>% 
  mutate(outcome_lab = factor(outcome,
                              levels = 2:4,
                              labels = c("Positive vs Uncertain",
                                         "Positive vs Negative",
                                         "Uncertain vs Negative")))

df_revised %>% 
  filter(n >= 10) %>% 
  ggplot(aes(x = age, y = b, 
             color = partnership_lab, shape = partnership_lab)) +
  facet_wrap(~outcome_lab, ncol = 2) + 
  geom_point(position = position_dodge(width = 0.6)) + 
  geom_errorbar(aes(ymin = ci95_low, ymax = ci95_high), 
                width = 0, linewidth = 0.2,
                position = position_dodge(width = 0.6)) + 
  theme(legend.position = c(0.8,0.2)) +
  labs(x = "Age", y = "Predicted fertility desire (continuous)", color = "", shape = "") + 
  ggsci::scale_color_jco() +
  scale_shape_manual(values = c(16, 1, 2, 17)) + 
  guides(color = guide_legend(ncol = 1)) +
  theme_mugi + 
  scale_y_continuous(breaks = seq(0, 1, 0.2), limit = c(0, 1.1))

ggsave("results/figA1_margins_byage_men.pdf", width = 7, height = 5)
