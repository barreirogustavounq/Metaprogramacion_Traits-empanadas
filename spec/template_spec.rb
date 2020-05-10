require 'rspec'
require 'template'
require 'mi_clase'

describe 'template tests' do

  it 'un template saluda con "Hola!"' do
    un_template = Template.new

    expect(un_template.saludar).to eq("Hola!")
  end

end

describe 'traits tests' do

  # it 'Testea el metodo de un trait incluido en una clase' do
    # una_clase = MiClase.new
    # expect(una_clase.metodo1).to eq("hola")
    # expect(una_clase.metodo2('!')).to eq("mundo!")
  # end

  # it 'Testea el metodo de una clase con mismo nonmbre al de el trait incluido y gana la implementación de la clase' do
    # segunda_clase = MiClase2.new
    # expect(segunda_clase.metodo1).to eq("chau")
  # end

  # it 'Testea metodos diferentes de dos traits incluidos en una clase' do
    # tercer_clase = MiClase3.new
    # expect(tercer_clase.metodo1).to eq("hola")
    # expect(tercer_clase.metodo2).to eq("mundo")
  # end

  # it 'Testeo que no haya conflictos en metodos iguales de dos traits diferentes incluidos en una clase' do
    # mi_clase_con_conflictos = MiClaseConConflictos.new
    # expect(mi_clase_con_conflictos.metodo2).to eq("chau")
    # expect(mi_clase_con_conflictos.metodo1).to eq("chau")
  # end

  # it 'Testeo metodos iguales de dos traits diferentes incluidos en una clase. Pero sacando el metodo de un trait' do
    # todo_bien_todo_legal = TodoBienTodoLegal.new
    # expect(todo_bien_todo_legal.metodo1).to eq("hola")
    # expect(todo_bien_todo_legal.metodo2).to eq("chau")
  # end

  # it 'Testeo metodo que retorna un string compuesto por el resultado de los metodos de dos Traits' do
    # con_alias = ConAlias.new
    # expect(con_alias.metodo1).to eq("hola y chau")
  # end

  it 'Test de uses' do
    mi_clase = MiClase.new
    expect(mi_clase.metodo1).to eq("hola")
    expect(mi_clase.metodo2("!")).to eq("mundo!")
  end
end