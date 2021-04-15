require './lib/estrategias_de_resolucion_de_conflictos/estrategia_de_resolucion_de_conflictos.rb'

class ResolucionDeConflictosDefinidaPorElUsuario < EstrategiaDeResolucionDeConflictos
  attr_accessor :funcion

  def initialize(funcion)
    @funcion = funcion
  end

  def resolverConflictos(unTrait, otroTrait, &funcion)
    funcionDelUsuario = @funcion
    estrategiaDelUsuario = proc do | method, nuevoTrait, metodoNuevoTrait, metodoOtroTrait |
      metodoqueCoincide = funcionDelUsuario.(metodoNuevoTrait.call, metodoOtroTrait.call)
      if metodoqueCoincide
        bloque = proc { metodoqueCoincide }
        nuevoTrait.send(:define_method, method, bloque)
      end
    end

    super(unTrait, otroTrait, &estrategiaDelUsuario)
  end
end