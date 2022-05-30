@bazar @producto
Feature: Producto Bazar

  Background:
    * def DbUtils = Java.type('apiTesting.java.utils.DbUtils')
    * def db = new DbUtils(dbConfig)

  @findAll      
  Scenario: Traer productos
    * def valid =
        """
          function (apiResponse, dbResponse) {
            for(var i=0; i<dbResponse.length; i++){
              if(
                dbResponse[i].codigo_producto != apiResponse[i].codigo_producto ||
                dbResponse[i].cantidad_disponible != apiResponse[i].cantidad_disponible ||
                dbResponse[i].costo != apiResponse[i].costo ||
                dbResponse[i].marca != apiResponse[i].marca || 
                dbResponse[i].nombre != apiResponse[i].nombre
                ) return false;
            }
            return true;
          }
        """
    Given url bazarUrl
    And path traerProductosPath
    When method get
    Then status 200
    * print response
    * def productoQuery = db.readRows("SELECT * FROM producto")
    * print productoQuery
    * assert response.length == productoQuery.length
    * assert valid(response, productoQuery)

  @findById
  Scenario: Traer producto por id
    * def valid =
        """
          function (apiResponse, dbResponse) {
            for(var i=0; i<dbResponse.length; i++){
              if(
                dbResponse[i].codigo_producto != apiResponse.codigo_producto ||
                dbResponse[i].cantidad_disponible != apiResponse.cantidad_disponible ||
                dbResponse[i].costo != apiResponse.costo ||
                dbResponse[i].marca != apiResponse.marca || 
                dbResponse[i].nombre != apiResponse.nombre
                ) return false;
            }
            return true;
          }
        """
    * def productoQuery = db.readRows("SELECT * FROM producto LIMIT 1")
    * print productoQuery
    Given url bazarUrl
    And path traerProductosPath, productoQuery[0].codigo_producto
    When method get
    Then status 200
    * print response
    * assert productoQuery.length == 1
    * assert valid(response, productoQuery)

