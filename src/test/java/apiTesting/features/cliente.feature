@bazar @cliente
Feature: Cliente Bazar

  Background:
    * def DbUtils = Java.type('apiTesting.java.utils.DbUtils')
    * def db = new DbUtils(dbConfig)

  @findAll
  Scenario: Traer clientes
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
    Given url bazarUrl
    And path traerClientesPath
    When method get
    Then status 200
    * print response
    * def clienteQuery = db.readRows("SELECT * FROM cliente")
    * print clienteQuery
    * assert response.length == clienteQuery.length
    * assert valid(response, clienteQuery)

  @findById
  Scenario: Traer cliente por id
    * def valid =
        """
          function (apiResponse, dbResponse) {
            for(var i=0; i<dbResponse.length; i++){
              if(
                dbResponse[i].id_cliente != apiResponse.id_cliente ||
                dbResponse[i].nombre != apiResponse.nombre ||
                dbResponse[i].apellido != apiResponse.apellido ||
                dbResponse[i].dni != apiResponse.dni
                ) return false;
            }
            return true;
          }
        """
    * def clienteQuery = db.readRows("SELECT * FROM cliente LIMIT 1")
    * print clienteQuery
    Given url bazarUrl
    And path traerClientesPath, clienteQuery[0].id_cliente
    When method get
    Then status 200
    * print response
    * assert clienteQuery.length == 1
    * assert valid(response, clienteQuery)

