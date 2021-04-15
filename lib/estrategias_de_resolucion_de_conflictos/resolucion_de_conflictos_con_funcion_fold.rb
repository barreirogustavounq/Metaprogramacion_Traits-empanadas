require './lib/estrategias_de_resolucion_de_conflictos/estrategia_de_resolucion_de_conflictos.rb'

class ResolucionDeConflictosConFuncionFold < EstrategiaDeResolucionDeConflictos
  attr_accessor :funcion

  def initialize(funcion)
    @funcion = funcion
  end

  def resolverConflictos(unTrait, otroTrait)
    funcionFold = @funcion
    resolucionDeConflictos = proc do | method, nuevoTrait, metodoNuevoTrait, metodoOtroTrait |
      fold = proc { funcionFold.(metodoNuevoTrait.call, metodoOtroTrait.call) }
      nuevoTrait.send(:define_method, method, fold)
    end

    super(unTrait, otroTrait, &resolucionDeConflictos)
  end
end