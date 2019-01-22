# Preparar los datos para el modelo de aprendizaje
Antes de comenzar a usar modelos de pronóstico supervisados tenemos que preparar los datos de origen y realizar unas tareas que nos den el control del proceso y nos permitan verificar, al finalizar, la bondad y ajuste de nuestras previsiones.

Es una buena práctica y debemos empezar siempre por ella, dividir el conjunto de datos de origen en dos subconjuntos, uno de ellos nos servirá para el entrenamiento (*train*) del modelo y el otro para la comprobación -a posteriori- (*test*). Con este sistema de división de la muestra inicial de datos evitamos el *overfitting* tan preocupante en los modelo de predicción.

Otro de los trabajos preparatorios de importancia es la factorización o agrupamiento de los datos. En casos como el modelo de *naive bayes*, el uso de valores numéricos continuos en los datos de origen genera una sobredimensión exponencial de los casos posibles, por exceso de combinatoria entre variables que desborda el modelo y puede producir errores en los pronósticos.

En estos casos es siempre recomendable factorizar, agrupar y disminuir la dimensión origen de las variables de entrada agrupando valores.

En otros casos como el algoritmo *knn*, la medición de distancia entre variables es el eje del pronóstico, por lo que es necesario escalar los datos normalizarlos para equiparar la fórmula de distancia entre las variables, como veremos en los ejemplos.

## Crear particiones de la muestra {#particiones}
El primer paso en todo análisis debe ser dividir la muestra de datos en dos conjuntos de datos uno para entrenamiento y otro para test.
Esto se puede hacer a mano, por ejemplo usando la función `sample`, o con la ayuda de algunos paquetes que llevan funciones incorporadas para las particiones de datos.

### Ejemplo de partición a mano
Usaremos la base de datos de muestra de supervivientes del Titanic que se da como tabla en `dataset`. Para ver todas las series y bases de datos disponibles en dataset escribiremos `data()`.

Titanic es una tabla que indica casos y frecuencias de cada caso, por lo que para crear la tabla completa hay que expandir la tabla origen, y repetir cada caso el número de veces que indica la columna frecuencia.


```r
# cargamos los datos
    data("Titanic")
    str(Titanic)
```

```
##  'table' num [1:4, 1:2, 1:2, 1:2] 0 0 35 0 0 0 17 0 118 154 ...
##  - attr(*, "dimnames")=List of 4
##   ..$ Class   : chr [1:4] "1st" "2nd" "3rd" "Crew"
##   ..$ Sex     : chr [1:2] "Male" "Female"
##   ..$ Age     : chr [1:2] "Child" "Adult"
##   ..$ Survived: chr [1:2] "No" "Yes"
```

```r
    class(Titanic)
```

```
## [1] "table"
```

```r
# Transformamos los datos wn una dataframe
    Titanic_df=as.data.frame(Titanic)
    str(Titanic_df)
```

```
## 'data.frame':	32 obs. of  5 variables:
##  $ Class   : Factor w/ 4 levels "1st","2nd","3rd",..: 1 2 3 4 1 2 3 4 1 2 ...
##  $ Sex     : Factor w/ 2 levels "Male","Female": 1 1 1 1 2 2 2 2 1 1 ...
##  $ Age     : Factor w/ 2 levels "Child","Adult": 1 1 1 1 1 1 1 1 2 2 ...
##  $ Survived: Factor w/ 2 levels "No","Yes": 1 1 1 1 1 1 1 1 1 1 ...
##  $ Freq    : num  0 0 35 0 0 0 17 0 118 154 ...
```

```r
# Creamos una tabla de casos competos a partir de la frecuencia de cada uno
# Esto repite cada caso el num de veces que se ha dado 
# según la frecuencia que está en la columna Freq de la tabla.
    repetir_secuencia=rep.int(seq_len(nrow(Titanic_df)), Titanic_df$Freq) 
# tenemos una serie con el numero de registro de la tabla original y las veces que se repite    

# Creamos una nueva tabla repitiendo los casos según el modelo anterior.
    Titanic_data=Titanic_df[repetir_secuencia,]
    
# Ya no necesitamos la columna de frecuencias  y la borramos.
    Titanic_data$Freq=NULL
    head(Titanic_data)
```

```
##     Class  Sex   Age Survived
## 3     3rd Male Child       No
## 3.1   3rd Male Child       No
## 3.2   3rd Male Child       No
## 3.3   3rd Male Child       No
## 3.4   3rd Male Child       No
## 3.5   3rd Male Child       No
```

```r
# Como vemos todo son factores
    str(Titanic_data)
```

```
## 'data.frame':	2201 obs. of  4 variables:
##  $ Class   : Factor w/ 4 levels "1st","2nd","3rd",..: 3 3 3 3 3 3 3 3 3 3 ...
##  $ Sex     : Factor w/ 2 levels "Male","Female": 1 1 1 1 1 1 1 1 1 1 ...
##  $ Age     : Factor w/ 2 levels "Child","Adult": 1 1 1 1 1 1 1 1 1 1 ...
##  $ Survived: Factor w/ 2 levels "No","Yes": 1 1 1 1 1 1 1 1 1 1 ...
```
En este caso buscamos dividir la tabla en dos conjuntos uno de entrenamiento con el 75% de los registros y otro de comprobación o de test con el 25% restante de los registros que nos servirá para validar el modelo.


```r
# -----------------------------------
# DIVISION A MANO
# contamos el num de registro de la base de datos del titanic
    nrow(Titanic_data)
```

```
## [1] 2201
```

```r
# calculamos el 75%
    num_reg_entrenamiento<-as.integer(0.75*nrow(Titanic_data))
    num_reg_entrenamiento
```

```
## [1] 1650
```

```r
# Creamos una vector de 75% de los registros aleatorio
    titanic_train <- sample(nrow(Titanic_data), num_reg_entrenamiento)

# Creamos el conjunto de registros de entrenamiento pasando ese vector a la tabla 
    d_titanic_train <- Titanic_data[titanic_train,]
    head(d_titanic_train)
```

```
##        Class    Sex   Age Survived
## 12.53   Crew   Male Adult       No
## 28.107  Crew   Male Adult      Yes
## 12.115  Crew   Male Adult       No
## 12.94   Crew   Male Adult       No
## 10.144   2nd   Male Adult       No
## 29.44    1st Female Adult      Yes
```

```r
# Creamos los datos de comprobación o test (notese el -)
    d_titanic_test <- Titanic_data[-titanic_train,]
    head(d_titanic_test)
```

```
##      Class  Sex   Age Survived
## 3      3rd Male Child       No
## 3.7    3rd Male Child       No
## 3.8    3rd Male Child       No
## 3.13   3rd Male Child       No
## 3.25   3rd Male Child       No
## 3.28   3rd Male Child       No
```
Usando una formulación simple hemos creado dos conjuntos de muestra aleatorios excluyentes de entrenamiento y muestra.

### Ejemplo de partición con `library(caret)`

Veamos otra forma de hacerlo usando la librería `library(caret)`


```r
library(caret)
set.seed(987654321)
# creamos un vector de particion sobre la variable Survived
# el tamaño de muestra será de 75%
trainIndex=createDataPartition(Titanic_data$Survived, p=0.75)$Resample1

d_titanic_train=Titanic_data[trainIndex, ]
d_titanic_test= Titanic_data[-trainIndex, ]
```

## Categorización de los datos origen
Existe un problema en el uso de las funciones de clasificación cuando las combinaciones posibles entre variables tienden a ser infinitas. Esto sucede cuando, por ejemplo, una de las variables es de tipo numérico, y tiene datos continuos.

La mayoría de los modelos de clasificación solo son capaces de trabajar un número limitado de categorías, y por lo tanto, es necesario agrupar los datos originales y reducir las opciones combinatorias, por lo que hay que evitar siempre el uso de varialbles continuas en los datos. Si no realizamos la reducción de categorías nos arriesgamos a obtener errores, incluso evidentes, en los pronósticos.

Un caso evidente es el uso de la función de `naive_bayes` que maneja muy mal los datos continuos, pues está pensado para variables categorizadas.

La solución es realizar una categorización previa de los datos que evite el problema y a la vez simplifique el modelo de pronóstico. Categorizar significa agrupar los datos de las variables continuas en categorías próximas, simplificando las salidas y reduciendo las combinaciones.

Un ejemplo claro es redondear las salidas numéricas a números divisibles por 10 o por 5, o sustituir la variable por los cuantiles más representativos. 

Para transformar las variables y categorizarlas podemos usar varias funiciones de R como:

  - convertir a factor con la funcion `as.factor()`.
        * Las categorías de un factor se ven con la función `levels()`
        * los nombres de esas categorias los damos con la funcion `lables()`
  - la funcion `table(tabla_1$hora)` cuenta y resumen los datos
  - las funciones `quantile()` o `cut()` ayudan a dividir y categorizar variables continuas
  - fundiones de redondeo

Vamos a ver varios ejemplo con la dataset "women" que contiene las alturas y pesos de mujeres americanas de edad entre 30 y 39 años. Ambos datos de altura y peso son continuos y toman 15 posibles valores, por lo que las combinaciones cruzadas dan muchísimos casos posibles. Para simplificar las combinatorias vamos a categorizar los datos de varias maneras, como ejemplos: 


```r
# cargamos los datos de
    data("women")
    str(women)
```

```
## 'data.frame':	15 obs. of  2 variables:
##  $ height: num  58 59 60 61 62 63 64 65 66 67 ...
##  $ weight: num  115 117 120 123 126 129 132 135 139 142 ...
```

```r
    summary(women)
```

```
##      height         weight     
##  Min.   :58.0   Min.   :115.0  
##  1st Qu.:61.5   1st Qu.:124.5  
##  Median :65.0   Median :135.0  
##  Mean   :65.0   Mean   :136.7  
##  3rd Qu.:68.5   3rd Qu.:148.0  
##  Max.   :72.0   Max.   :164.0
```

```r
    length(unique(women$height)) # numero de registros unicos
```

```
## [1] 15
```

```r
    length(unique(women$weight))
```

```
## [1] 15
```

```r
# opcion 1. creamos una funcion de redondeo
    redondea5<-function(x,base=5){
            as.integer(base*round(x/base))
    }
    
# Copiamos la tabla con el nombre nuevo
    mujeres_a<-women
# pasamos los datos a sistema internacional
    mujeres_a$peso<-mujeres_a$weight*0.453592 # paso a kg
    mujeres_a$peso<- redondea5(mujeres_a$peso,10)
    length(unique(mujeres_a$peso))  
```

```
## [1] 3
```

```r
    mujeres_a$altura<-mujeres_a$height*2.54 # paso a cm
    mujeres_a$altura<- redondea5(mujeres_a$altura,10)
    length(unique(mujeres_a$altura))  
```

```
## [1] 4
```

```r
    head(mujeres_a)
```

```
##   height weight peso altura
## 1     58    115   50    150
## 2     59    117   50    150
## 3     60    120   50    150
## 4     61    123   60    150
## 5     62    126   60    160
## 6     63    129   60    160
```

Con la simplificacion anterior hemos pasado de 15x15 casos combinatorios a solo 3x4.

Podríamos usar también factores para convertir los datos


```r
#Ejemplo de transformacion a factor
    mujeres_a$peso1<- factor(mujeres_a$peso,
                         levels = c(50, 60, 70),
                         labels = c( "flaca","media","gordita"))
# Ejemplo 2 de trans a factor:
    mujeres_a$altura1 <- factor(mujeres_a$altura, levels = c(150,160,170,180), labels = c("Bajo","Medio","Alta", "muy alta"))
    head(mujeres_a)
```

```
##   height weight peso altura peso1 altura1
## 1     58    115   50    150 flaca    Bajo
## 2     59    117   50    150 flaca    Bajo
## 3     60    120   50    150 flaca    Bajo
## 4     61    123   60    150 media    Bajo
## 5     62    126   60    160 media   Medio
## 6     63    129   60    160 media   Medio
```

## Manejo de NA
En todos los modelos, la existencia de registros con falta de datos o NA, anula el valor de dicha evidencia en el modelo de entrenamiento.

Una solución es completar estos casos con las funciones como `impute()` del paquete `e1071` que sustituye el NA por un valor estimado, que puede ser la media. 

En la tabla de ejemplo `donors` hay muchos datos de la edad de los clientes que faltan.


```r
    # Vemos cuantos datos de edad faltan.
        set.seed(333)
        datos<-data.frame(a=sample(1:10, 100,replace = T))
        datos$a[c(1,3)] <- NA
        head(datos)
```

```
##    a
## 1 NA
## 2  1
## 3 NA
## 4  6
## 5  1
## 6  8
```

```r
    library(e1071)
    # Imputamos la nuevos datos estimados de edad asignando usando impute
        datos$imputed <- impute(datos)
        head(datos)
```

```
##    a a
## 1 NA 5
## 2  1 1
## 3 NA 5
## 4  6 6
## 5  1 1
## 6  8 8
```

```r
    # Otra forma es hacerlo manualmente    
        datos$imputed2<-ifelse(is.na(datos$a),5,datos$a)
        head(datos)
```

```
##    a a imputed2
## 1 NA 5        5
## 2  1 1        1
## 3 NA 5        5
## 4  6 6        6
## 5  1 1        1
## 6  8 8        8
```
