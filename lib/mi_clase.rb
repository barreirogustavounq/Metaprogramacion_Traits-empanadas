require 'trait'

class Module
  def uses(trait)
    trait.includeIn(self)
  end
end

def clase(&definicion_de_la_clase)
  nueva_clase = Class.new
  nueva_clase.class_eval(&definicion_de_la_clase)
  nueva_clase
end