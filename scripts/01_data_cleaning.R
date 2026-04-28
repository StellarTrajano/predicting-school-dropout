library(readxl)
library(dplyr)

dados = 
  read_excel("C:/Users/stellat/Downloads/Pessoal/Education/TX_TRANSICAO_MUNICIPIOS_2021_2022/TX_TRANSICAO_MUNICIPIOS_2021_2022.xlsx")
dados <- dados %>%
  mutate(across(starts_with("TPROM"), as.numeric),
         across(starts_with("TREP"), as.numeric),
         across(starts_with("TEV"), as.numeric))
