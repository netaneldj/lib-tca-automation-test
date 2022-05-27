Feature: Producto Bazar

  Background:
    * def DbUtils = Java.type('com.todocodeacademy.util.DbUtils')
    * def db = new DbUtils(dbConfig)

  Scenario: Traer productos
    Given url bazarUrl
    And path traerProductosPath
    When method get
    Then status 200
    * print response
    * def query = db.readRows("SELECT * FROM producto")
    * print query

