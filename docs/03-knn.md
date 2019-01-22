# k-NN (k-Nearest Neighbour Classification) {#knn}
El algoritmo *k-NN* reconoce patrones en los datos sin un aprendizaje específico, simplemente midiendo la distancia entre grupos de datos. Se trata de uno de los algoritmos más simples y robustos de aprendizaje automático.

En realidad el algoritmo puede usarse tanto para clasificar como para pronosticar mediante regresión, pero aquí veremos solo la forma de clasificación.

Para usarlos necesitamos cargar el paquete `class` y usar la función `knn()`que realiza la **clasificación**. La idea subyacente es que a partir de un conjunto de datos de entrenamiento se pueda deducir un criterio de agrupamiento de los datos.

Es un algoritmo muy simple de implementar y de entrenar, pero tienen una carga computacional elevada y no es apropiado cuando se tienen muchos grados de libertad.

## Consideraciones previas
Como se calcula la similitud con respecto a la distancia, debemos tener en mente que las distancias entre variables deben ser comparables. Si usamos un rango de medida en una variable y otro muy distinto en otra, las distancias no están normalizadas y estaremos comparando peras con manzanas.

Para realizar un análisis con **knn** tenemos siempre de normalizar los datos, re-escalar todas las variables para que las distancias sean equiparables. Este proceso se suele llamar: *estandarización de los datos*.

Otro importante asunto es que hay que eliminar los NA de los datos, pues afectan a los cálculos de distancia.

Por último, como se indicó antes, este modelo es válido solo para casos con pocas dimensiones en los datos, pocos grados de libertad. Cuando se incrementa la dimensión espacial de los datos, la complejidad y el cálculo se hacen inviables.


## Ejemplo
Vamos a hacer un ejemplo sencillo de clasificación con unos datos inventados: Imaginemos que un profesor ha anotado durante el curso los siguientes datos de los alumnos:

 - nota del trabajo de clase del primer trimestre.
 - nota del examen 1º evaluación.
 - interés mostrado en clase por cada alumno al final del curso(1=máximo, 2=medio,3= mínimo)
 
Con estos datos ha confeccionado una tabla.


```r
# vamos a crear el ejemplo de cero:
tabla_alumnos<-data.frame(trabajo=c(10,4,6,7,7,6,8,9,2,5,6,5,3,2,2,1,8,9,2,7))
tabla_alumnos$examen<- c(9,5,6,7,8,7,6,9,1,5,7,6,2,1,5,5,9,10,4,6)
# interes en la clase 1 = max 3 = min interes
tabla_alumnos$interes<- c(1,2,1,1,1,2,2,1,3,3,3,2,3,3,2,2,1,1,3,3)
str(tabla_alumnos)
```

```
## 'data.frame':	20 obs. of  3 variables:
##  $ trabajo: num  10 4 6 7 7 6 8 9 2 5 ...
##  $ examen : num  9 5 6 7 8 7 6 9 1 5 ...
##  $ interes: num  1 2 1 1 1 2 2 1 3 3 ...
```

```r
# A priori parece que los alumnos que tuvieron una nota mayor
# el la prmera evaluación, fueron los que al final tuvieron más interes en clase
aggregate(examen ~ interes, data = tabla_alumnos, mean)
```

```
##   interes   examen
## 1       1 8.285714
## 2       2 5.666667
## 3       3 3.714286
```

```r
# Cargamos el paquete class' que contienen la funcion knn
library(class)

head(tabla_alumnos)
```

```
##   trabajo examen interes
## 1      10      9       1
## 2       4      5       2
## 3       6      6       1
## 4       7      7       1
## 5       7      8       1
## 6       6      7       2
```

```r
# Creamos un vector de eiquetas
# este vector coincidirá con la variable de interes del alumno

# Classificamos la proxima señal que cuyos datos se almacenan en next_sign
nuevo_alumno<-data.frame(trabajo=c(2,9),examen=c(3,8))

# modelo de prediciión
prono1<-knn(train = tabla_alumnos[-c(3)], test = nuevo_alumno, cl = tabla_alumnos$interes)
prono1
```

```
## [1] 3 1
## Levels: 1 2 3
```

```r
# en otros ejemplo puede ser interesante incrementa el numero de vecinos que se analizan con el parametro k
knn(train = tabla_alumnos[-c(3)], test = nuevo_alumno, cl = tabla_alumnos$interes, k = 4)
```

```
## [1] 3 1
## Levels: 1 2 3
```

## Estandarización
Para otros casos en los que las variables no tengan la misma escala, es preferible para mejorar el modelo normalizar las columnas de datos numéricos.

Esto puede hacerse con muchas funciones predefinidas como por ejemplo la función `scale()` o `data.Normalization()` esta del paquete *clusterSim*.

Hay que tener en cuenta que cuando normalizamos los valores de hechos que pasamos a `predict()`, deben ser normalizados con el mismo algoritmo.


```r
# normalizamos la tabla de datos
    tabla_alumnos.nor<-scale(tabla_alumnos)
    str(tabla_alumnos.nor)
```

```
##  num [1:20, 1:3] 1.659 -0.529 0.201 0.565 0.565 ...
##  - attr(*, "dimnames")=List of 2
##   ..$ : NULL
##   ..$ : chr [1:3] "trabajo" "examen" "interes"
##  - attr(*, "scaled:center")= Named num [1:3] 5.45 5.9 2
##   ..- attr(*, "names")= chr [1:3] "trabajo" "examen" "interes"
##  - attr(*, "scaled:scale")= Named num [1:3] 2.743 2.553 0.858
##   ..- attr(*, "names")= chr [1:3] "trabajo" "examen" "interes"
```

```r
# extraemos los atributos de centro y scala de la transformación
    attr(tabla_alumnos.nor,"scaled:center")
```

```
## trabajo  examen interes 
##    5.45    5.90    2.00
```

```r
    attr(tabla_alumnos.nor, "scaled:scale")
```

```
##   trabajo    examen   interes 
## 2.7429335 2.5526044 0.8583951
```

```r
# Transformamos un una nota examen de 9 para pronostico porterior
# es la  2 col
    nota.t<-scale(9, 
                  attr(tabla_alumnos.nor,"scaled:center")[2],
                  attr(tabla_alumnos.nor, "scaled:scale")[2])
    
    nota.t # valor de nota exam =9 transformado
```

```
##          [,1]
## [1,] 1.214446
## attr(,"scaled:center")
## examen 
##    5.9 
## attr(,"scaled:scale")
##   examen 
## 2.552604
```
