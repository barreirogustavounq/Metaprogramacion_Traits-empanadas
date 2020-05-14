class Trait < Module
  def initialize(&block)
    super(&block)
  end

  def includeIn(klass)
    self.instance_methods.each do | method |
      unless klass.method_defined? method
        klass.send(:define_method, method, self.instance_method(method))
      end
    end
  end

  public
  def + (otroTrait)
    nuevoTrait = self.clone

    otroTrait.instance_methods.each do | method |
      unless nuevoTrait.method_defined? method
        nuevoTrait.send(:define_method, method, otroTrait.instance_method(method))
      end
    end
    nuevoTrait
  end

  public
  def - (method)
    method_string = method.to_s
    nuevoTrait = self.clone
    trait_Methods = nuevoTrait.instance_methods

    if trait_Methods.include? method_string
      nuevoTrait.send(:remove_method, method_string, nuevoTrait.instance_method(method_string))
    end
    nuevoTrait
  end
end

def trait (nombre, &block)
  el_trait = Trait.new(&block)
  Object.const_set(nombre, el_trait)
end

trait :MiTrait do
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