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

  @create
  Scenario: Crear cliente
    * def randomStringGenerator = read("../js/utils/randomStringGenerator.js")
    * def randomNumberGenerator = read("../js/utils/randomNumberGenerator.js")
    * def randomName = randomStringGenerator(10)
    * def randomSurname = randomStringGenerator(10)
    * def randomDni = randomNumberGenerator(8)
    * def clienteRequest =
        """
          {
            "nombre": "#(randomName)",
            "apellido": "#(randomSurname)",
            "dni": #(randomDni)
          }
        """
    * print clienteRequest
    Given url bazarUrl
    And path crearClientesPath
    And request clienteRequest
    When method post
    Then status 200
    * print response
    * def clienteQuery = db.readRows("SELECT * FROM cliente WHERE id_cliente='"+response.id_cliente+"'")
    * print clienteQuery
    * assert clienteQuery.length == 1
    * assert clienteRequest.nombre == response.nombre
    * assert clienteRequest.apellido == response.apellido
    * assert clienteRequest.dni == response.dni
    * assert clienteRequest.nombre == clienteQuery[0].nombre
    * assert clienteRequest.apellido == clienteQuery[0].apellido
    * assert clienteRequest.dni == clienteQuery[0].dni
    * def clienteQuery = db.cleanDatatable("DELETE FROM cliente WHERE id_cliente='"+response.id_cliente+"'")

