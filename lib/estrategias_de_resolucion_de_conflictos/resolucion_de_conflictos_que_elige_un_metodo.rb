require './lib/estrategias_de_resolucion_de_conflictos/estrategia_de_resolucion_de_conflictos.rb'

class ResolucionDeConflictosQueEligeUnMetodo < EstrategiaDeResolucionDeConflictos
  def resolverConflictos(unTrait, otroTrait, &funcion)
    resolucionDeConflictos = proc {}
    super(unTrait, otroTrait, &resolucionDeConflictos)
  end
end