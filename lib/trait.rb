def trait (nombre, &block)
  el_trait = Module.new(&block)
  Object.const_set(nombre, el_trait)
end

trait :MiTrait do
  # @metodo1 = Proc.new do
  #   "hola"
  # end

  def metodo1
    "hola"
  end
end

trait :MiOtroTrait do
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