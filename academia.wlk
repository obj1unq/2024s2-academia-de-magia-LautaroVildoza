/** Reemplazar por la solución del enunciado */
class Cosa {
	const property marca
	const property volumen
	const property esElementoMagico
	const property esReliquia

	method utilidad() {
	  return volumen + self.valorDeMagia() + self.valorDeReliquia() + marca.valor(self) 
	}

	method valorDeMagia() {
	  return if(esElementoMagico) 3 else 0
	}

	method valorDeReliquia() {
	  return if(esReliquia) 5 else 0
	}
}

class Academia {
  const property muebles

  method estaGuardado(cosa) {
	return muebles.any({mueble => mueble.estaAca(cosa)})
  }

  method enQueMuebleEsta(cosa) {
	self.validarSiEsta(cosa)
	return muebles.find({mueble => mueble.estaAca(cosa)})
  }

  method validarSiEsta(cosa) {
	if(!self.estaGuardado(cosa)){
		self.error("La cosa"+ cosa +"no esta en ningun mueble.")
	}
  }

  method puedeGuardase(cosa) {
	return !self.estaGuardado(cosa) && muebles.any({mueble => mueble.puedoGuardar(cosa)})
  }

  method mueblesDisponible(cosa) {
	return muebles.filter({m => m.puedoGuardar(cosa)})
  }

  method guardar(cosa) {
	self.validarGuardar(cosa)
	self.guardarEnMuebleDisponible(cosa)
  }

  method validarGuardar(cosa){
	if(not self.puedeGuardase(cosa)){
		self.error("No se puede guardar" + cosa)
	}
  }

  method guardarEnMuebleDisponible(cosa) {
	self.mueblesDisponible(cosa).anyOne().agregar(cosa)
  }

  method cosasMenosUtiles() {
	return muebles.map({m => m.cosaMenosUtil()})
  }

  method marcaMenosUtil() {
	return self.cosasMenosUtiles().min({c => c.utilidad()}).marca()
  }

  method removerCosaMenosUtilesQueNoSeanMagicas() {
	self.validarRemover()
	self.cosasMenosUtilesNoMagicas().forEach({c => self.remover(c)})
  }

 method cosasMenosUtilesNoMagicas() {
   return self.cosasMenosUtiles().filter({c => not c.esElementoMagico()})
 }
  method remover(cosa) {
	self.enQueMuebleEsta(cosa).remover(cosa)
  }

  method validarRemover() {
	if(muebles.size() < 3)
		self.error("No se puede remover!.")
  }
  
}

class Mueble {
	const property pertenencias 

	method agregar(cosa){
		pertenencias.add(cosa)
	}

	method estaAca(cosa) {
	  return pertenencias.contains(cosa)
	}

	method puedoGuardar(cosa) 

	method utilidad(){
		return self.utilidadDeCosas() / self.precio()
	}

	method utilidadDeCosas() {
	  return pertenencias.sum({c => c.utilidad()})
	}

	method precio()

	method cosaMenosUtil() {
	  return pertenencias.min({ c => c.utilidad()})
	}

	method remover(cosa) {
	  pertenencias.remove(cosa)
	}
}

class Armario inherits Mueble {
	var property cantidadMax 

  override method puedoGuardar(cosa) {
	return pertenencias.size() < cantidadMax and not pertenencias.contains(cosa)
  }

  override method precio(){
	return 5 * cantidadMax
  }
}

class GabineteMagico inherits Mueble {
	const property precio

  override method puedoGuardar(cosa) {
	return cosa.esElementoMagico() && not pertenencias.contains(cosa)
  }
}

class Baul inherits Mueble {
	const capacidadMax 
  
  override method puedoGuardar(cosa){
	return (cosa.volumen() + self.volumenTotal() < capacidadMax and not pertenencias.contains(cosa))
  }
	
  method volumenTotal() {
	return pertenencias.sum({cosa => cosa.volumen()})
  }

  override method precio(){
	return capacidadMax + 2
  }

  method extraTodasSonReliquias() {
	return if(self.sonTodasReliquias()) 2 else 0
  }

  method sonTodasReliquias(){
	return pertenencias.all({c => c.esReliquia()})
  }

	override method utilidad() {
		return super() + self.extra()
  }

  method extra() {
	return if(pertenencias.all({c => c.esReliquia()})) 2 else 0
  }
}

class BaulMagico inherits Baul {

  method cantidadDeCosasMagicas() {
	return pertenencias.count({ c => c.esElementoMagico()})
	
  }

  override method precio(){
	return super() * 2
  }

  override method utilidad() {
	return super() + self.cantidadDeCosasMagicas()
  }
}


//Marcas
object Fenix {
	method valor(cosa) {
	  return if(cosa.esReliquia()) 3 else 0
	}
}
object Cuchuflito {
	method valor(cosa){
		return 0
	}
}
object Acme {
	method valor(cosa){
		return cosa.volumen() / 2
	}
}