@bazar @producto
Feature: Producto Bazar

  Background:
    * def DbUtils = Java.type('apiTesting.java.utils.DbUtils')
    * def db = new DbUtils(dbConfig)
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

  @traer      
  Scenario: Traer productos
    Given url bazarUrl
    And path traerProductosPath
    When method get
    Then status 200
    * print response
    * def productoQuery = db.readRows("SELECT * FROM producto")
    * print productoQuery
    * assert response.length == productoQuery.length
    * assert valid(response, productoQuery)

  Scenario: Traer producto por id
    * def productoQuery = db.readRows("SELECT * FROM producto LIMIT 1")
    * print productoQuery
    Given url bazarUrl
    And path traerClientesPath, productoQuery[0].codigo_producto
    When method get
    Then status 200
    * print response
    * assert response.length == productoQuery.length
    * assert valid(response, productoQuery)

