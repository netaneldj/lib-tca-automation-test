@ignore
Feature: Cliente Bazar

  Background:
    * def DbUtils = Java.type('com.todocodeacademy.util.DbUtils')
    * def db = new DbUtils(dbConfig)

  Scenario: Validate Database assertion
   # insert test data into database
    * def query = db.readRows("SELECT * FROM producto")
    * print query

