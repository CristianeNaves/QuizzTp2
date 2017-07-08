require '../User'
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
	end

	describe "#cadastrar" do
		it 'passo usuario já existente e espero que falhe' do
			expect(@user.cadastrar "123", "123", "Cris", false).to be false
		end
		it 'passo usuario não existente e espero que cadastre' do
			expect(@user.cadastrar "12", "12", "Cris", false).to be true
		end
	end

	#it 'crio uma disciplina e espero que ela seja armazenada, dado que ela não existe' do
	#		@user.cadastrar "42", "42", "Cris", true
	#		expect(@user.createDisciplina "CiC", "Grafos", "Quiz 1").to be true
	#	end
	#	it 'crio uma disciplina e espero que ela não seja armazenada, dado que ela existe' do
	#		@user.logar "42", "42"
	#		expect(@user.createDisciplina "CiC", "Grafos", "Quiz 1").to be false
	#	end


end