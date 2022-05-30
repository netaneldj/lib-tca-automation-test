@bazar @venta
Feature: Venta Bazar

  Background:
    * def DbUtils = Java.type('apiTesting.java.utils.DbUtils')
    * def db = new DbUtils(dbConfig)
    * def valid =
        """
          function (apiResponse, dbResponse) {
            for(var i=0; i<dbResponse.length; i++){
              if(
                dbResponse[i].codigo_venta != apiResponse[i].codigo_venta ||
                dbResponse[i].fecha_venta.toString() != apiResponse[i].fecha_venta ||
                dbResponse[i].total != apiResponse[i].total
                ) return false;
            }
            return true;
          }
        """

  @traer      
  Scenario: Traer ventas
    Given url bazarUrl
    And path traerVentasPath
    When method get
    Then status 200
    * print response
    * def query = db.readRows("SELECT * FROM venta")
    * print query
    * assert response.length == query.length
    * assert valid(response, query)

