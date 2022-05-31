@bazar @venta
Feature: Venta Bazar

  Background:
    * def DbUtils = Java.type('apiTesting.java.utils.DbUtils')
    * def db = new DbUtils(dbConfig)

  @findAll      
  Scenario: Traer ventas
    * def validateVenta =
        """
          function (apiResponse, dbResponse) {
            for(var i=0; i<dbResponse.length; i++){
              if(
                dbResponse[i].codigo_venta != apiResponse[i].codigo_venta ||
                dbResponse[i].fecha_venta.toString() != apiResponse[i].fecha_venta ||
                dbResponse[i].total != apiResponse[i].total ||
                dbResponse[i].id_cliente != apiResponse[i].unCliente.id_cliente ||
                dbResponse[i].nombre != apiResponse[i].unCliente.nombre ||
                dbResponse[i].apellido != apiResponse[i].unCliente.apellido ||
                dbResponse[i].dni != apiResponse[i].unCliente.dni
                ) return false;
            }
            return true;
          }
        """
    Given url bazarUrl
    And path traerVentasPath
    When method get
    Then status 200
    * print response
    * def ventaQuery = db.readRows("SELECT v.codigo_venta, v.fecha_venta, v.total, c.id_cliente, c.nombre, c.apellido, c.dni FROM venta v INNER JOIN cliente c ON v.un_cliente_id_cliente = c.id_cliente")
    * print ventaQuery
    * assert response.length == ventaQuery.length
    * assert validateVenta(response, ventaQuery)

  @findById
  Scenario: Traer venta por id
    * def valid =
        """
          function (apiResponse, dbResponse) {
            for(var i=0; i<dbResponse.length; i++){
              if(
                dbResponse[i].codigo_venta != apiResponse.codigo_venta ||
                dbResponse[i].fecha_venta.toString() != apiResponse.fecha_venta ||
                dbResponse[i].total != apiResponse.total
                ) return false;
            }
            return true;
          }
        """
    * def ventaQuery = db.readRows("SELECT * FROM venta LIMIT 1")
    * print ventaQuery
    Given url bazarUrl
    And path traerVentasPath, ventaQuery[0].codigo_venta
    When method get
    Then status 200
    * print response
    * assert ventaQuery.length == 1
    * assert valid(response, ventaQuery)


