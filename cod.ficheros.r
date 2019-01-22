
`bookdown::render_book("index.Rmd", "bookdown::gitbook")`
' bookdown::render_book("index.Rmd","bookdown::tufte_html_book")'

# código para renombrar ficheros quitando espacios en blanco
## cambia el nombre de los files en un directorio
## crea código para insertar enlacer html a documentos
################################################################
getwd() # "C:/R/proyectos/INFORMES/talave"
ruta<-"C:/R/proyectos/INFORMES/talave/imag"
setwd(ruta)
#Cambiar espacio por _ en los nombres de ficheros de un directorio
imagenes<-list.files(ruta,pattern =".jpg", ignore.case=T)

#imagenes<-list.files("./imgjun2017/",pattern = ".jpg")
imagenes
length(imagenes)
limpia<- function (x) gsub('([[:punct:]])|\\s+','_',x);
limpian<- function (x) gsub('ñ','n',x);

## tiene que haber un directorio dentro llamado /imag
## donde se encuentren las imagenes
setwd(ruta)
#setwd(paste(ruta,"/imag",sep=""))
## Código para cambiar el nombre de los ficheros de un directorio
## eliminando espacios en blanco

for (i in seq_along(imagenes)){
    a<-limpia(substring(imagenes[i],1,nchar(imagenes[i])-4))
    a<-limpian(a)
    a<- paste(a,".pdf", sep = "")
    file.rename(imagenes[i],a)# cambia el nombre de  a 2
}


################################################################

################################################################
ruta<-"C:/R/proyectos/INFORMES/talave/docs/docu"
setwd(ruta)
getwd()
imagenes<-list.files(ruta,pattern = ".pdf", ignore.case = T)
# abro un fichero donde guardo el código
sink("imagenes.rmd") #abro la conexion con el fichero
cat("# cod para insertar listado de enlaces en markdown")
cat("\n") #salto de linea
## Empieza la figura

# hago un loop para todas las subfiguras
for (i in seq_along(imagenes)){
    #i<-1
    nom<- substring(imagenes[i],1,nchar(imagenes[i])-4)
    #nom
    #line<-paste("![", nom," \\label{fig_", i , "}](imgjun2017/", imagenes[i] ,")", sep="")
    line<-paste("  * [", nom,"](docu/", imagenes[i] ,")", sep="")
    #line
    cat(line)
    cat("\n")
}

sink()# cierro la conexion




## crea código para insertar enlacer html a documentos
##################################################
# Opcion con link en otro tab
imagenes<-list.files(ruta,pattern = ".pdf", ignore.case = T)
# abro un fichero donde guardo el código
sink("imagenes.rmd") #abro la conexion con el fichero
cat("# cod para insertar listado de enlaces en markdown")
cat("\n") #salto de linea
# hago un loop para todas las subfiguras
for (i in seq_along(imagenes)){
    #i<-1
    nom<- substring(imagenes[i],1,nchar(imagenes[i])-4) # quita expension
    line<-paste0("  * <a href=./docu/", nom, ".pdf target='_blank'>",nom," </a>")
    #line
    cat(line)
    cat("\n")
}
sink()# cierro la conexion






#write(line,file="figurasLatex.tex",append=TRUE)
fecha<-Sys.Date()
write("% NUEVO ANEXO FOTOGRAFICO",file="figurasLatex.tex",append=FALSE)
write(paste("% fer",fecha,sep=""),file="figurasLatex.tex",append=TRUE)
## Empieza la figura
line<-"\\begin{figure}[h] \\centering"
write(line,file="figurasLatex.tex",append=TRUE)
# hago un loop para todas las subfiguras

for (i in seq_along(imagenes)){
    line<-""
    line<-paste(line,"\\subfigure[",imagenes[i],"]{\\includegraphics[width=0.45\\linewidth]{imag/", imagenes[i],"}}", sep="")
    write(line,file="figurasLatex.tex",append=TRUE)

    if(i%%2==0){ write("\\\\",file="figurasLatex.tex",append=TRUE)}
}

write("\\caption{figuras}\\label{fig.fig1}",file="figurasLatex.tex",append=TRUE)
write("\\end{figure}",file="figurasLatex.tex",append=TRUE)



## pasar una palabra a cod criptografico
library(digest)

pasa_cripto <- function(palabra){
      algos <- c("md5","sha1","crc32","sha256","sha512","xxhash32","xxhash64","murmur32")
        for (i in seq_along(algos)){
          print(paste(algos[i],":  ",digest(palabra, algo=algos[i], serialize=FALSE)))
        }
      }

pasa_cripto("meso")
