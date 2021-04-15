require './lib/estrategias_de_resolucion_de_conflictos/estrategia_de_resolucion_de_conflictos.rb'

class ResolucionDeConflictosEnOrdenDeAparicion < EstrategiaDeResolucionDeConflictos

  def resolverConflictos(unTrait, otroTrait, &funcion)
    resolucionDeConflictos = proc do | method, nuevoTrait, metodoNuevoTrait, metodoOtroTrait |
      metodosSegundaResolucion = proc do
        metodoNuevoTrait.call
        metodoOtroTrait
      end
      nuevoTrait.send(:define_method, method, metodosSegundaResolucion.call)
    end

    super(unTrait, otroTrait, &resolucionDeConflictos)
  end
end