@bazar @venta
Feature: Venta Bazar

  Background:
    * def DbUtils = Java.type('apiTesting.java.utils.DbUtils')
    * def db = new DbUtils(dbConfig)
    * def validateVenta =
        """
          function (apiResponse, dbResponse, productosVentasQuery) {
            if(
              dbResponse[0].codigo_venta != apiResponse.codigo_venta ||
              dbResponse[0].fecha_venta.toString() != apiResponse.fecha_venta ||
              dbResponse[0].total != apiResponse.total ||
              dbResponse[0].id_cliente != apiResponse.un_cliente.id_cliente ||
              dbResponse[0].nombre != apiResponse.un_cliente.nombre ||
              dbResponse[0].apellido != apiResponse.un_cliente.apellido ||
              dbResponse[0].dni != apiResponse.un_cliente.dni
              ) return false;
              for(var j=0; j<apiResponse.lista_productos.length; j++){
                var k;
                for(k=0; k < productosVentasQuery.length; k++){
                  if(productosVentasQuery[k].codigo_venta==apiResponse.codigo_venta && productosVentasQuery[k].codigo_producto==apiResponse.lista_productos[j].codigo_producto){
                    break;
                  }
                }
                if(
                  apiResponse.lista_productos[j].codigo_producto != productosVentasQuery[k].codigo_producto ||
                  apiResponse.lista_productos[j].nombre != productosVentasQuery[k].nombre ||
                  apiResponse.lista_productos[j].marca != productosVentasQuery[k].marca ||
                  parseFloat(apiResponse.lista_productos[j].costo) != parseFloat(productosVentasQuery[k].costo) ||
                  parseInt(apiResponse.lista_productos[j].cantidad_disponible) != parseInt(productosVentasQuery[k].cantidad_disponible)
                  ) return false;
              }
            return true;
          }
        """

  @findAll      
  Scenario: Traer venta
    Given url bazarUrl
    And path traerVentasPath
    When method get
    Then status 200
    * print response
    * def ventasQuery = db.readRows("SELECT v.codigo_venta, v.fecha_venta, v.total, c.id_cliente, c.nombre, c.apellido, c.dni FROM bazar.venta v INNER JOIN bazar.cliente c ON v.id_cliente = c.id_cliente ORDER BY v.codigo_venta ASC")
    * print ventasQuery
    * print ventasQuery.length
    * def productosVentasQuery = db.readRows("SELECT vp.codigo_venta, p.codigo_producto, p.nombre, p.marca, p.costo, p.cantidad_disponible FROM bazar.venta_producto vp INNER JOIN bazar.producto p ON vp.codigo_producto = p.codigo_producto ORDER BY vp.codigo_venta ASC")
    * def validateVentas =
        """
          function (apiResponse, dbResponse, productosVentasQuery) {
            for(var i=0; i<apiResponse.length; i++){
              console.log(apiResponse[i]);
              if(
                dbResponse[i].codigo_venta != apiResponse[i].codigo_venta ||
                dbResponse[i].fecha_venta.toString() != apiResponse[i].fecha_venta ||
                dbResponse[i].total != apiResponse[i].total ||
                dbResponse[i].id_cliente != apiResponse[i].un_cliente.id_cliente ||
                dbResponse[i].nombre != apiResponse[i].un_cliente.nombre ||
                dbResponse[i].apellido != apiResponse[i].un_cliente.apellido ||
                dbResponse[i].dni != apiResponse[i].un_cliente.dni
                ) return false;
                for(var j=0; j<apiResponse[i].lista_productos.length; j++){
                  var k;
                  for(k=0; k < productosVentasQuery.length; k++){
                    if(productosVentasQuery[k].codigo_venta==apiResponse[i].codigo_venta && productosVentasQuery[k].codigo_producto==apiResponse[i].lista_productos[j].codigo_producto){
                      break;
                    }
                  }
                  if(
                    apiResponse[i].lista_productos[j].codigo_producto != productosVentasQuery[k].codigo_producto ||
                    apiResponse[i].lista_productos[j].nombre != productosVentasQuery[k].nombre ||
                    apiResponse[i].lista_productos[j].marca != productosVentasQuery[k].marca ||
                    parseFloat(apiResponse[i].lista_productos[j].costo) != parseFloat(productosVentasQuery[k].costo) ||
                    parseInt(apiResponse[i].lista_productos[j].cantidad_disponible) != parseInt(productosVentasQuery[k].cantidad_disponible)
                    ) return false;
                }
            }
            return true;
          }
        """
    * assert validateVentas(response, ventasQuery, productosVentasQuery)

  @findById
  Scenario: Traer venta por id
    * def ventaQuery = db.readRows("SELECT * FROM venta LIMIT 1")
    * print ventaQuery
    Given url bazarUrl
    And path traerVentasPath, ventaQuery[0].codigo_venta
    When method get
    Then status 200
    * print response
    * assert ventaQuery.length == 1
    * def ventasQuery = db.readRows("SELECT v.codigo_venta, v.fecha_venta, v.total, c.id_cliente, c.nombre, c.apellido, c.dni FROM bazar.venta v INNER JOIN bazar.cliente c ON v.id_cliente = c.id_cliente WHERE v.codigo_venta="+ventaQuery[0].codigo_venta)
    * print ventasQuery
    * def productosVentasQuery = db.readRows("SELECT vp.codigo_venta, p.codigo_producto, p.nombre, p.marca, p.costo, p.cantidad_disponible FROM bazar.venta_producto vp INNER JOIN bazar.producto p ON vp.codigo_producto = p.codigo_producto WHERE vp.codigo_venta="+ventaQuery[0].codigo_venta)
    * print productosVentasQuery
    * assert validateVenta(response, ventasQuery, productosVentasQuery)

  @findProductosVenta
  Scenario: Traer productos venta por codigo venta
    * def validateProductoVenta =
        """
          function (apiResponse, productosVentasQuery) {
            for(var i=0; i<apiResponse.length; i++){
              if(
                apiResponse[i].codigo_producto != productosVentasQuery[i].codigo_producto ||
                apiResponse[i].nombre != productosVentasQuery[i].nombre ||
                apiResponse[i].marca != productosVentasQuery[i].marca ||
                parseFloat(apiResponse[i].costo) != parseFloat(productosVentasQuery[i].costo) ||
                parseInt(apiResponse[i].cantidad_disponible) != parseInt(productosVentasQuery[i].cantidad_disponible)
                ) return false;
            }
            return true;
          }
        """
    * def ventaQuery = db.readRows("SELECT * FROM venta LIMIT 1")
    * print ventaQuery
    Given url bazarUrl
    And path traerProductosVentaPath, ventaQuery[0].codigo_venta
    When method get
    Then status 200
    * print response
    * def productosVentasQuery = db.readRows("SELECT vp.codigo_venta AS codigo_venta, p.codigo_producto, p.nombre, p.marca, p.costo, p.cantidad_disponible FROM bazar.venta_producto vp INNER JOIN bazar.producto p ON vp.codigo_producto = p.codigo_producto WHERE vp.codigo_venta="+ventaQuery[0].codigo_venta)
    * print productosVentasQuery
    * assert validateProductoVenta(response, productosVentasQuery)

  @reporteVentas
  Scenario: Traer reporte ventas por fecha
    * def ventaQuery = db.readRows("SELECT * FROM venta LIMIT 1")
    * print ventaQuery
    Given url bazarUrl
    And path traerReporteVentasFechaPath, ventaQuery[0].fecha_venta
    When method get
    Then status 200
    * print response
    * def reporteVentasQuery = db.readRows("SELECT COUNT(v.codigo_venta) AS cantidad_total_ventas, SUM(v.total) AS monto FROM bazar.venta v WHERE v.fecha_venta='"+ventaQuery[0].fecha_venta.toString()+"' GROUP BY v.fecha_venta")
    * print reporteVentasQuery
    * assert response.monto == reporteVentasQuery[0].monto
    * assert response.cantidad_total_ventas == reporteVentasQuery[0].cantidad_total_ventas

  @reporteMayorVenta
  Scenario: Traer reporte mayor venta
    Given url bazarUrl
    And path traerReporteMayorVentaPath
    When method get
    Then status 200
    * print response
    * def reporteVentaQuery = db.readRows("SELECT v.codigo_venta, v.total, c.nombre, c.apellido FROM bazar.venta v INNER JOIN bazar.cliente c ON v.id_cliente = c.id_cliente ORDER BY v.total DESC, v.codigo_venta ASC LIMIT 1")
    * print reporteVentaQuery
    * def productosVentaQuery = db.readRows("SELECT COUNT(vp.codigo_venta) AS cantidad_total_productos FROM bazar.venta_producto vp WHERE vp.codigo_venta='"+reporteVentaQuery[0].codigo_venta+"'")
    * print productosVentaQuery
    * assert response.codigo_venta == reporteVentaQuery[0].codigo_venta
    * assert parseFloat(response.total) == parseFloat(reporteVentaQuery[0].total)
    * assert response.cantidad_total_productos == productosVentaQuery[0].cantidad_total_productos
    * assert response.nombre_cliente == reporteVentaQuery[0].nombre
    * assert response.apellido_cliente == reporteVentaQuery[0].apellido

  @create
  Scenario: Crear venta
    * def randomStringGenerator = read("../js/utils/randomStringGenerator.js")
    * def randomNumberGenerator = read("../js/utils/randomNumberGenerator.js")
    * def randomNameCliente = randomStringGenerator(10)
    * def randomSurname = randomStringGenerator(10)
    * def randomDni = randomNumberGenerator(8)
    * def idCliente = randomNumberGenerator(4)
    * def randomNameProducto = randomStringGenerator(10)
    * def randomBrand = randomStringGenerator(10)
    * def randomCost = randomNumberGenerator(4)
    * def randomStock = randomNumberGenerator(3)
    * def idProducto = randomNumberGenerator(4)
    * def productoQuery = db.insertRows("INSERT INTO producto VALUES("+idProducto+", "+randomCost+", "+randomStock+", '"+randomBrand+"', '"+randomNameProducto+"')")
    * def clienteQuery = db.insertRows("INSERT INTO cliente VALUES("+idCliente+", '"+randomSurname+"', "+randomDni+", '"+randomNameCliente+"')")
    * def ventaRequest = 
      """
        {
            "lista_productos": [{"codigo_producto": #(idProducto)}],
            "un_cliente": {"id_cliente": #(idCliente)}
        }        
      """
    Given url bazarUrl
    And path crearVentaPath
    And request ventaRequest
    When method post
    Then status 201
    * print response
    * def ventasQuery = db.readRows("SELECT v.codigo_venta, v.fecha_venta, v.total, c.id_cliente, c.nombre, c.apellido, c.dni FROM bazar.venta v INNER JOIN bazar.cliente c ON v.id_cliente = c.id_cliente WHERE v.codigo_venta="+response.codigo_venta)
    * print ventasQuery
    * def productosVentasQuery = db.readRows("SELECT vp.codigo_venta AS codigo_venta, p.codigo_producto, p.nombre, p.marca, p.costo, p.cantidad_disponible FROM bazar.venta_producto vp INNER JOIN bazar.producto p ON vp.codigo_producto = p.codigo_producto WHERE vp.codigo_venta="+response.codigo_venta)
    * print productosVentasQuery
    * assert validateVenta(response, ventasQuery, productosVentasQuery)
    * def ventaListaProductosQuery = db.cleanDatatable("DELETE FROM venta_producto WHERE codigo_venta='"+response.codigo_venta+"'")
    * def ventaQuery = db.cleanDatatable("DELETE FROM venta WHERE codigo_venta='"+response.codigo_venta+"'")
    * def clienteQuery = db.cleanDatatable("DELETE FROM cliente WHERE id_cliente='"+idCliente+"'")
    * def productoQuery = db.cleanDatatable("DELETE FROM producto WHERE codigo_producto='"+idProducto+"'")
  
  @updateStock
  Scenario: Actualizar stock productos
    * def randomStringGenerator = read("../js/utils/randomStringGenerator.js")
    * def randomNumberGenerator = read("../js/utils/randomNumberGenerator.js")
    * def randomNameCliente = randomStringGenerator(10)
    * def randomSurname = randomStringGenerator(10)
    * def randomDni = randomNumberGenerator(8)
    * def idCliente = randomNumberGenerator(4)
    * def randomNameProducto = randomStringGenerator(10)
    * def randomBrand = randomStringGenerator(10)
    * def randomCost = randomNumberGenerator(4)
    * def randomStock = randomNumberGenerator(3)
    * def idProducto = randomNumberGenerator(4)
    * def productoQuery = db.insertRows("INSERT INTO producto VALUES("+idProducto+", "+randomCost+", "+randomStock+", '"+randomBrand+"', '"+randomNameProducto+"')")
    * def clienteQuery = db.insertRows("INSERT INTO cliente VALUES("+idCliente+", '"+randomSurname+"', "+randomDni+", '"+randomNameCliente+"')")
    * def venta1 = call read('venta.feature@custom'){idProducto: #(idProducto), idCliente: #(idCliente)}
    * def venta2 = call read('venta.feature@custom'){idProducto: #(idProducto), idCliente: #(idCliente)}
    * assert venta1.response.lista_productos[0].cantidad_disponible == (venta2.response.lista_productos[0].cantidad_disponible + 1)
    * def ventaListaProductosQuery = db.cleanDatatable("DELETE FROM venta_producto WHERE codigo_venta='"+venta1.response.codigo_venta+"'")
    * def ventaQuery = db.cleanDatatable("DELETE FROM venta WHERE codigo_venta='"+venta1.response.codigo_venta+"'")
    * def ventaListaProductosQuery = db.cleanDatatable("DELETE FROM venta_producto WHERE codigo_venta='"+venta2.response.codigo_venta+"'")
    * def ventaQuery = db.cleanDatatable("DELETE FROM venta WHERE codigo_venta='"+venta2.response.codigo_venta+"'")
    * def clienteQuery = db.cleanDatatable("DELETE FROM cliente WHERE id_cliente='"+idCliente+"'")
    * def productoQuery = db.cleanDatatable("DELETE FROM producto WHERE codigo_producto='"+idProducto+"'")

  @delete
  Scenario: Borrar venta
    * def randomStringGenerator = read("../js/utils/randomStringGenerator.js")
    * def randomNumberGenerator = read("../js/utils/randomNumberGenerator.js")
    * def randomNameCliente = randomStringGenerator(10)
    * def randomSurname = randomStringGenerator(10)
    * def randomDni = randomNumberGenerator(8)
    * def idCliente = randomNumberGenerator(4)
    * def randomNameProducto = randomStringGenerator(10)
    * def randomBrand = randomStringGenerator(10)
    * def randomCost = randomNumberGenerator(4)
    * def randomStock = randomNumberGenerator(3)
    * def idProducto = randomNumberGenerator(4)
    * def productoQuery = db.insertRows("INSERT INTO producto VALUES("+idProducto+", "+randomCost+", "+randomStock+", '"+randomBrand+"', '"+randomNameProducto+"')")
    * def clienteQuery = db.insertRows("INSERT INTO cliente VALUES("+idCliente+", '"+randomSurname+"', "+randomDni+", '"+randomNameCliente+"')")
    * def venta = call read('venta.feature@custom'){idProducto: #(idProducto), idCliente: #(idCliente)}
    * def codigoVenta = venta.response.codigo_venta
    Given url bazarUrl
    And path borrarVentasPath, codigoVenta
    When method delete
    Then status 200

    * def ventaQuery = db.readRows("SELECT * FROM venta WHERE codigo_venta='"+codigoVenta+"'")
    * assert ventaQuery.length == 0

  @edit
  Scenario: Editar venta
    * def randomStringGenerator = read("../js/utils/randomStringGenerator.js")
    * def randomNumberGenerator = read("../js/utils/randomNumberGenerator.js")
    * def randomNameCliente = randomStringGenerator(10)
    * def randomSurname = randomStringGenerator(10)
    * def randomDni = randomNumberGenerator(8)
    * def idCliente = randomNumberGenerator(4)
    * def randomNameProducto = randomStringGenerator(10)
    * def randomBrand = randomStringGenerator(10)
    * def randomCost = randomNumberGenerator(4)
    * def randomStock = randomNumberGenerator(3)
    * def idProducto = randomNumberGenerator(4)
    * def productoQuery = db.insertRows("INSERT INTO producto VALUES("+idProducto+", "+randomCost+", "+randomStock+", '"+randomBrand+"', '"+randomNameProducto+"')")
    * def clienteQuery = db.insertRows("INSERT INTO cliente VALUES("+idCliente+", '"+randomSurname+"', "+randomDni+", '"+randomNameCliente+"')")
    * def venta = call read('venta.feature@custom'){idProducto: #(idProducto), idCliente: #(idCliente)}
    * def randomNameCliente = randomStringGenerator(10)
    * def randomSurname = randomStringGenerator(10)
    * def randomDni = randomNumberGenerator(8)
    * def idCliente = randomNumberGenerator(4)
    * def randomNameProducto = randomStringGenerator(10)
    * def randomBrand = randomStringGenerator(10)
    * def randomCost = randomNumberGenerator(4)
    * def randomStock = randomNumberGenerator(3)
    * def idProducto = randomNumberGenerator(4)
    * def productoQuery = db.insertRows("INSERT INTO producto VALUES("+idProducto+", "+randomCost+", "+randomStock+", '"+randomBrand+"', '"+randomNameProducto+"')")
    * def clienteQuery = db.insertRows("INSERT INTO cliente VALUES("+idCliente+", '"+randomSurname+"', "+randomDni+", '"+randomNameCliente+"')")
    * def ventaRequest = 
      """
        {
            "lista_productos": [{"codigo_producto": #(idProducto)}],
            "un_cliente": {"id_cliente": #(idCliente)}
        }        
      """
    Given url bazarUrl
    And path editarVentasPath, venta.response.codigo_venta
    And request ventaRequest
    When method put
    Then status 200
    * print response
    * def ventasQuery = db.readRows("SELECT v.codigo_venta, v.fecha_venta, v.total, c.id_cliente, c.nombre, c.apellido, c.dni FROM bazar.venta v INNER JOIN bazar.cliente c ON v.id_cliente = c.id_cliente WHERE v.codigo_venta="+response.codigo_venta)
    * print ventasQuery
    * def productosVentasQuery = db.readRows("SELECT vp.codigo_venta AS codigo_venta, p.codigo_producto, p.nombre, p.marca, p.costo, p.cantidad_disponible FROM bazar.venta_producto vp INNER JOIN bazar.producto p ON vp.codigo_producto = p.codigo_producto WHERE vp.codigo_venta="+response.codigo_venta)
    * print productosVentasQuery
    * assert validateVenta(response, ventasQuery, productosVentasQuery)
    * def ventaListaProductosQuery = db.cleanDatatable("DELETE FROM venta_producto WHERE codigo_venta='"+response.codigo_venta+"'")
    * def ventaQuery = db.cleanDatatable("DELETE FROM venta WHERE codigo_venta='"+response.codigo_venta+"'")
    * def clienteQuery = db.cleanDatatable("DELETE FROM cliente WHERE id_cliente='"+idCliente+"'")
    * def productoQuery = db.cleanDatatable("DELETE FROM producto WHERE codigo_producto='"+idProducto+"'")

  @custom @ignore
  Scenario: Crear venta por parametro
    * def ventaRequest = 
      """
        {
            "lista_productos": [{"codigo_producto": #(idProducto)}],
            "un_cliente": {"id_cliente": #(idCliente)}
        }        
      """
    Given url bazarUrl
    And path crearVentaPath
    And request ventaRequest
    When method post
    Then status 201
    * print response
