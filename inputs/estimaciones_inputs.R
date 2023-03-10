
library(tidyverse)
library(sjmisc)
library(writexl)

load(file.path('inputs', 'ELSOC_Long_2016_2022_v1.00_R.RData'))

# Formato segun muestra y ola
t1 <- elsoc_long_2016_2022 %>% 
  group_by(muestra, ola,formato) %>% 
  summarise(n = n()) %>% 
  pivot_wider(names_from = c(muestra, formato),
              names_prefix = 'n',
              values_from = n)

t1[is.na(t1)] <- 0

# Formato segun estrato y ola

t2 <- elsoc_long_2016_2022 %>% 
  filter(ola == 6) %>% 
  sjlabelled::as_label(estrato, formato) %>% 
  group_by(estrato, formato) %>% 
  summarise(n = n()) %>% 
  pivot_wider(names_from = c(formato),
              names_prefix = 'n_',
              values_from = n) %>% 
  mutate(porc_cati = n_CATI  / (n_CATI + n_CAPI))

t2[is.na(t2)] <- 0

writexl::write_xlsx(x = list('n_mixmode' = t1),
                    path = file.path('inputs', 'estimaciones_mixmode.xlsx'))

