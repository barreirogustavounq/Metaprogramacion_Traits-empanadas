require 'trait'

class Module
  def uses(trait)
    trait.instance_methods.each do | name |
      unless self.method_defined? name
        self.send(:define_method, name) do | *args, &block |
          trait.instance_method(name).bind(self).call(*args, &block)
        end
      end
    end
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

# class MiClase3
  # include MiTrait
  # include MiOtroTrait
    # uses MiTrait + MiOtroTrait
# end

# class MiClaseConConflictos
  # include MiTrait
  # include SoloDiceChau
  # uses MiTrait + SoloDiceChau  # Debería lanzar una excepción
# end

# class MiClaseSinConflictos
  # include MiTrait
  # include MiTrait
  # uses MiTrait + MiTrait # No debería lanzar una excepción, es equivalente a usar MiTrait
# end

# class TodoBienTodoLegal
  # include MiTrait
  # alias_method :metodo1_MiTrait, :metodo1

  # include SoloDiceChau
  # alias_method :metodo1_SoloDiceChau, :metodo1

  # def metodo1
  #   if MiTrait.method_defined? __callee__
  #     metodo1_MiTrait
  #   elsif SoloDiceChau.method_defined? __callee__
  #     metodo1_SoloDiceChau
  #   end
  # end
  #
  # def metodo2
  #   if MiTrait.method_defined? __callee__
  #     metodo1_MiTrait
  #   elsif SoloDiceChau.method_defined? __callee__
  #     metodo1_SoloDiceChau
  #   end
  # end

  # TODO: Corregir para refactorizar
  # def obtenerMetodoConConflictoEntreDosTraits
  #   res = ""
  #   if MiTrait.method_defined? __callee__
  #     res =  metodo1_MiTrait
  #   elsif SoloDiceChau.method_defined? __callee__
  #     res = metodo1_SoloDiceChau
  #   end
  #   return res
  # end
  # uses MiTrait + (SoloDiceChau - :metodo1)
# end
#
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