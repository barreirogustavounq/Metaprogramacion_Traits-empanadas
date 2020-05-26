require './lib/estrategias_de_resolucion_de_conflictos/resolucion_tira_excepcion.rb'
require './lib/estrategias_de_resolucion_de_conflictos/resolucion_de_conflictos_que_elige_un_metodo.rb'
require './lib/estrategias_de_resolucion_de_conflictos/resolucion_de_conflictos_en_orden_de_aparicion.rb'
require './lib/estrategias_de_resolucion_de_conflictos/resolucion_de_conflictos_con_funcion_fold.rb'
require './lib/estrategias_de_resolucion_de_conflictos/resolucion_de_conflictos_que_aplica_condicion.rb'
require './lib/estrategias_de_resolucion_de_conflictos/resolucion_de_conflictos_definida_por_el_usuario.rb'

class Trait < Module
  def initialize(nombre_del_trait)
    @nombre = nombre_del_trait
    @metodos = Hash.new
  end

  def agregarMetodo(nombre_metodo, &bloque)
    @metodos[nombre_metodo] = bloque
  end

  def iliminarMetodo(nombre_metodo)
    @metodos.delete(nombre_metodo)
  end

  def methodos()
    @metodos
  end

  def includeIn(klass)
    self.instance_methods.each do | method |
      unless klass.method_defined? method
        klass.send(:define_method, method, self.instance_method(method))
      end
    end
  end

  def definirMetodo(otroTrait, &resolucionDeConflictos)
    nuevoTrait = self.clone

    otroTrait.instance_methods.each do | method |
      unless nuevoTrait.method_defined? method
        nuevoTrait.send(:define_method, method, otroTrait.instance_method(method) )
      else
        metodoNuevoTrait = nuevoTrait.instance_method(method).bind(self)
        metodoOtroTrait = otroTrait.instance_method(method).bind(self)
        if metodoNuevoTrait.source_location != metodoOtroTrait.source_location
          resolucionDeConflictos.(method, nuevoTrait, metodoNuevoTrait, metodoOtroTrait)
        end
      end
    end
    nuevoTrait
  end

  public
  def + (otroTrait, estrategia = nil)
    if estrategia
      estrategia.resolverConflictos(self, otroTrait)
    else
      ResolucionTiraExcepcion.new.resolverConflictos(self, otroTrait)
    end
  end

  public
  def - (element)
    nuevoTrait = self.clone
    trait_Methods = nuevoTrait.instance_methods
    [*element].each do |mtd|
      if trait_Methods.include? mtd
        nuevoTrait.iliminarMetodo(mtd)
        nuevoTrait.remove_method(mtd)
      end
    end
    nuevoTrait
  end

  public
  def << (hash)
    nuevoTrait = self.clone
    hash.each do | old_name, new_name |
      nuevoTrait.alias_method new_name, old_name
    end
    nuevoTrait
  end
end