class Trait < Module

  def includeIn(klass)
    self.instance_methods.each do | method |
      unless klass.method_defined? method
        klass.send(:define_method, method, self.instance_method(method))
      end
    end
  end

  public
  def primeraEstrategiaResolucionDeConflictos(otroTrait)
   nuevoTrait = self.clone

   otroTrait.instance_methods.each do | method |
     unless nuevoTrait.method_defined? method
       nuevoTrait.send(:define_method, method, otroTrait.instance_method(method) )
     end
   end
   nuevoTrait
  end

  public
  def segundaEstrategiaResolucionDeConflictos(otroTrait)
   nuevoTrait = self.clone

   otroTrait.instance_methods.each do | method |
     if nuevoTrait.method_defined? method
       if self != otroTrait
         nuevoTrait.instance_method(method).bind(self).call
         nuevoTrait.send(:define_method, method, otroTrait.instance_method(method))
       end
     else
       nuevoTrait.send(:define_method, method, otroTrait.instance_method(method) )
     end
   end
   nuevoTrait
  end

  public
  def terceraEstrategiaDeResolucionDeConflictos(otroTrait, &funcion)
    nuevoTrait = self.clone

    otroTrait.instance_methods.each do | method |
      if nuevoTrait.method_defined? method
        if self != otroTrait
          metodoNuevoTrait = nuevoTrait.instance_method(method).bind(self).call
          metodoOtroTrait = otroTrait.instance_method(method).bind(self).call
          fold = [metodoNuevoTrait, metodoOtroTrait].inject &funcion
          methodFold = proc {fold}
          nuevoTrait.send(:define_method, method, methodFold)
        end
      else
        nuevoTrait.send(:define_method, method, otroTrait.instance_method(method))
      end
    end
    nuevoTrait
  end

  def cuartaEstrategiaDeResolucionDeConflictos(otroTrait, &comparador)
    nuevoTrait = self.clone
    otroTrait.instance_methods.each do | method |
      if nuevoTrait.method_defined? method
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
      else
        nuevoTrait.send(:define_method, method, otroTrait.instance_method(method))
      end
    end
    nuevoTrait
  end

  def resolucionConConflictos(otroTrait)
    nuevoTrait = self.clone
    otroTrait.instance_methods.each do | method |
      if nuevoTrait.method_defined? method
        nuevoTrait.remove_method(method) if self != otroTrait
      else
        nuevoTrait.send(:define_method, method, otroTrait.instance_method(method))
      end
    end
    nuevoTrait
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