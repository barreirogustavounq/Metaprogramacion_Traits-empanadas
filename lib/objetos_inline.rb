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

def trait(&definicion_del_trait)
  nuevo_trait = Trait.new
  nuevo_trait.module_eval(&definicion_del_trait)
  nuevo_trait
end