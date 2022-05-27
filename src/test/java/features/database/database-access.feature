Feature: Database testing

  Background:
    # Create JDBC connection with DbUtils java class
    * def config = { username: 'admin', password: 'admin', url: 'jdbc:mysql://localhost:3306/bazar', driverClassName: 'com.mysql.jdbc.Driver' }
    * def DbUtils = Java.type('com.todocodeacademy.util.DbUtils')
    * def db = new DbUtils(config)

  Scenario: Validate Database assertion
   # insert test data into database
    * def query = db.readRows("SELECT * FROM producto")
    * print query

