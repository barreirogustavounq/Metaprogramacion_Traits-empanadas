def trait (nombre, &block)
  el_trait = Module.new(&block)
  Object.const_set(nombre, el_trait)
end

module MiTrait
  def metodo1
    "hola"
  end
end

module MiOtroTrait
  def metodo2
    "mundo"
  end
end

trait :SoloDiceChau do
  def metodo1
    "chau"
  end

  def metodo2
    "chau"
  end
end

# module SoloDiceChau
#   def metodo1
#     "chau"
#   end
#
#   def metodo2
#     "chau"
#   end
# end
#
# self.trait(:MiTrait) do
#   def metodo1
#     "hola"
#   end
# end