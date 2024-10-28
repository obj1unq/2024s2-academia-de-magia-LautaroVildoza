/** Reemplazar por la solución del enunciado */
class Cosa {
	const property marca
	const property volumen
	const property esElementoMagico
	const property esReliquia
}

class Academia {
  const property muebles

  method estaGuardado(cosa) {
	return muebles.any({mueble => mueble.estaAca(cosa)})
  }

  method enQueMuebleEsta(cosa) {
	self.validarSiEsta(cosa)
	return muebles.filter({mueble => mueble.estaAca(cosa)})
  }

  method validarSiEsta(cosa) {
	if(!self.estaGuardado(cosa)){
		self.error("La cosa"+ cosa +"no esta en ningun mueble.")
	}
  }
  
}

class Mueble {
	const property pertenencias 

	method guardar(cosa){
		self.validarGuardar(cosa)
		pertenencias.add(cosa)
	}

	method estaAca(cosa) {
	  return pertenencias.contains(cosa)
	}
	method validarGuardar(cosa)
}

class Armario inherits Mueble() {
	const property cantidadMax 
   override method validarGuardar(cosa) {
		if(pertenencias.size() == cantidadMax and pertenencias.contains(cosa)){
			self.error("No se puede guardar!")
		}
  }
}

class GabineteMagico inherits Mueble() {
  override method validarGuardar(cosa){
	if (cosa.esElementoMagico() and pertenencias.contains(cosa)){
		self.error("No se puede guardar!")
	}
  }
}

class Baul inherits Mueble() {
	const property capacidadMax 

  override method validarGuardar(cosa){
	if(cosa.volumen() + pertenencias.sum({cosa.volumen()}) > capacidadMax and pertenencias.contains(cosa)){
		self.error("No se puede guardar!")
	}
  }
}


//Marcas
object Fenix {}
object Cuchuflito {}
object Acme {}