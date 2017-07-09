require 'simplecov'
SimpleCov.start
require 'spec_helper'
RSpec.describe Usuario do
	before(:all) do
		@user = Usuario.new
		@user.cadastrar 1234, 1234, "Cris", true
		@user.cadastrar 123, 123, "Cris", false
	end
	describe "#logar" do
		it 'passo log e senha e espero que falhe' do
			expect(@user.logar "12345", "12345").to be false
		end
		it 'passo log e senha e espero que passe' do
			expect(@user.logar "1234", "1234").to be true
			expect(@user.logar "123", "123").to be true
		end
		it 'espero que informacoes de retorno do login estejam corretas' do
			@user.logar "123", "123"
			expect(@user.login).to eq("123")
			expect(@user.nome).to eq("Cris")
			expect(@user.perfil).to be false

		end
	end

	describe "#cadastrar" do
		it 'passo usuario já existente e espero que falhe' do
	        expect(@user.cadastrar "123", "123", "Cris", false).to be false
		end
		it 'passo usuario não existente e espero que cadastre' do
			expect(@user.cadastrar "12", "12", "Cris", false).to be true
		end
	end

	describe '#criar_disciplinas' do
		it 'espero que a disciplina não seja criada dado que o perfil eh false' do
			@user.logar "123", "123"
			expect(@user.create_disciplina "Mat", "Ial", "Quiz1").to be false
		end
		it 'espero que a disciplina seja criada dado que o perfil eh true' do
			@user.logar "1234", "1234"
			expect(@user.create_disciplina "Mat", "Algebra", "Quiz2").to be true
		end
		it 'espero que a disciplina seja criada dado que ela nao existe' do
			@user.logar "1234", "1234"
			expect(@user.create_disciplina "Mat", "Calculo1", "Quiz3").to be true
		end
		it 'espero que a disciplina  não seja criada dado que ela existe' do
			@user.logar "1234", "1234"
			expect(@user.create_disciplina "Mat", "Algebra", "Quiz2").to be false
		end
		it 'espero que o arquivo de disciplinas possua certa disciplina dado que ela foi criada' do
			@user.cadastrar "Cris", "12", "Cristiane", true
			@user.logar "Cris", "12"
			@user.create_disciplina "CIC", "APC", "Quiz4"
			disciplinas = File.readlines('disciplinas.txt')
			expect(@user.existe_disciplina? disciplinas, "CIC", "APC", "Quiz4").to be true
		end
	end	

	describe '#adicionar_disciplina' do
		it 'espero que a disciplina seja adicionada dado que ela foi criada' do
			@user.logar "1234", "1234"
			@user.create_disciplina "CIC", "Grafos", "Quiz1"
			expect(@user.add_disciplina "CIC", "Grafos", "Quiz1").to be true
		end
		it 'espero que a disciplina nao seja adicionada dado que ela nao foi criada' do
			@user.logar "123", "123"
			expect(@user.add_disciplina "CIC", "Iia", "Quiz2").to be false
		end
	end

	describe 'criar_quiz' do
		it 'espero que o quiz nao seja criado dado que o usuario nao eh admin' do
			@user.logar "123", "123"
			expect(@user.create_quiz "Quiz1", ["1-1-Tudo bom?-F-5"])	
		end
		it 'espero que o quiz seja criado dado que o usuario eh admin' do
			@user.logar "1234", "1234"
			expect(@user.create_quiz "Quiz1", ["1-1-Tudo bom?-V-5"])	
		end
	end

	describe 'acessar_quiz' do
		it 'consigo acessar um quiz dado que ele existe' do
			@user.logar "1234", "1234"
			@user.create_quiz "Quiz2", ["1-1-Tudo bom?-F-5"]
			expect(@user.acessar_quiz "Quiz2").to be true
		end
		it 'nao consigo acessar um quiz dado que ele nao existe' do
			expect(@user.acessar_quiz "Quiz3").to be false
		end
	end

end