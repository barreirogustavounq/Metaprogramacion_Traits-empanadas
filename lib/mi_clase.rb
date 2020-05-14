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

# Por ahora se eligio la resolución de conflictos definida en el primer item de Estrategias de resolución del enunciado.
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
  uses SoloDiceChau - :metodo1 -:metodo2
end

# class ConAlias
#   include MiTrait
#   alias_method :metodo1_MiTrait, :metodo1
#
#   include SoloDiceChau
#   alias_method :metodo1_SoloDiceChau, :metodo1
#   uses
  # (MiTrait << {metodo1: :m1Hola} - :metodo1) +
  #   (SoloDiceChau << {metodo1: :m1Chau} - :metodo1)
  #
  # def metodo1
  #   m1Hola + " y " + m1Chau
    # metodo1_MiTrait + " y " + metodo1_SoloDiceChau
  # end
# end
#