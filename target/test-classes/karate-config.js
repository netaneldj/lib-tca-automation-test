function fn() {
	var env = karate.env; // get java system property 'karate.env'
	karate.log('karate.env system property was:', env);
	if (!env) {
		env = 'dev'; // a custom 'intelligent' default
	}
	var config = { // base config JSON
		dbConfig: { username: 'admin', password: 'admin', url: 'jdbc:mysql://localhost:3306/bazar', driverClassName: 'com.mysql.jdbc.Driver' },
		bazarUrl : 'http://localhost:8080',
		traerProductosPath: 'productos/traer',
		traerClientesPath: 'clientes/traer',
		traerVentasPath: 'ventas/traer',
		traerProductosVentaPath: 'ventas/productos',
		traerReporteVentasFechaPath: 'ventas',
		traerReporteMayorVentaPath: 'ventas/mayor_venta',
		crearClientesPath: 'clientes/crear',
		crearProductosPath: 'productos/crear',
		crearVentaPath: 'ventas/crear',
		borrarClientesPath: 'clientes/borrar',
		editarClientesPath: 'clientes/editar',
		borrarProductoPath: 'productos/borrar',
		editarProductosPath: 'productos/editar',
		editarVentasPath: 'ventas/editar',
		borrarVentasPath: 'ventas/borrar'
	  };
	// don't waste time waiting for a connection or if servers don't respond within 5 seconds
	karate.configure('connectTimeout', 5000);
	karate.configure('readTimeout', 5000);
	karate.configure('logPrettyRequest', true);
	karate.configure('logPrettyResponse', true);
	karate.configure('report', { showLog: true, showAllSteps: false });
	karate.configure('responseHeaders', { 'Content-Type': 'application/json', Accept: 'application/json' });
	return config;
}