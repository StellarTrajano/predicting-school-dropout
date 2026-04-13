library(tidyr)
library(stringr)
library(ggplot2)

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


dados_transp <- dados %>%
  pivot_longer(
    cols = matches("^TEV_(EF|EM)\\d+$"),
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
  select(-numero)

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
      "1º EF","2º EF","3º EF","4º EF","5º EF","6º EF","7º EF","8º EF","9º EF",
      "1º EM","2º EM","3º EM"
    )
  ) +
  
  scale_color_manual(
    values = c("Pública" = "#2C5985", "Privada" = "#AE123A"),
    labels = c("Pública" = "Public", "Privada" = "Private")
  ) +
  
  labs(
    title = "Dropout Rate by Grade and School Type",
    subtitle = "Comparison between public and private schools",
    x = "Grade",
    y = "Dropout Rate (%)",
    color = "School Type"
  ) +
  
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold"),
    legend.position = "top"
  )
