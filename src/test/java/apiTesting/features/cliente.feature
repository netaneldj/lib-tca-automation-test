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
    And path traerClientesPath
    When method get
    Then status 200
    * print response
    * def clienteQuery = db.readRows("SELECT * FROM cliente")
    * print clienteQuery
    * assert response.length == clienteQuery.length
    * assert valid(response, clienteQuery)

  Scenario: Traer cliente por id
    * def clienteQuery = db.readRows("SELECT * FROM cliente LIMIT 1")
    * print clienteQuery
    Given url bazarUrl
    And path traerClientesPath, clienteQuery[0].id_cliente
    When method get
    Then status 200
    * print response
    * assert response.length == clienteQuery.length
    * assert valid(response, clienteQuery)

