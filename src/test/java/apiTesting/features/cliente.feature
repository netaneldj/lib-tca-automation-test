@ignore
Feature: Cliente Bazar

  Background:
    * def DbUtils = Java.type('apiTesting.java.utils.DbUtils')
    * def db = new DbUtils(dbConfig)

  Scenario: Validate Database assertion
   # insert test data into database
    * def query = db.readRows("SELECT * FROM producto")
    * print query

