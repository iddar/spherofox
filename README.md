spherofox
=========

Controla el robot sphero desde una amigable aplicacion para FirefoxOS.

Este proyecto se divide en dos partes que deben construirce por separado.
Para arrarcar el proyecto como tenemos que instalar las dependencias del proyecto.

```sh
$ git clone https://github.com/iddar/spherofox.git
$ cd shperofox
$ cd client-connect 
$ npm install
$ cd ..
$ cd server-socket
# npm install -g express coffee-script
$ npm install
```

Con esto tendremos lista las apps para ser puestas en marcha. Debemos correr la aplicacion en terminales individuales para poder observar el log.

Recomiedo el uso de nodemon.

```sh
# npm install -g nodemon
$ nodemon client-connect/index.js
$ nodemon server-socket/app.coffee
```

------

`Esta applicación se a probado en MacOS 10.8.4 y en Windows 8`