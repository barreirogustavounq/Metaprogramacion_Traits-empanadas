class EstrategiaDeResolucionDeConflictos
  def resolverConflictos(unTrait, otroTrait, &resolucionDeConflictos)
    unTrait.definirMetodo otroTrait, &resolucionDeConflictos
  end
end