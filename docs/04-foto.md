# FOTOGRAFÍAS

Se muestran fotografías de las actuaciones, tanto durante las obras como de las visitas realizadas en fase de  explotación.

## Túnel


```r
knitr::include_graphics("imag/20151118_095058.jpg")
```

<img src="imag/20151118_095058.jpg" width="682" />

## Balsa


```r
knitr::include_graphics("imag/20151118_095137.jpg")
```

<img src="imag/20151118_095137.jpg" width="50%" />

## OTROS TRUCOS
que hay que leer aquí
<https://www.zevross.com/blog/2017/06/19/tips-and-tricks-for-working-with-images-and-figures-in-r-markdown-documents/>


```r
# pintamos todas las imagenes
library(knitr)
myimages<-list.files("imag/", pattern = ".jpg", full.names = TRUE)
include_graphics(myimages)
```

<img src="imag/20151118_095058.jpg" width="30%" /><img src="imag/20151118_095137.jpg" width="30%" /><img src="imag/20151118_095151.jpg" width="30%" /><img src="imag/20151118_102505.jpg" width="30%" /><img src="imag/20151118_102617.jpg" width="30%" /><img src="imag/20151118_102621.jpg" width="30%" /><img src="imag/20151118_102626.jpg" width="30%" /><img src="imag/20151118_102710.jpg" width="30%" /><img src="imag/20151118_102928.jpg" width="30%" /><img src="imag/20151118_103019.jpg" width="30%" /><img src="imag/20151118_104655.jpg" width="30%" /><img src="imag/20151118_104658.jpg" width="30%" /><img src="imag/20151118_104736.jpg" width="30%" /><img src="imag/20151118_104811.jpg" width="30%" /><img src="imag/20151118_104830.jpg" width="30%" />

Este libro ha sido escrito en R, si quieres iniciarte en R mira [@R-Fer].
