require_relative './Disciplinas.rb'
require_relative './Quizz.rb'
require_relative './Autenticacao.rb'


class Usuario
  include Disciplina
  include Quizz
  include Autenticacao
  
  attr_accessor :disciplinas, :nome, :id, :score, :login, :perfil
  
  def initialize
    @disciplinas = []
    @score = 0
  end

  def admin?
    @perfil
  end
end

# main
user = Usuario.new
puts "Selecione a opcao desejada:\n1 - Efetuar login\n2 - Efetuar cadastro"
opcao = gets.chomp
if opcao == '1'
  puts 'Login:'
  log = gets.chomp
  puts 'Senha:'
  pass = gets.chomp
  check = user.logar log, pass
  if check
    puts 'Login permitido'
    if user.admin?.to_s == 'true'
      puts "Selecione a operacao desejada: \n1 - Criar disciplina\n2 - "\
      "Criar quiz\n3 - Responder quiz\n4 - Listar minhas disciplinas\n "\
      "5 - Listar todas as disciplinas\n6 - Adicionar disciplina"
      option = gets.chomp
      case option
      when '1'
        puts 'Digite o nome da disciplina que deseja adicionar: '
        disc = gets.chomp
        puts 'Digite o topico da disciplina que deseja adicionar: '
        top = gets.chomp
        puts 'Digite o nome do quiz para adicionar a disciplina'
        quiz = gets.chomp
        nova_disciplina = user.create_disciplina disc, top, quiz
        if nova_disciplina
          puts 'Disciplina adicionada com sucesso.'
        else
          puts 'Não foi possível criar a disciplina.'
        end
      when '2'
        puts 'Digite o nome do quiz que deseja adicionar: '
        quizz = gets.chomp
        perguntas = []
        puts 'Formatacao das perguntas de verdadeiro ou falso: '\
        '1-Numerodaquestao-Pergunta-Resposta-Pontuacao'
        puts 'Formatacao das perguntas de multipla escolha: 2-Numerodaquestao'\
        '-Pergunta-Alternativa1-Alternativa2-Alternativa3-Resposta-Pontuacao'
        puts 'Digite a pergunta do quiz (0 caso esteja no fim) '
        while (questions = gets.chomp) != '0'
          puts 'Digite a pergunta do quiz (0 caso esteja no fim) '
          perguntas.push(questions)
        end
        user.create_quiz quizz, perguntas
        puts 'Quiz adicionado com sucesso'
      when '3'
        puts 'Digite o nome do quiz: '
        quizzz = gets.chomp
        user.acessar_quiz quizzz
      when '4'
        user.listar_disciplinas_usuario
      when '5'
        user.listar_disciplinas
      when '6'
        puts 'Qual disciplina você quer adicionar?'
        disc = gets.chomp
        puts 'Qual tópico você quer adicionar?'
        top = gets.chomp
        puts 'Qual Quiz você quer adicionar?'
        quiz = gets.chomp
        user.add_disciplina disc, top, quiz
      end
    else
      puts "Selecione a operacao desejada:\n1-Responder quiz\n2-Listar minhas "\
      "disciplinas\n3-Listar todas as disciplinas\n4-Adicionar disciplina"
      option = gets.chomp
      case option
      when '1'
        puts 'Digite o nome do quiz: '
        quizzz = gets.chomp
        user.acessar_quiz quizzz
      when '2'
        user.listar_disciplinas_usuario
      when '3'
        user.listar_disciplinas
      when '4'
        puts 'Qual disciplina você quer adicionar?'
        disc = gets.chomp
        puts 'Qual tópico você quer adicionar?'
        top = gets.chomp
        puts 'Qual Quiz você quer adicionar?'
        quiz = gets.chomp
        user.add_disciplina disc, top, quiz
      end
    end
  else
    puts 'Usuario não cadastrado'
  end
else
  puts 'Digite um numero de login: '
  login = gets.chomp
  puts 'Digite a senha: '
  senha = gets.chomp
  puts 'Digite o nome do usuario: '
  nome = gets.chomp
  puts 'O usuario eh admin? (S ou N):'
  perf = gets.chomp
  #while perf != 'S' && perf != 'N'
  #  puts 'Opcao invalida, digite novamente o perfil do usuario (S ou N): '
  #  perf = gets.chomp
  #end
  if perf == 'S'
    new_perf = true
  else
    new_perf = false
  end
  user.cadastrar login, senha, nome, new_perf
end
