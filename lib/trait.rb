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

  def cuartaEstrategiaDeResolucionDeConflictos(otroTrait, condicion)
    nuevoTrait = self.clone

    otroTrait.instance_methods.each do | method |
      if nuevoTrait.method_defined? method
        if self != otroTrait
          metodoNuevoTrait = nuevoTrait.instance_method(method).bind(self).call
          metodoOtroTrait = otroTrait.instance_method(method).bind(self).call
          if metodoNuevoTrait == condicion
            nuevoTrait.send(:define_method, method, nuevoTrait.instance_method(method))
          else
            if metodoOtroTrait == condicion
              nuevoTrait.send(:define_method, method, otroTrait.instance_method(method))
            else
              nuevoTrait.send(:define_method, method, proc{ raise(StandardError)})
            end
          end
        else
          nuevoTrait.send(:define_method, method, otroTrait.instance_method(method))
        end
      end
    end
    nuevoTrait
  end

  def resolucionConConflictos(otroTrait)
    nuevoTrait = self.clone
    otroTrait.instance_methods.each do | method |
      if nuevoTrait.method_defined? method
        if self != otroTrait
          nuevoTrait.remove_method(method)
        end
      else
        nuevoTrait.send(:define_method, method, otroTrait.instance_method(method))
      end
    end
    nuevoTrait
  end

  public
  def + (otroTrait, estrategia = nil, funcion = nil, condicion = nil)
    case estrategia
    when 1
      primeraEstrategiaResolucionDeConflictos(otroTrait)
    when 2
      segundaEstrategiaResolucionDeConflictos(otroTrait)
    when 3
      terceraEstrategiaDeResolucionDeConflictos(otroTrait, &funcion)
    when 4
      cuartaEstrategiaDeResolucionDeConflictos(otroTrait, condicion)
    else
      resolucionConConflictos(otroTrait)
    end
  end

  public
  def - (element)
  nuevoTrait = self.clone
  trait_Methods = nuevoTrait.instance_methods
  if element.class == Array
    element.each do |mtd|
      if trait_Methods.include? mtd
        nuevoTrait.remove_method(mtd)
      end
    end
  else
    if trait_Methods.include? element
      nuevoTrait.remove_method(element)
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