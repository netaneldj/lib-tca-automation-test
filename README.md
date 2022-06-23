# Bazar Web Service Testing With Karate

## Getting Started
- Java 8 or higher

- Maven 3.8.1 or higher

- Visual Studio Code

- Karate Runner Plugin

- Cucumber Plugin

## Commands
**Karate Runner -> Karate Jar: Command Line Args**

java -Dkarate.config.dir="src/test/java" -Dkarate.env=dev -cp "lib-tca-automation-test-0.0.1-SNAPSHOT-tests.jar;lib-tca-automation-test-0.0.1-SNAPSHOT-jar-with-dependencies.jar;karate.jar" com.intuit.karate.Main

**Command line runner**

mvn clean install -Dtag=@bazar

mvn test -Dtest=runners.CucumberRunner -Dkarate.env=dev -Dtag=@bazar

## Apendix
Karate Github https://github.com/intuit/karate
