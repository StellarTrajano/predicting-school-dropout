library(caret)
library(Metrics)
library(tidyverse)
library(rpart)
library(randomForest)
library(MASS)        # Huber (rlm)
library(robustbase)

dados2$SERIE = as.factor(dados2$SERIE)

dados_model = dados2 %>%
  drop_na(TEV, TREP, SERIE)

set.seed(123)

train_index <- createDataPartition(dados_model$TEV, p = 0.8, list = FALSE)

train <- dados_model[train_index, ]
test  <- dados_model[-train_index, ]

m1 = lm(TEV ~ SERIE, data = dados2)
m2 = lm(TEV ~ TREP, data = dados2)
m3 = lm(TEV ~ TREP + SERIE + AREA, data = dados2)
m4 = lm(TEV ~ TREP + SERIE + AREA + UF, data = dados2)

#MAE (Mean Absolute Error)
#MedAE (Median Absolute Error)

pred1 <- predict(m1, newdata = test)
mae1   <- mae(test$TEV, pred1)
medae1 <- median(abs(test$TEV - pred1))

pred2 <- predict(m2, newdata = test)
mae2   <- mae(test$TEV, pred2)
medae2 <- median(abs(test$TEV - pred2))

pred3 <- predict(m3, newdata = test)
mae3   <- mae(test$TEV, pred3)
medae3 <- median(abs(test$TEV - pred3))

pred4 <- predict(m4, newdata = test)
mae4   <- mae(test$TEV, pred4)
medae4 <- median(abs(test$TEV - pred4))

resultados <- data.frame(
  modelo = c("m1", "m2", "m3","m4"),
  MAE    = c(mae1, mae2, mae3, mae4),
  MedAE  = c(medae1, medae2, medae3, medae4)
)

resultados

#Desempenho: m3 é melhor
#Menos afetado por ouliers: m1

################################################

modelo_tree <- train(
  TEV ~ TREP + SERIE + AREA,,
  data = train,
  method = "rpart"
)

pred_tree <- predict(modelo_tree, test)

#

modelo_rf <- train(
  TEV ~ TREP + SERIE + AREA,
  data = train,
  method = "rf",
  trControl = trainControl(method = "cv", number = 5)
)

pred_rf <- predict(modelo_rf, test)

#

modelo_huber <- rlm(
  TEV ~ TREP + SERIE + AREA,
  data = train
)

pred_huber <- predict(modelo_huber, test)

#

modelo_rob = lmrob(
  TEV ~ TREP + SERIE + AREA,
  data = train
)

pred_rob = predict(modelo_rob, test)

#Cross-validation
'''K-Fold: trainControl(method = "cv", number = 5)
LOOCV: trainControl(method = "LOOCV")
'''
#####################################################################

resultados <- tibble(
  modelo = c("Decision Tree", "Random Forest", "Huber", "Robust (lmrob)"),
  
  MAE = c(
    mae(test$TEV, pred_tree),
    mae(test$TEV, pred_rf),
    mae(test$TEV, pred_huber),
    mae(test$TEV, pred_rob)
  ),
  
  MedAE = c(
    median(abs(test$TEV - pred_tree)),
    median(abs(test$TEV - pred_rf)),
    median(abs(test$TEV - pred_huber)),
    median(abs(test$TEV - pred_rob))
  )
)

resultados %>% arrange(MAE)

'''modelo           MAE MedAE
   Random Forest   3.50  2.27
   Huber           3.54  2.20
-> Robust (lmrob)  3.54  2.15 <-
   Decision Tree   3.88  3.20
'''
#######################################################################
coef(modelo_rob) #2º do ensino médio, seguido do 1º ano do ensino médio, 8º ano do fundamental,índice de reprovação, 3º ano do ensino médio, 5º,6º e 7º  ano do ensino funda 
varImp(modelo_rob) #Bizarro depender mais do ano que você está do que se repetiu: a evasão não é linear, acontece em pontos de transição
summary(modelo_rob)

ggplot(dados_model, aes(x = TREP, y = TEV)) + 
  geom_point(
    alpha = 0.25,
    color = "#2C5985",
    size = 1.5
  ) +
  
  geom_smooth(
    method = "lm",
    color = "#AE123A",
    fill = "#AE123A",
    alpha = 0.2,
    size = 1
  ) +
  
  labs(
    title = "Relationship Between Repetition and Dropout Rates",
    subtitle = "Brazilian municipalities (public schools)",
    x = "Repetition Rate (%)",
    y = "Dropout Rate (%)"
  ) +
  
  theme_minimal(base_size = 12) +
  
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11, color = "gray40"),
    axis.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )

#

base_real <- dados2 %>%
  group_by(UF, SERIE, AREA) %>%
  summarise(
    TEV_real = mean(TEV, na.rm = TRUE),
    TREP = mean(TREP, na.rm = TRUE),
    .groups = "drop"
  )

base_real$SERIE <- factor(base_real$SERIE, levels = levels(train$SERIE))

base_real$TEV_pred = predict(modelo_rob, newdata = base_real)

ggplot(base_real, aes(x = as.numeric(as.character(SERIE)))) +
  
  # linha real
  stat_summary(
    aes(y = TEV_real, color = "Observed"),
    fun = mean,
    geom = "line",
    size = 1.2
  ) +
  
  # linha prevista
  stat_summary(
    aes(y = TEV_pred, color = "Predicted"),
    fun = mean,
    geom = "line",
    linetype = "dashed",
    size = 1.2
  ) +
  
  scale_color_manual(values = c("Observed" = "#2C5985", "Predicted" = "#AE123A")) +
  
  labs(
    title = "Observed vs Predicted Dropout Rate by Grade",
    x = "Grade",
    y = "Dropout Rate (%)",
    color = ""
  ) +
  
  theme_minimal() +
  theme(
    legend.position = "top",
    plot.title = element_text(face = "bold")
  )


ggsave(
  "outputs/figures/fig6_observed_vs_predicted.png",
  width = 8,
  height = 5,
  dpi = 300
)



ggplot(base_real, aes(x = as.numeric(as.character(SERIE)))) +
  
  geom_line(aes(y = TEV_real, color = "Observed"), size = 0.8) +
  geom_line(aes(y = TEV_pred, color = "Predicted"), linetype = "dashed", size = 0.8) +
  
  facet_wrap(~UF, ncol = 6) +
  
  scale_color_manual(values = c("Observed" = "#2C3E50", "Predicted" = "#E74C3C")) +
  
  labs(
    title = "Observed vs Predicted Dropout Rate by State and Grade",
    x = "Grade",
    y = "Dropout Rate (%)",
    color = ""
  ) +
  
  theme_minimal() +
  theme(legend.position = "top")
