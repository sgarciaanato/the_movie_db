1). El último WIP fue intentar implementar OHHTTPStubs, no logré hacer mock de la respuesta del endpoint principal, luego de hacer el mock evaluar si el modelo del presentador encargado de guardar la respuesta del endpoint de películas tiene los datos que están en el archivo de test `MovieList_Mock.json`.

2). Luego de eso replicar esa prueba para los otros presentadores.

3). Ajustar el Activity Indicator para formar parte de la vista del tableView, buscando que cuando se muestre cambiar el contentInset al fondo de la tabla para ajustarse al tamaño y mostrar que se está cargando mas, de esa manera como se están cargadno antes de llegar al fondo de la lista el indicator no sería visible muchas de las veces y parecería una lista infinita.

4). Ordenar los archivos convirtiendo en private las variables que no se usar fuera de la clase y no están declaradas como private

5). Ordenar las variables de una manera mas entendible, con mejor espaciado entre líneas.
