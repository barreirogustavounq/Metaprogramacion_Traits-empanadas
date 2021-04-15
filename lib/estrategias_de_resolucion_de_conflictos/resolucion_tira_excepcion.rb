require './lib/estrategias_de_resolucion_de_conflictos/estrategia_de_resolucion_de_conflictos.rb'

class ResolucionTiraExcepcion < EstrategiaDeResolucionDeConflictos

  def resolverConflictos(unTrait, otroTrait, &funcion)
    resolucionDeConflictos = proc do
      raise StandardError, 'Conflictos entre métodos con mismo nombre.'
    end

    super(unTrait, otroTrait, &resolucionDeConflictos)
  end
end