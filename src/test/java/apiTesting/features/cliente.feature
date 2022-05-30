@bazar @cliente
Feature: Cliente Bazar

  Background:
    * def DbUtils = Java.type('apiTesting.java.utils.DbUtils')
    * def db = new DbUtils(dbConfig)
    * def valid =
        """
          function (apiResponse, dbResponse) {
            for(var i=0; i<dbResponse.length; i++){
              if(
                dbResponse[i].id_cliente != apiResponse[i].id_cliente ||
                dbResponse[i].nombre != apiResponse[i].nombre ||
                dbResponse[i].apellido != apiResponse[i].apellido ||
                dbResponse[i].dni != apiResponse[i].dni
                ) return false;
            }
            return true;
          }
        """

  Scenario: Traer clientes
    Given url bazarUrl
    And path traerProductosPath
    When method get
    Then status 200
    * print response
    * def query = db.readRows("SELECT * FROM producto")
    * print query
    * assert response.length == query.length
    * assert valid(response, query)

