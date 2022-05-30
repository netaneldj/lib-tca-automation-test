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

  Scenario: Traer productos
    Given url bazarUrl
    And path traerProductosPath
    When method get
    Then status 200
    * print response
    * def query = db.readRows("SELECT * FROM producto")
    * print query
    * assert response.length == query.length
    * assert valid(response, query)

