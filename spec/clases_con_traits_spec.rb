require 'rspec'
require 'objetos_inline'

describe 'traits tests' do

  MiTrait = trait do
    def metodo1
      "hola"
    end
  end

  MiOtroTrait = trait do
    def metodo2
      "mundo"
    end
  end

  SoloDiceChau = trait do
    def metodo1
      "chau"
    end

    def metodo2
      "chau"
    end
  end

 it 'Testea el metodo de un trait incluido en una clase' do
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

 it 'Testea el metodo de una clase con mismo nonmbre al de el trait incluido y gana la implementación de la clase' do
   MiClase2 = clase do
     def metodo1
       "chau"
     end

     uses MiTrait
   end

   segunda_clase = MiClase2.new
   expect(segunda_clase.metodo1).to eq("chau")
 end

 it 'Testea metodos diferentes de dos traits incluidos en una clase' do
   MiClase3 = clase do
     uses MiTrait + MiOtroTrait
   end

   tercer_clase = MiClase3.new
   expect(tercer_clase.metodo1).to eq("hola")
   expect(tercer_clase.metodo2).to eq("mundo")
 end

  it 'Testeo que no haya conflictos en metodos iguales de dos traits diferentes incluidos en una clase' do
    MiClaseConConflictos = clase do
      uses MiTrait + SoloDiceChau  # Debería lanzar una excepción
    end

    mi_clase_con_conflictos = MiClaseConConflictos.new
    expect { mi_clase_con_conflictos.metodo1 }.to raise_error(NoMethodError)
    expect(mi_clase_con_conflictos.metodo2).to eq("chau")
  end

 it 'Testeo que no haya conflictos en metodos iguales de dos traits diferentes incluidos en una clase usando la estrategia 1' do
   MiClaseConConflictosResueltosConPrimeraEstretegia = clase do
     uses MiTrait.+ SoloDiceChau, 1
   end

   mi_clase_con_conflictos_estrategia_1 = MiClaseConConflictosResueltosConPrimeraEstretegia.new
   expect(mi_clase_con_conflictos_estrategia_1.metodo1).to eq("hola")
   expect(mi_clase_con_conflictos_estrategia_1.metodo2).to eq("chau")
 end

 it 'Testeo que no haya conflictos en metodos iguales de dos traits diferentes incluidos en una clase usando la estrategia 2' do
   MiClaseConConflictosResueltosConSegundaEstretegia = clase do
     uses MiTrait.+ SoloDiceChau, 2
   end

   mi_clase_con_conflictos_estrategia_2 = MiClaseConConflictosResueltosConSegundaEstretegia.new
   expect(mi_clase_con_conflictos_estrategia_2.metodo1).to eq("chau")
   expect(mi_clase_con_conflictos_estrategia_2.metodo2).to eq("chau")
 end
 
 it 'Testeo que no haya conflictos en metodos iguales de dos traits diferentes incluidos en una clase usando la estrategia 3 - funcion Suma' do
   suma = proc { |a, b| a + b }

   MiClaseConConflictosResueltosConTercerEstrategiaSuma = clase do
     uses MiTrait.+ SoloDiceChau, 3, suma
   end

   mi_clase_con_conflictos_estrategia_3_suma = MiClaseConConflictosResueltosConTercerEstrategiaSuma.new
   expect(mi_clase_con_conflictos_estrategia_3_suma.metodo1).to eq("holachau")
   expect(mi_clase_con_conflictos_estrategia_3_suma.metodo2).to eq("chau")
 end

 it 'Testeo que no haya conflictos en metodos iguales de dos traits diferentes incluidos en una clase usando la estrategia 3 - funcion Suma y Upcase' do
   upcase = proc { |a, b| a.upcase + b.upcase }

   MiClaseConConflictosResueltosConTercerEstrategiaUpcase = clase do
     uses MiTrait.+ SoloDiceChau, 3, upcase
   end

   mi_clase_con_conflictos_estrategia_3_suma_upcase = MiClaseConConflictosResueltosConTercerEstrategiaUpcase.new
   expect(mi_clase_con_conflictos_estrategia_3_suma_upcase.metodo1).to eq("HOLACHAU")
   expect(mi_clase_con_conflictos_estrategia_3_suma_upcase.metodo2).to eq("chau")
 end

 it 'Testeo que no haya conflictos en metodos iguales de dos traits diferentes incluidos en una clase usando la estrategia 3 - funcion Max' do
   max = proc { |a,b| a.length > b.length ? a : b }

   MiClaseConConflictosResueltosConTercerEstrategiaMax = clase do
     uses MiTrait.+ SoloDiceChau, 3, max
   end

   mi_clase_con_conflictos_estrategia_3_max = MiClaseConConflictosResueltosConTercerEstrategiaMax.new
   expect(mi_clase_con_conflictos_estrategia_3_max.metodo1).to eq("chau")
   expect(mi_clase_con_conflictos_estrategia_3_max.metodo2).to eq("chau")
 end

 it 'Testeo que no haya conflictos en metodos iguales de dos traits diferentes incluidos en una clase usando la estrategia 3 - funcion Longitud de Max' do
   longitudDeMax = proc { |a,b| a.length >= b.length ? a.length : b.length }

   MiClaseConConflictosResueltosConTercerEstrategiaLongitudDeMax = clase do
     uses MiTrait.+ SoloDiceChau, 3, longitudDeMax
   end

   mi_clase_con_conflictos_estrategia_3_longitud_de_max = MiClaseConConflictosResueltosConTercerEstrategiaLongitudDeMax.new
   expect(mi_clase_con_conflictos_estrategia_3_longitud_de_max.metodo1).to be 4
   expect(mi_clase_con_conflictos_estrategia_3_longitud_de_max.metodo2).to eq("chau")
 end

  it 'Testeo que no haya conflictos en metodos iguales de dos traits diferentes incluidos en una clase usando la estrategia 4' do
    'En este caso toma el Trait de MiTrait'
    MiClaseConConflictosResueltosConCuartaEstretegia = clase do
      uses MiTrait.+ SoloDiceChau, 4, nil, "hola"
    end

    mi_clase_con_conflictos_estrategia_4 = MiClaseConConflictosResueltosConCuartaEstretegia.new
    expect(mi_clase_con_conflictos_estrategia_4.metodo1).to eq("hola")
  end

  it 'Testeo que no haya conflictos en metodos iguales de dos traits diferentes incluidos en una clase usando la estrategia 4' do
    'En este caso toma el Trait de SoloDiceChau'
    MiClaseConConflictosResueltosConCuartaEstretegia = clase do
      uses MiTrait.+ SoloDiceChau, 4, nil, "chau"
    end

    mi_clase_con_conflictos_estrategia_4 = MiClaseConConflictosResueltosConCuartaEstretegia.new
    expect(mi_clase_con_conflictos_estrategia_4.metodo1).to eq("chau")
  end

  it 'Testeo que no haya conflictos en metodos iguales de dos traits diferentes incluidos en una clase usando la estrategia 4' do
    'En este caso al no encontrar el metodo rompe'
    MiClaseConConflictosResueltosConCuartaEstretegia = clase do
      uses MiTrait.+ SoloDiceChau, 4, nil, "rompe"
    end

    mi_clase_con_conflictos_estrategia_4 = MiClaseConConflictosResueltosConCuartaEstretegia.new
    expect { mi_clase_con_conflictos_estrategia_4.metodo1 }.to raise_error(NoMethodError)
  end


  it 'Testeo que no haya conflictos en metodos iguales de dos traits diferentes incluidos en una clase' do
   MiClaseSinConflictos = clase do
     uses MiTrait + MiTrait # No debería lanzar una excepción, es equivalente a usar MiTrait
   end

   mi_clase_sin_conflictos = MiClaseSinConflictos.new
   expect(mi_clase_sin_conflictos.metodo1).to eq("hola")
 end

 it 'Testeo metodos iguales de dos traits diferentes incluidos en una clase. Pero sacando el metodo de un trait' do
   TodoBienTodoLegal = clase do
     uses MiTrait + (SoloDiceChau - :metodo1)
   end

   todo_bien_todo_legal = TodoBienTodoLegal.new
   expect(todo_bien_todo_legal.metodo1).to eq("hola")
   expect(todo_bien_todo_legal.metodo2).to eq("chau")
 end

 it 'Testeo metodo que retorna un string compuesto por el resultado de los metodos de dos Traits' do
   ConAlias = clase do
     uses ((MiTrait << {metodo1: :m1Hola}) - :metodo1) +
              ((SoloDiceChau << {metodo1: :m1Chau}) - :metodo1)

     def metodo1
       m1Hola + " y " + m1Chau
     end
   end

   con_alias = ConAlias.new
   expect(con_alias.metodo1).to eq("hola y chau")
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