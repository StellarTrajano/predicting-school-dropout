library(tidyr)
library(stringr)
library(ggplot2)
library(geobr)
library(sf)
library(ggcorrplot)

View(dados %>%
  group_by(DEPENDENCIA) %>%
  summarise(
    across(
      starts_with("TEV"),
      list(
        mean = ~ mean(.x, na.rm = TRUE),
        var  = ~ var(.x, na.rm = TRUE)
      )
    )
  ) %>%
  pivot_longer(
    cols = -DEPENDENCIA,
    names_to = c("variavel", "medida"),
    names_sep = "_(?=[^_]+$)",
    values_to = "valor"
  ) %>%
  pivot_wider(
    names_from = medida,
    values_from = valor
  ))


dados_transp = dados %>%
  pivot_longer(
    cols = matches("^TEV_(EF|EM)\\d+$"),  # só séries
    names_to = "variavel",
    values_to = "TEV"
  ) %>%
  mutate(
    numero = as.numeric(str_extract(variavel, "\\d+")),
    serie = ifelse(
      str_detect(variavel, "EF"),
      numero,
      numero + 9
    )
  ) %>%
  dplyr::select(REGIAO, UF, COD_MUNIC, MUNIC, AREA, DEPENDENCIA,
         variavel, TEV, serie)

dados_transp %>%
  group_by(serie, DEPENDENCIA) %>%
  summarise(media = mean(TEV, na.rm = TRUE))


#GRÁFICO DE LINHA 
dados_transp %>%
  filter(DEPENDENCIA != "Total") %>%
  group_by(serie, DEPENDENCIA) %>%
  summarise(
    media_tev = mean(TEV, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  ggplot(aes(x = serie, y = media_tev, color = DEPENDENCIA)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  
  scale_x_continuous(
    breaks = 1:12,
    labels = c(
      "1º ES","2º ES","3º ES","4º ES","5º ES","6º ES","7º ES","8º ES","9º ES",
      "1º HS","2º HS","3º HS"
    )
  ) +
  
  scale_color_manual(
    values = c("Pública" = "#AE123A", "Privada" = "#2C5985"),
    labels = c("Pública" = "Public", "Privada" = "Private")
  ) +
  
  labs(
    title = "Dropout Rate by Grade and School Type",
    subtitle = "Comparison between public and private schools",
    x = "Grade",
    y = "Dropout Rate (%)",
    color = "School Type"
  ) +
  
  theme_classic() +
  
  theme(
    plot.title = element_text(face = "bold"),
    axis.ticks.x = element_blank()
  )

ggsave(
  "outputs/figures/fig3_dropout_dependency.png",
  width = 8,
  height = 5,
  dpi = 300
)

'''O único momento que a escola particular tem mais evasão é no 1º ano, o que pode ser devido a dinâmica
de migração particular -> pública. A partir do 4º ano do ensino fundamental, a diferença no índice de evasão 
começa a progredir, embora o comportamento de evasão seja similar, com o maior média da taxa de evasão no 2º ano
do ensino médio e uma queda no 3º ano, em comparação ao ano anterior.'''


dados_transp %>%
  filter(DEPENDENCIA == "Total") %>%
  group_by(serie, DEPENDENCIA) %>%
  summarise(
    media_tev = mean(TEV, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  ggplot(aes(x = serie, y = media_tev)) +
  geom_line(size = 1, color = "#2C5985") +
  geom_point(size = 2) +
  
  scale_x_continuous(
    breaks = 1:12,
    labels = c(
      "1º ES","2º ES","3º ES","4º ES","5º ES","6º ES","7º ES","8º ES","9º ES",
      "1º HS","2º HS","3º HS"
    )
  ) +
  labs(
    title = "Dropout Rate by Grade and School Type",
    x = "Grade",
    y = "Dropout Rate (%)"
  ) +
  
  theme_classic() +
  
  theme(
    plot.title = element_text(face = "bold"),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank()
  )


'''O grafico considerando o índice total de evasão, disconsiderando o tipo da escola, replica os valores
das escolas públicas, tendo em vista que o índice de evasão das escolas particulares não passam de 5%, 
diferente da rede pública, que na 8º série, atinge o máximo do índice de evasão das escolas particulares
e não volta a ficar inferior. Dada a replicação desse comportamento, os dados totais não serão considerados
e os estudos serão aplicados com distinção de rede, logo, teremos a predição do índice de evasão das escolas 
particulares e públicas, separadamente, a partir do 4º ano do ensino fundamental'''

dados_transp %>%
  filter(DEPENDENCIA == "Total", AREA != "Total") %>%
  group_by(serie, AREA) %>%
  summarise(
    media_tev = mean(TEV, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  ggplot(aes(x = serie, y = media_tev, color = AREA)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  
  scale_x_continuous(
    breaks = 1:12,
    labels = c(
      "1º ES","2º ES","3º ES","4º ES","5º ES","6º ES","7º ES","8º ES","9º ES",
      "1º HS","2º HS","3º HS"
    )
  ) +
  
  scale_color_manual(
    values = c("Urbana" = "#528B8B", "Rural" = "#8B3E2F"),
    labels = c("Urbana" = "Urban", "Rural" = "Rural")
  ) +
  
  labs(
    title = "Dropout Rate by Grade and School Area",
    subtitle = "Comparison between urban and rural areas",
    x = "Grade",
    y = "Dropout Rate (%)",
    color = "Area"
  ) +
  
  theme_classic() +
  
  theme(
    plot.title = element_text(face = "bold"),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank()
  )

ggsave(
  "outputs/figures/fig2_dropout_area.png",
  width = 8,
  height = 5,
  dpi = 300
)
'''Alunos da zona rural evadem no 9º do ensino fundamental quase como no segundo ano do ensino médio.
Seria interessante identificar qual o cenário: percepção sobre conclusão do ensino? Inserção no mercado de trabalho?
Entende-se que o 9º ano pode ser lido como cocnlusão também.'''

mapa <- geobr::read_municipality(year = 2020, cache = FALSE)

df_mapa <- dados_transp %>%
  filter(DEPENDENCIA == "Total", serie > 4) %>% 
  group_by(COD_MUNIC) %>%
  summarise(
    tev_media = mean(TEV, na.rm = TRUE),
    .groups = "drop"
  )

mapa <- mapa %>%
  left_join(df_mapa, by = c("code_muni" = "COD_MUNIC"))

ggplot(mapa) +
  geom_sf(aes(fill = tev_media), color = NA) +
  
  scale_fill_viridis_c(
    option = "mako",
    na.value = "grey90",
    direction = -1
  ) +
  
  labs(
    title = "Average Dropout Rate by Municipality (Brazil)",
    fill = "Dropout Rate (%)"
  ) +
  
  theme_void() +
  theme(
    plot.title = element_text(face = "bold")
  )

ggsave(
  "outputs/figures/fig1_dropout_map.png",
  width = 8,
  height = 5,
  dpi = 300
)

#No estado do Pará existe uma maior concentração de municípios com altos índices de evasão escolar

df_mapa_priv <- dados_transp %>%
  filter(DEPENDENCIA == "Privada", serie > 4) %>% 
  group_by(COD_MUNIC) %>%
  summarise(
    tev_media = mean(TEV, na.rm = TRUE),
    .groups = "drop"
  )

mapa_priv <- mapa %>%
  left_join(df_mapa_priv, by = c("code_muni" = "COD_MUNIC"))

ggplot(mapa_priv) +
  geom_sf(aes(fill = tev_media), color = NA) +
  
  scale_fill_viridis_c(
    option = "mako",
    na.value = "grey90",
    direction = -1
  ) +
  
  labs(
    title = "Average Dropout Rate in Private Schools by Municipality (Brazil)",
    fill = "Dropout Rate (%)"
  ) +
  
  theme_void() +
  theme(
    plot.title = element_text(face = "bold")
  )

'''O índice, como esperado, é baixo para todo o país, com alguns poucos elementos. 
Logo não existe bem uma problemática sólida para a rede privada em termos de evasão'''

#Agora vou relacionar o índice de evasão a partir do 5º ano da rede pública com outras taxas.


dados2 <- dados %>%
  pivot_longer(
    cols = matches("^(TEV|TPROM|TREP)_(EF|EM)\\d+$"),
    names_to = "variavel",
    values_to = "valor"
  ) %>%
  mutate(
    indicador = str_extract(variavel, "^(TEV|TPROM|TREP)"),
    numero = as.numeric(str_extract(variavel, "\\d+")),
    SERIE = ifelse(
      str_detect(variavel, "EF"),
      numero,
      numero + 9
    )
  ) %>%
  pivot_wider(
    names_from = indicador,
    values_from = valor
  ) %>%
  filter(DEPENDENCIA == "Total", SERIE > 4, AREA != "Total") %>%
  group_by(REGIAO, UF, COD_MUNIC, MUNIC, SERIE, AREA) %>%
  summarise(
    TPROM = mean(TPROM, na.rm = TRUE),
    TREP  = mean(TREP, na.rm = TRUE),
    TEV   = mean(TEV, na.rm = TRUE),
    .groups = "drop"
  )

df_corr <- dados2 %>%
  select(TPROM, TREP, TEV) %>%
  rename(
    "Promotion" = TPROM,
    "Repetition" = TREP,
    "Dropout" = TEV
  )
cor(df_corr, use = "complete.obs")
#Dropout-Promotion:-0.7909177
#Dropout-Repetition:0.1778305
#Promotion-Repetition:-0.6874248

var(dados2$TEV, na.rm = T) #50.62
sd(dados2$TEV, na.rm = T) #7.11

ggplot(dados2, aes(x = "", y = TEV)) +
  geom_boxplot(
    fill = "#528B8B",        
    color = "#333333",
    alpha = 0.8,
    outlier.color = "#2C5985",
    outlier.alpha = 0.6
  ) +
  
  labs(
    title = "Distribution of Dropout Rates",
    subtitle = "Brazilian municipalities",
    x = NULL,
    y = "Dropout Rate (%)"
  ) +
  
  theme_classic() +
  
  theme(
    plot.title = element_text(face = "bold"),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank()
  )

ggsave(
  "outputs/figures/fig5_dropout_boxplot.png",
  width = 8,
  height = 5,
  dpi = 300
)

ggplot(dados2, aes(x = TEV)) +
  geom_histogram(
    bins = 30,
    fill = "#2C5985",
    color = "#333333",
    alpha = 0.95
  ) +
  
  labs(
    title = "Distribution of Dropout Rates",
    subtitle = "Brazilian municipalities",
    x = "Dropout Rate (%)",
    y = "Frequency"
  ) +
  
  theme_classic() +
  
  theme(
    plot.title = element_text(face = "bold"),
    axis.ticks.x = element_blank()
  )
ggsave(
  "outputs/figures/fig4_dropout_histogram.png",
  width = 8,
  height = 5,
  dpi = 300
)

#Muitos outliers: desigualdade regional, problemas estruturais...