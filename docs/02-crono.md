# k-NN (k-Nearest Neighbour Classification) {#knn}
El algoritmo k-NN reconoce patrones en los datos sin un aprendizaje específico, simplemente midiendo la distancia entre grupos de datos. Se trata de uno de los algoritmos más simples y robustos de aprendizaje automatico.


## Tabla resumen de modelos
 1. **knn**
    - library(class) 
    - `m<-knn(train = tabla_train, test = tabla_test, cl = tabla_train$col_clasificadora)`
    - el resultado de la función es el tipo de clase `cl` al que pertenecen los datos de la tabla_test
    - Para optimizar los resultados el modelo necesita estandarizar las variables normalizar distancias
        * scale(tabla)
 1. **naivebayes**
    - library(naivebayes)
    - `m<-naive_bayes(var_dependiente ~ var1 + var2..., data = tabla_datos, laplace = n)` laplace es opcional y agrega n casos para cada supuesto combinatorio.
    - `predict(m)` prediccion sobre toda la tabla origen
    - `predict(m,h,type="prob")`  siendo `h` un hecho en `data.frame`.
        - `type = "prob"`  muestra probabilidad de cada clase de salida, si se omite el type, el resultado es la clasificación más probable.
 1. **naivebayes_e1071**
    - library(e1071)
    - `m<-naiveBayes(var_dependiente ~ ., data = tabla_datos_train)`
    - `predict(m)` predicción sobre toda la tabla origen `tabla_datos_train`, ,`type="prob"` opcional 
    - `predict(m,tabla_datos_test)`
 1. **Regresión logistica** `glm`
    - library(stats), cargada por defecto con R base.
    - `m_glm<-glm(y ~ x1 + x2 + x3,data = misdatos_train, family = "binomial")`
    - `m_glm<-glm(y ~ x1*x2, data = misdatos_train, family = "binomial")`  para variables con impacto combinado, efecto conjunto exponencial sobre la variable dependiente.
    - probabilidad: `prob <- predict(m_glm, misdatos_test, type = "response")` usar tipo response
    - umbral de prediccion: `pred <- ifelse(prob > 0.50, 1, 0)`
    - `summary(m_glm)` 
 1. **Optimizacion de regresión logistica** `glm`
    - Se usa para hallar el mejor modelo de pronóstico, definiendo un inicio y fin de modelos:  
        1.Modelo sin predictores: `null_model <- glm(var1 ~ 1, data = misdatos, family = "binomial")`
        2.Modelo completo: `full_model <- glm(var1 ~ ., data = misdatos, family = "binomial")`
        3. funcion step(): `step_model <- step(null_model, scope = list(lower = null_model, upper = full_model), direction = "forward")`
    - `summary(step_model)` da el resultado de las pruebas con el mejor modelo
    - Para estimar la probabilidad: `step_prob <- predict(step_model, type = "response")`
 1. **Árboles de decisión**
    - los datos origen a clasificar deben ser factores o estar categorizados. No es conveniente usar datos continuos.
    - `library(rpart)`
    - Hay que definir una poda `poda<-rpart.control(cp= 0.2, maxdepth = 30, minsplit = 20)`que limita el árbol, lo más común es usar solo cp=0.2.
    - `m_tree<-rpart(var_dependiente ~ ., data = tabla_datos_train, control = poda)` 
    - `predict(m_tree, h,type = "class")` predicción sobre el hecho `h`
    - `predict(m,tabla_datos_test)` predicción sobre los datos de test
    - Se puede dibujar el árbol con rpart.plot:
        `rpart.plot(m_tree, type = 2, clip.right.labs = FALSE,`
        `branch = .6,`
        `box.palette = c( "red","green"),`       
        `main = "Ejemplo de arbol \n lalala")`
 1. **Bosques aleatorios**.
    - Los bosques son sumas de modelos de árboles. Por lo que es mejor no usar datos contim¡nuos sino categorizados.
    - `library(randomForest)`
    - `m_bosque <- randomForest(var_dependiente ~ ., data = tabla_datos_train[complete.cases(tabla_datos_train),], ntree = 100 )`  Hemos excluído todos los posibles NA, pero podría hacerse previamente un `impute` de estos datos.
    - `predict(m_bosque)` predicción sobre toda la tabla origen  
    - `predict(m_bosque,tabla_datos_test)`, predicción sobre los datos de test 
    - Pintamos la evolucion del modelo y vemos a partir de qué numero de arboles los resultados son homogeneos: `plot(m_bosque)`
