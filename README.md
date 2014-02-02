Receptes de Cuina
==============

Programa per gestionar un conjunt de receptes de cuina.

Les receptes
------------
Cada recepta està formada per:
* Un __títol__, per identificar-la
* Una __descripció__, per resumir què és.
* Una llista d'__ingredients__. Cada ingredient inclou per:
  * Una descripció
  * Un número per ordenar-lo dins la llista d'ingredients
* Una llista de __passes d'elaboració__. Cada passa inclou:
  * Una descripció
  * Un número per ordenar-la dins la resta de passes

Features
--------

* Crear receptes.
* Cercar per títol sense distingir majúscules i minúscules
* Afegir ingredients a una recepta, esborrar-los i modificar-ne la descripció.
* Afegir passes d'elaboració a una recepta, esborrar-les i modificar-ne la descripció.

Mancances
---------
* A les receptes ja creades, no es poden editar el títol ni la descripció.
* Tampoc no es poden esborrar.
* No es poden reordenar la llista d'ingredients ni la llista de passes d'elaboració.
* En el moment d'eliminar ingredients o passes, no es demana confirmació.

Pantalla principal
------------------
La pantalla principal és la llista de receptes que hi ha emmagatzemades dins la base de dades. Inicialment no n'hi ha cap.

Què es pot fer?
* Cercar receptes. En el requadre superior es poden escriure paraules per fer una cerca de receptes sense distingir majúscules i minúscules. Els resultats es mostren a la llista inferior
* Crear una recepta. Es pot fer de dues maneres: o bé directament sobre el botó que apareix o bé fent una cerca i anant al final dels resultats.
* Mostrar els detalls d'una recepta

Visualització de receptes
-------------------------
A aquesta pantalla s'hi accedeix des de la pantalla principal fent clic a qualsevol de les receptes, ja sigui des de la llista directament o després d'haver fet una cerca. També s'hi accedeix quan s'ha creat una recepta.

Es mostren la llista d'ingredients i la llista de passes d'elaboració.

Opcions que es poden realitzar:
* Clicant o fent «tap» sobre el darrer element de les llistes d'ingredients o de passes d'elaboració, s'obren uns diàlegs incrustats per afegir nous ingredients o noves passes.
* Clicant o fent «tap» sobre ingredients o passes que ja hi ha a les llistes, també s'obre un diàleg incrustat per modificar-ne la descripció.
* Fent un clic llarg «press and hold» sobre ingredients o passes, s'eliminen directament aquests elements, sense preguntar confirmació.

Errors coneguts
---------------
Les actualitzacions esborren la base de dades completament. Per tant, abans de procedir a actualitzar l'aplicació, convé fer-ne una còpia de seguretat a través de la pantalla Backup.

Imatges
-------
* [Olla de cocció](http://pixabay.com/es/olla-de-cocci%C3%B3n-cook-ware-cocina-159470/) Llicència Public Domain CC0
