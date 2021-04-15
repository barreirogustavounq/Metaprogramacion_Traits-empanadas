require 'rspec'
require 'objetos_inline'

describe 'traits tests' do

  MiTrait = trait "MiTrait" do
    def metodo1
      "hola"
    end
  end

  OtroTrait = trait "OtroTrait" do
    def metodo1
      "hello"
    end
  end

  MiOtroTrait = trait "MiOtroTrait" do
    def metodo2
      "mundo"
    end
  end

  SoloDiceChau = trait "SoloDiceChau" do
    def metodo1
      "chau"
    end

    def metodo2
      "chau"
    end
  end

  Rompe = trait "Rompe" do
    def metodo1
      "rompe"
    end
  end

 it 'Agrego trait a una clase y obtengo los metodos de la clase resultante' do
   MiClase = clase do
     uses MiTrait

     def metodo2(sufijo)
       "mundo" + sufijo
     end
   end

   una_clase = MiClase.new
   expect(una_clase.metodo1).to eq("hola")
   expect(una_clase.metodo2('!')).to eq("mundo!")
 end

 it 'Agrego un trait y ambos tienen un metodo con el mismo nombre, quedando el metodo de la clase' do
   MiClase2 = clase do
     def metodo1
       "chau"
     end

     uses MiTrait
   end

   segunda_clase = MiClase2.new
   expect(segunda_clase.metodo1).to eq("chau")
 end

 it 'Agrego dos traits a una clase y verifico que se en encuentren los metodos de esos trait dentro de la clase ' do
   MiClase3 = clase do
     uses MiTrait + MiOtroTrait
   end
   tercer_clase = MiClase3.new
   expect(tercer_clase.metodo1).to eq("hola")
   expect(tercer_clase.metodo2).to eq("mundo")
 end

 it 'agrego dos traits dos veces a la clase' do
   MiClase3Doble = clase do
     uses MiTrait + MiOtroTrait + MiTrait + MiOtroTrait
   end

   tercer_clase = MiClase3Doble.new
   expect(tercer_clase.metodo1).to eq("hola")
   expect(tercer_clase.metodo2).to eq("mundo")
 end

  it 'agrego dos traits y segun la estrategia por defecto arroja un error' do

    expect { MiClaseConConflictos = clase do
      uses MiTrait + SoloDiceChau
    end}.to raise_error(StandardError, 'Conflictos entre métodos con mismo nombre.')
  end

  it 'agrego dos veces el mismo trait y wao equivale a agregar solo una vez el trait' do
    MiClaseSinConflictos = clase do
      uses MiTrait + MiTrait # No debería lanzar una excepción, es equivalente a usar MiTrait
    end

    mi_clase_sin_conflictos = MiClaseSinConflictos.new
    expect(mi_clase_sin_conflictos.metodo1).to eq("hola")
  end

 it 'Agrego dos traits diferentes incluidos en una clase usando ResolucionDeConflictosQueEligeUnMetodo' do
   MiClaseConConflictosResueltosConPrimeraEstretegia = clase do
     uses MiTrait.+ SoloDiceChau, ResolucionDeConflictosQueEligeUnMetodo.new
   end

   mi_clase_con_conflictos_estrategia_1 = MiClaseConConflictosResueltosConPrimeraEstretegia.new
   expect(mi_clase_con_conflictos_estrategia_1.metodo1).to eq("hola")
   expect(mi_clase_con_conflictos_estrategia_1.metodo2).to eq("chau")
 end

 it 'Agrego traits y los sumo con diferentes estrategias de resolicion de conflictos ' do
   MiClaseConConflictosResueltosConSegundaEstretegia = clase do
     uses (MiTrait.+ SoloDiceChau, ResolucionDeConflictosEnOrdenDeAparicion.new).+ OtroTrait, ResolucionDeConflictosEnOrdenDeAparicion.new
   end

   mi_clase_con_conflictos_estrategia_2 = MiClaseConConflictosResueltosConSegundaEstretegia.new
   expect(mi_clase_con_conflictos_estrategia_2.metodo1).to eq("hello")
   expect(mi_clase_con_conflictos_estrategia_2.metodo2).to eq("chau")
 end

 it 'Agrego dos traits diferentes incluidos en una clase usando ResolucionDeConflictosConFuncionFold utilizando la funcion suma' do
   suma = proc { |a, b| a + b }

   MiClaseConConflictosResueltosConTercerEstrategiaSuma = clase do
     uses MiTrait.+ SoloDiceChau, ResolucionDeConflictosConFuncionFold.new(suma)
   end

   mi_clase_con_conflictos_estrategia_3_suma = MiClaseConConflictosResueltosConTercerEstrategiaSuma.new
   expect(mi_clase_con_conflictos_estrategia_3_suma.metodo1).to eq("holachau")
   expect(mi_clase_con_conflictos_estrategia_3_suma.metodo2).to eq("chau")
 end

 it 'Agrego dos traits diferentes incluidos en una clase usando ResolucionDeConflictosConFuncionFold utilizando la funcion Suma y Upcase' do
   upcase = proc { |a, b| a.upcase + b.upcase }

   MiClaseConConflictosResueltosConTercerEstrategiaUpcase = clase do
     uses MiTrait.+ SoloDiceChau, ResolucionDeConflictosConFuncionFold.new(upcase)
   end

   mi_clase_con_conflictos_estrategia_3_suma_upcase = MiClaseConConflictosResueltosConTercerEstrategiaUpcase.new
   expect(mi_clase_con_conflictos_estrategia_3_suma_upcase.metodo1).to eq("HOLACHAU")
   expect(mi_clase_con_conflictos_estrategia_3_suma_upcase.metodo2).to eq("chau")
 end

 it 'Agrego dos traits diferentes incluidos en una clase usando ResolucionDeConflictosConFuncionFold utlizando funcion Max' do
   max = proc { |a,b| a.length > b.length ? a : b }

   MiClaseConConflictosResueltosConTercerEstrategiaMax = clase do
     uses MiTrait.+ SoloDiceChau, ResolucionDeConflictosConFuncionFold.new(max)
   end

   mi_clase_con_conflictos_estrategia_3_max = MiClaseConConflictosResueltosConTercerEstrategiaMax.new
   expect(mi_clase_con_conflictos_estrategia_3_max.metodo1).to eq("chau")
   expect(mi_clase_con_conflictos_estrategia_3_max.metodo2).to eq("chau")
 end

 it 'Agrego dos traits diferentes incluidos en una clase usando ResolucionDeConflictosConFuncionFold utilizando la funcion Longitud de Max' do
   longitudDeMax = proc { |a,b| a.length >= b.length ? a.length : b.length }

   MiClaseConConflictosResueltosConTercerEstrategiaLongitudDeMax = clase do
     uses MiTrait.+ SoloDiceChau, ResolucionDeConflictosConFuncionFold.new(longitudDeMax)
   end

   mi_clase_con_conflictos_estrategia_3_longitud_de_max = MiClaseConConflictosResueltosConTercerEstrategiaLongitudDeMax.new
   expect(mi_clase_con_conflictos_estrategia_3_longitud_de_max.metodo1).to be 4
   expect(mi_clase_con_conflictos_estrategia_3_longitud_de_max.metodo2).to eq("chau")
 end

 it 'Agrego dos traits diferentes incluidos en una clase usando ResolucionDeConflictosQueAplicaCondicion donde la condiciion es compara por igualdad' do
   'En este caso toma el metodo de MiTrait'
   compararPorIgualdad = proc { |a| a == "hola"}
   MiClaseConConflictosResueltosConCuartaEstretegiaCondicionMiTrait = clase do
     uses MiTrait.+ SoloDiceChau, ResolucionDeConflictosQueAplicaCondicion.new(compararPorIgualdad)
   end

   mi_clase_con_conflictos_estrategia_4 = MiClaseConConflictosResueltosConCuartaEstretegiaCondicionMiTrait.new
   expect(mi_clase_con_conflictos_estrategia_4.metodo1).to eq("hola")
 end

 it 'Agrego dos traits diferentes incluidos en una clase usando ResolucionDeConflictosQueAplicaCondicion donde la condicion es comparar por longuitud' do
   'En este caso toma el metodo de MiTrait'
   compararPorLongitud = proc { |a| a.length == 4}
   MiClaseConConflictosResueltosConCuartaEstretegiaCondicionSoloDiceChau = clase do
     uses MiTrait.+ SoloDiceChau, ResolucionDeConflictosQueAplicaCondicion.new(compararPorLongitud)
   end

   mi_clase_con_conflictos_estrategia_4 = MiClaseConConflictosResueltosConCuartaEstretegiaCondicionSoloDiceChau.new
   expect(mi_clase_con_conflictos_estrategia_4.metodo1).to eq("hola")
 end

 it 'Agrego tres traits diferentes incluidos en una clase usando ResolucionDeConflictosQueAplicaCondicion ' do
   'En este caso se suman 3 traits'
   compararPorIgualdadHola = proc { |a| a == "hola"}
   compararPorIgualdadRompe = proc { |a| a == "rompe"}
   MiClaseConConflictosResueltosConCuartaEstretegiaCondicionError = clase do
     uses (MiTrait.+ SoloDiceChau, ResolucionDeConflictosQueAplicaCondicion.new(compararPorIgualdadHola)).+ Rompe, ResolucionDeConflictosQueAplicaCondicion.new(compararPorIgualdadRompe)
   end

   mi_clase_con_conflictos_estrategia_4 = MiClaseConConflictosResueltosConCuartaEstretegiaCondicionError.new
   expect(mi_clase_con_conflictos_estrategia_4.metodo1).to eq("rompe")
 end

  it 'Agrego tres traits diferentes incluidos en una clase usando ResolucionDeConflictosQueAplicaCondicion utlizando 2 estrategias diferentes' do
    'En este caso se suman 2 con diferentes estrategias'
    compararPorIgualdad = proc { |a| a == "rompe"}
    MiClaseConConflictosResueltosConCuartaEstretegiaCondicionConDiferentesEstrategias = clase do
      uses (MiTrait.+ MiOtroTrait).+ Rompe, ResolucionDeConflictosQueAplicaCondicion.new(compararPorIgualdad)
    end

    mi_clase_con_conflictos_estrategia_4 = MiClaseConConflictosResueltosConCuartaEstretegiaCondicionConDiferentesEstrategias.new
    expect(mi_clase_con_conflictos_estrategia_4.metodo1).to eq("rompe")
  end

 it 'Agrego dos traits diferentes incluidos en una clase usando ResolucionDeConflictosQueAplicaCondicion usando como condicion la comparacion por igualdad' do
    'En este caso al no encontrar el metodo rompe'
    compararPorIgualdad = proc { |a| a == "rompe"}

    expect { MiClaseConConflictosResueltosConCuartaEstretegiaCondicionStandarError = clase do
      uses MiTrait.+ SoloDiceChau, ResolucionDeConflictosQueAplicaCondicion.new(compararPorIgualdad)
    end }.to raise_error(StandardError, 'Ningún método coincide')
  end

  it 'Agrego dos traits diferentes incluidos en una clase usando ResolucionDeConflictosQueAplicaCondicion donde la condicion compara la primer letra del resultado ' do
    'En este caso toma el metodo de SoloDiceChau'
    compararSiComienzaCon = proc { |a| a.start_with?('c') }
    MiClaseConConflictosResueltosConCuartaEstretegiaCondicionStarWith = clase do
      uses MiTrait.+ SoloDiceChau, ResolucionDeConflictosQueAplicaCondicion.new(compararSiComienzaCon)
    end

    mi_clase_con_conflictos_estrategia_4 = MiClaseConConflictosResueltosConCuartaEstretegiaCondicionStarWith.new
    expect(mi_clase_con_conflictos_estrategia_4.metodo1).to eq("chau")
  end

  it 'Cuando haya conflictos en metodos iguales de dos traits diferentes incluidos en una clase usando la estrategia 5' do
    'En este caso el usuario va a definir una funcion con la cual tratar a los metodos con conflictos'

    funcionDelUsuario = proc { |a, b| (a.equal? b) ? a : (raise StandardError, 'No coinciden los métodos con conflictos.') }

    expect { MiClaseConConflictosResueltosConQuintaEstretegiaCondicionStarWith = clase do
      uses MiTrait.+ SoloDiceChau, ResolucionDeConflictosDefinidaPorElUsuario.new(funcionDelUsuario)
    end }.to raise_error(StandardError, 'No coinciden los métodos con conflictos.')
  end

  it 'al haber conflictos en metodos iguales de dos traits diferentes incluidos en una clase usando la estrategia 5' do
    'En este caso el usuario va a definir una funcion con la cual tratar a los metodos con conflictos'

    resolucionDeConflictos = proc do
      raise StandardError, 'Conflictos entre métodos con mismo nombre.'
    end
    expect { MiClaseConConflictosResueltosConQuintaEstretegiaCondicion = clase do
      uses MiTrait.+ SoloDiceChau, ResolucionDeConflictosDefinidaPorElUsuario.new(resolucionDeConflictos)
    end }.to raise_error(StandardError, 'Conflictos entre métodos con mismo nombre.')
  end

 it 'al agregar dos traits diferentes incluidos en una clase. Pero sacando el metodo de un trait' do
   TodoBienTodoLegal = clase do
     uses MiTrait + (SoloDiceChau - :metodo1)
   end

   todo_bien_todo_legal = TodoBienTodoLegal.new
   expect(todo_bien_todo_legal.metodo1).to eq("hola")
   expect(todo_bien_todo_legal.metodo2).to eq("chau")
 end

 it 'Se testea el funcionamiento de alias' do
   ConAlias = clase do
     uses ((MiTrait << {metodo1: :m1Hola}) - :metodo1) +
              ((SoloDiceChau << {metodo1: :m1Chau, metodo2: :m2Chau}) - :metodo1 - :metodo2)

     def metodo1
       m1Hola + " y " + m1Chau
     end

     def metodo2
       m2Chau+"!!"
     end
   end

   con_alias = ConAlias.new
   expect(con_alias.metodo1).to eq("hola y chau")
   expect(con_alias.metodo2).to eq("chau!!")
 end

 it 'Testeo que borre mas de un metodo con la siguiente forma uses trait - [m1,m2,..etc]' do
   #esta clase se crea solo para probar que se borran los metodos de las clases
   BorraTodoLosMetodos = clase do
     uses SoloDiceChau - [:metodo1, :metodo2]
   end

   borraMetodosenlista = BorraTodoLosMetodos.new
   expect { borraMetodosenlista.metodo1 }.to raise_error(NoMethodError)
   expect { borraMetodosenlista.metodo2 }.to raise_error(NoMethodError)
 end

 it 'Testeo que borre mas de un metodo con la siguiente forma uses trait - :m1 -:m2..etc' do
   BorraTodoLosMetodosSinLista = clase do
     uses SoloDiceChau - :metodo1 - :metodo2
   end

   borraMetodosSinLista = BorraTodoLosMetodosSinLista.new
   expect { borraMetodosSinLista.metodo1 }.to raise_error(NoMethodError)
   expect { borraMetodosSinLista.metodo2 }.to raise_error(NoMethodError)
   end
  end