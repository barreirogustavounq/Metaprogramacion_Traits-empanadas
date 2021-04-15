require './lib/estrategias_de_resolucion_de_conflictos/estrategia_de_resolucion_de_conflictos.rb'

class ResolucionDeConflictosQueAplicaCondicion < EstrategiaDeResolucionDeConflictos
  attr_accessor :funcion

  def initialize(funcion)
    @funcion = funcion
  end

  def resolverConflictos(unTrait, otroTrait)
    condicion = @funcion
    resolucionDeConflictos = proc do | method, nuevoTrait, metodoNuevoTrait, metodoOtroTrait |
      metodoQueCoincide = [metodoNuevoTrait.call, metodoOtroTrait.call].find &condicion
      if metodoQueCoincide
        bloque = proc {metodoQueCoincide}
        nuevoTrait.send(:define_method, method, bloque)
      else
        raise StandardError, 'Ningún método coincide'
      end
    end

    super(unTrait, otroTrait, &resolucionDeConflictos)
  end
end