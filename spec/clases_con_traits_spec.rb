require 'rspec'
require 'mi_clase'

describe 'traits tests' do

 it 'Testea el metodo de un trait incluido en una clase' do
   una_clase = MiClase.new
   expect(una_clase.metodo1).to eq("hola")
   expect(una_clase.metodo2('!')).to eq("mundo!")
 end

 it 'Testea el metodo de una clase con mismo nonmbre al de el trait incluido y gana la implementación de la clase' do
   segunda_clase = MiClase2.new
   expect(segunda_clase.metodo1).to eq("chau")
 end

 it 'Testea metodos diferentes de dos traits incluidos en una clase' do
   tercer_clase = MiClase3.new
   expect(tercer_clase.metodo1).to eq("hola")
   expect(tercer_clase.metodo2).to eq("mundo")
 end

  it 'Testeo que no haya conflictos en metodos iguales de dos traits diferentes incluidos en una clase' do
    mi_clase_con_conflictos = MiClaseConConflictos.new
    expect { mi_clase_con_conflictos.metodo1 }.to raise_error(NoMethodError)
    expect(mi_clase_con_conflictos.metodo2).to eq("chau")
  end

 it 'Testeo que no haya conflictos en metodos iguales de dos traits diferentes incluidos en una clase usando la estrategia 1' do
   mi_clase_con_conflictos_estrategia_1 = MiClaseConConflictosResueltosConPrimeraEstretegia.new
   expect(mi_clase_con_conflictos_estrategia_1.metodo1).to eq("hola")
   expect(mi_clase_con_conflictos_estrategia_1.metodo2).to eq("chau")
 end

 it 'Testeo que no haya conflictos en metodos iguales de dos traits diferentes incluidos en una clase usando la estrategia 2' do
   mi_clase_con_conflictos_estrategia_2 = MiClaseConConflictosResueltosConSegundaEstretegia.new
   expect(mi_clase_con_conflictos_estrategia_2.metodo1).to eq("chau")
   expect(mi_clase_con_conflictos_estrategia_2.metodo2).to eq("chau")
 end

 it 'Testeo que no haya conflictos en metodos iguales de dos traits diferentes incluidos en una clase' do
   mi_clase_sin_conflictos = MiClaseSinConflictos.new
   expect(mi_clase_sin_conflictos.metodo1).to eq("hola")
 end

 it 'Testeo que borre mas de un metodo con la siguiente forma uses trait - [m1,m2,..etc]' do
   borraMetodosenlista = BorraTodoLosMetodos.new
   expect { borraMetodosenlista.metodo1 }.to raise_error(NoMethodError)
   expect { borraMetodosenlista.metodo2 }.to raise_error(NoMethodError)
 end
 it 'Testeo que borre mas de un metodo con la siguiente forma uses trait - :m1 -:m2..etc' do
   borraMetodosSinLista = BorraTodoLosMetodosSinLista.new
   expect { borraMetodosSinLista.metodo1 }.to raise_error(NoMethodError)
   expect { borraMetodosSinLista.metodo2 }.to raise_error(NoMethodError)
 end

 it 'Testeo metodo que retorna un string compuesto por el resultado de los metodos de dos Traits' do
   con_alias = ConAlias.new
   expect(con_alias.metodo1).to eq("hola y chau")
 end
end