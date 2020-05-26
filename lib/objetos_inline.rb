require 'trait'

class Class
  def uses(trait)
    trait.includeIn(self)
  end
end

def clase(&definicion_de_la_clase)
  nueva_clase = Class.new
  nueva_clase.class_eval(&definicion_de_la_clase)
  nueva_clase
end

def trait(nombre_del_trait, &cuerpo_del_trait)
  nuevo_trait = Trait.new(nombre_del_trait)
  nuevo_trait.class_eval(&cuerpo_del_trait)
  nuevo_trait.instance_methods(false).each do |method|
    nuevo_trait.agregarMetodo(method, &nuevo_trait.instance_method(method).bind(nuevo_trait))
  end
  puts nuevo_trait.instance_methods(false)
  puts nuevo_trait.methodos
  nuevo_trait
end