require 'trait'

class Module
  def uses(trait)
    trait.includeIn(self)
  end
end

class MiClase
  uses MiTrait

  def metodo2(sufijo)
    "mundo" + sufijo
  end

  # method_missing(name, *args, &block)
end

class MiClase2
  def metodo1
    "chau"
  end

  uses MiTrait
end

class MiClase3
    uses MiTrait + MiOtroTrait
end

class MiClaseConConflictos
  uses MiTrait + SoloDiceChau  # Debería lanzar una excepción
end

class MiClaseSinConflictos
  uses MiTrait + MiTrait # No debería lanzar una excepción, es equivalente a usar MiTrait
end

class TodoBienTodoLegal
  uses MiTrait + (SoloDiceChau - :metodo1)
end

#esta clase se crea solo para probar que se borran los metodos de las clases
class BorraTodoLosMetodos
  uses SoloDiceChau - [:metodo1, :metodo2]
end

class BorraTodoLosMetodosSinLista
  uses SoloDiceChau - :metodo1 - :metodo2
end

# Para poder resolverlo se tuvo q agregar un parentesis de más para separar la funcionalidad de Alias '<<' con la de remover '-'.
# Porque si no al ejecutarlo daba error de que la Clase Hash no conoce al metodo '-'.
class ConAlias
  uses ((MiTrait << {metodo1: :m1Hola}) - :metodo1) +
      ((SoloDiceChau << {metodo1: :m1Chau}) - :metodo1)

  def metodo1
    m1Hola + " y " + m1Chau
  end
end

class MiClaseConConflictosResueltosConPrimeraEstretegia
  uses MiTrait.+ SoloDiceChau, 1
end

class MiClaseConConflictosResueltosConSegundaEstretegia
  uses MiTrait.+ SoloDiceChau, 2
end

class MiClaseConConflictosResueltosConTercerEstrategia
  uses MiTrait.+ SoloDiceChau, 3, proc { |a, b| a + b }
end

class MiClaseConConflictosResueltosConTercerEstrategiaUpcase
  uses MiTrait.+ SoloDiceChau, 3, proc { |a, b| a.upcase + b.upcase }
end

class MiClaseConConflictosResueltosConTercerEstrategiaMax
  uses MiTrait.+ SoloDiceChau, 3, proc { |a,b|
    a.length > b.length ? a : b }
end

class MiClaseConConflictosResueltosConTercerEstrategiaLongitudDeMax
  uses MiTrait.+ SoloDiceChau, 3, proc { |a,b|
    a.length >= b.length ? a.length : b.length }
end
