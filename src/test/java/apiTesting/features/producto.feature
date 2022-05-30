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

  @create
  Scenario: Crear Producto
    * def randomStringGenerator = read("../js/utils/randomStringGenerator.js")
    * def randomNumberGenerator = read("../js/utils/randomNumberGenerator.js")
    * def randomName = randomStringGenerator(10)
    * def randomBrand = randomStringGenerator(10)
    * def randomCost = randomNumberGenerator(4)
    * def randomStock = randomNumberGenerator(3)
    * def productoRequest =
        """
          {
              "nombre": "#(randomName)",
              "marca": "#(randomBrand)",
              "costo": #(randomCost),
              "cantidad_disponible": #(randomStock)
          }
        """
    * print productoRequest
    Given url bazarUrl
    And path crearProductosPath
    And request productoRequest
    When method post
    Then status 200
    * print response
    * def productoQuery = db.readRows("SELECT * FROM producto WHERE codigo_producto='"+response.codigo_producto+"'")
    * print productoQuery
    * assert productoQuery.length == 1
    * assert productoRequest.nombre == response.nombre
    * assert productoRequest.marca == response.marca
    * assert productoRequest.costo == response.costo
    * assert productoRequest.cantidad_disponible == response.cantidad_disponible
    * assert productoRequest.nombre == productoQuery[0].nombre
    * assert productoRequest.marca == productoQuery[0].marca
    * assert productoRequest.costo == productoQuery[0].costo
    * assert productoRequest.cantidad_disponible == productoQuery[0].cantidad_disponible
    * def clienteQuery = db.cleanDatatable("DELETE FROM producto WHERE codigo_producto='"+response.codigo_producto+"'")

