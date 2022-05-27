function fn() {
  var env = karate.env; // get java system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev'; // a custom 'intelligent' default
  }
  var config = { // base config JSON
    dbConfig: { username: 'admin', password: 'admin', url: 'jdbc:mysql://localhost:3306/bazar', driverClassName: 'com.mysql.jdbc.Driver' },
    bazarUrl : 'http://localhost:8080',
    traerProductosPath: 'productos/traer'
  };
  // don't waste time waiting for a connection or if servers don't respond within 5 seconds
  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 5000);
  return config;
}