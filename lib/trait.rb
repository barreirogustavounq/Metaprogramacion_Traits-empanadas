class Trait < Module

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
  def primeraEstrategiaResolucionDeConflictos(otroTrait)
    resolucionDeConflictos = proc {}
    definirMetodo(otroTrait, &resolucionDeConflictos)
  end

  public
  def segundaEstrategiaResolucionDeConflictos(otroTrait)
    resolucionDeConflictos = proc do | method, nuevoTrait, metodoNuevoTrait, metodoOtroTrait |
      metodosSegundaResolucion = proc do
        metodoNuevoTrait.call
        metodoOtroTrait
      end
      nuevoTrait.send(:define_method, method, metodosSegundaResolucion.call)
    end

    definirMetodo otroTrait, &resolucionDeConflictos
  end

  public
  def terceraEstrategiaDeResolucionDeConflictos(otroTrait, &funcion)
    resolucionDeConflictos = proc do | method, nuevoTrait, metodoNuevoTrait, metodoOtroTrait |
      fold = proc { funcion.(metodoNuevoTrait.call, metodoOtroTrait.call) }
      nuevoTrait.send(:define_method, method, fold)
    end

    definirMetodo otroTrait, &resolucionDeConflictos
  end

  def cuartaEstrategiaDeResolucionDeConflictos(otroTrait, &comparador)
    resolucionDeConflictos = proc do | method, nuevoTrait, metodoNuevoTrait, metodoOtroTrait |
      metodoQueCoincide = [metodoNuevoTrait.call, metodoOtroTrait.call].find &comparador
      if metodoQueCoincide
        bloque = proc {metodoQueCoincide}
        nuevoTrait.send(:define_method, method, bloque)
      else
        raise StandardError, 'Ningún método coincide'
      end
    end

    definirMetodo otroTrait, &resolucionDeConflictos
  end

  def quintaEstrategiaDeResolucionDeConflictos(otroTrait, &funcionDelUsuario)
    estrategiaDelUsuario = proc do | method, nuevoTrait, metodoNuevoTrait, metodoOtroTrait |
      metodoqueCoincide = funcionDelUsuario.(metodoNuevoTrait.call, metodoOtroTrait.call)
      if metodoqueCoincide
        bloque = proc { metodoqueCoincide }
        nuevoTrait.send(:define_method, method, bloque)
      end
    end
     definirMetodo otroTrait, &estrategiaDelUsuario
  end

  def resolucionConConflictos(otroTrait)
    resolucionDeConflictos = proc do
      raise StandardError, 'Conflictos entre métodos con mismo nombre.'
    end

    definirMetodo otroTrait, &resolucionDeConflictos
  end

  public
  def + (otroTrait, estrategia = nil, funcion = nil)
    case estrategia
    when 1
      primeraEstrategiaResolucionDeConflictos(otroTrait)
    when 2
      segundaEstrategiaResolucionDeConflictos(otroTrait)
    when 3
      terceraEstrategiaDeResolucionDeConflictos(otroTrait, &funcion)
    when 4
      cuartaEstrategiaDeResolucionDeConflictos(otroTrait, &funcion)
    when 5
      quintaEstrategiaDeResolucionDeConflictos(otroTrait, &funcion)
    else
      resolucionConConflictos(otroTrait)
    end
  end

  public
  def - (element)
    nuevoTrait = self.clone
    trait_Methods = nuevoTrait.instance_methods
    [*element].each do |mtd|
      if trait_Methods.include? mtd
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