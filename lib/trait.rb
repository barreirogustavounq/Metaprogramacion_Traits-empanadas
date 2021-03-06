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
        resolucionDeConflictos.(method, nuevoTrait)
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
    resolucionDeConflictos = proc do | method, nuevoTrait |
      if self != otroTrait
        nuevoTrait.instance_method(method).bind(self).call
        nuevoTrait.send(:define_method, method, otroTrait.instance_method(method))
      end
    end

    definirMetodo otroTrait, &resolucionDeConflictos
  end

  public
  def terceraEstrategiaDeResolucionDeConflictos(otroTrait, &funcion)
    resolucionDeConflictos = proc do | method, nuevoTrait |
      if self != otroTrait
        metodoNuevoTrait = nuevoTrait.instance_method(method).bind(self).call
        metodoOtroTrait = otroTrait.instance_method(method).bind(self).call
        fold = [metodoNuevoTrait, metodoOtroTrait].inject &funcion
        methodFold = proc {fold}
        nuevoTrait.send(:define_method, method, methodFold)
      end
    end

    definirMetodo otroTrait, &resolucionDeConflictos
  end

  def cuartaEstrategiaDeResolucionDeConflictos(otroTrait, &comparador)
    resolucionDeConflictos = proc do | method, nuevoTrait |
      if self != otroTrait
        metodoNuevoTrait = nuevoTrait.instance_method(method).bind(self).call
        metodoOtroTrait = otroTrait.instance_method(method).bind(self).call
        metodoQueCoincide = [metodoNuevoTrait, metodoOtroTrait].find &comparador
        if metodoQueCoincide
          bloque = proc {metodoQueCoincide}
          nuevoTrait.send(:define_method, method, bloque)
        else
          nuevoTrait.send(:define_method, method, proc{ raise(StandardError)})
        end
      end
    end

    definirMetodo otroTrait, &resolucionDeConflictos
  end

  def resolucionConConflictos(otroTrait)
    resolucionDeConflictos = proc do | method, nuevoTrait |
      nuevoTrait.remove_method(method) if self != otroTrait
    end

    definirMetodo otroTrait, &resolucionDeConflictos
  end

  public
  def + (otroTrait, estrategia = nil, funcion = nil, comparador = nil)
    case estrategia
    when 1
      primeraEstrategiaResolucionDeConflictos(otroTrait)
    when 2
      segundaEstrategiaResolucionDeConflictos(otroTrait)
    when 3
      terceraEstrategiaDeResolucionDeConflictos(otroTrait, &funcion)
    when 4
      cuartaEstrategiaDeResolucionDeConflictos(otroTrait, &comparador)
    else
      resolucionConConflictos(otroTrait)
    end
  end

  public
  def - (element)
    nuevoTrait = self.clone
    trait_Methods = nuevoTrait.instance_methods
    unless element.respond_to? 'each'
      element = [element]
    end
    element.each do |mtd|
      if trait_Methods.include? mtd
        nuevoTrait.remove_method(mtd)
      end
    end
    nuevoTrait
  end

  public
  def << (hash)
    nuevoTrait = self.clone
    old_name = hash.keys[0]
    new_name = hash[old_name]
    nuevoTrait.alias_method new_name, old_name
    nuevoTrait
  end
end