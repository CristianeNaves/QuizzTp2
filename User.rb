module Quizz
  puts "oi"
  def  create_quiz(nome_quizz, perguntas)
    if self.admin?
      nome = nome_quizz + '.txt'
      file = File.open(nome, 'a+')
      perguntas.each do |pergunta|
        file.puts pergunta
      end
      file.close
    end
  end
  
  def acessar_quiz(nome)
    if File.file?(nome + '.txt')
      lines = File.open(nome + '.txt', 'r+')
      line_count = lines.size
      puts 'Iniciando Quiz'
      # conta o score do usuario
      score = 0
      lines.each do |line|
        infor = line.split('-')
        # questão sem ser de multipla escolha 
        if infor[0] == '1'
          puts infor[1].to_s + '-' + infor[2].to_s + ": "
          puts 'Resposta: '
          resposta = gets.chomp
          resposta = resposta.to_s
          if resposta == infor[3]
            puts 'Resposta correta'
            score += infor[4].to_i
          else
            puts 'Resposta errada'
          end
        # resposta de multipla escolha  
        else
          puts infor[1].to_s + '-' + infor[2].to_s + ': '
          puts 'A - ' + infor[3].to_s
          puts 'B - ' + infor[4].to_s
          puts 'C - ' + infor[5].to_s
          puts 'Resposta: '
          resposta = gets.chomp
          resposta = resposta.to_s
          if ((resposta == "A" || resposta == "a") && ((infor[3].to_s.casecmp infor[6].to_s) == 0))
            puts "Resposta correta"
            score += infor[7].to_i
          else
            if ((resposta == "B" || resposta == "b") && ((infor[4].to_s.casecmp infor[6].to_s) == 0))
              puts "Resposta correta"
              score += infor[7].to_i
            else 
              if ((resposta == "C" || resposta == "c") && ((infor[5].to_s.casecmp infor[6].to_s) == 0))
                puts "Resposta correta"
                score += infor[7].to_i
              else
                puts "Resposta errada"
              end
          end
        end
      end
    end
    else
      puts "Quiz nao existe"
    end
      # adiciona esse score para o usuario atual
      self.score = self.score + score
      puts "Score final: " + score.to_s
  end
end

module Disciplina
  # adiciona disciplinas ja presentes no arquivo txt ao programa
  def add_disciplina(disc, top, quiz)
    # acessa as disciplinas do usuario
    if File.exist?('disciplinas.txt')
      disciplinas_atuais = File.readlines('usuarios.txt')
      disciplinas_atuais = disciplinas_atuais[self.id.to_i]
      linha_antiga = disciplinas_atuais
      disciplinas_atuais = disciplinas_atuais.split[5]
    end
    # testa se o arquivo das disciplinas existe e le do arquivo
    if File.exist?('disciplinas.txt')
      nova_disciplina = "[#{disc},#{top},#{quiz}]"
      disciplinas = File.readlines('disciplinas.txt')
      if existe_disciplina? disciplinas, disc, top, quiz
        # Adiciona o que foi lido do arquivo a pilha de disciplinas do programa
        if usuario_possui_disciplinas?
          disciplinas_atuais[-1] = ','
          nova_disciplina = disciplinas_atuais + nova_disciplina + ']'
        else
          disciplinas_atuais = disciplinas_atuais.split('')
          nova_disciplina = disciplinas_atuais[0] + nova_disciplina + disciplinas_atuais[1]
        end
        linha_nova = linha_antiga.split
        linha_nova[5] = nova_disciplina
        linha_nova = linha_nova.join(' ') + "\n"
        substituir_linha linha_antiga, linha_nova
      end
    end
  end

  # substitui uma linha por outro no arquivo Usuarios.txt
  def substituir_linha(linha_antiga, linha_nova)
    file = File.read('usuarios.txt')
    new_content = file.gsub(linha_antiga, linha_nova)
    File.open('usuarios.txt', 'w') { |line| line.puts new_content }
  end

  # Recebe Disciplinas, topicos e quizzes e adiciona
  # ao arquivo txt das disciplinas
  def create_disciplina(disc, top, quizzes)
    if self.admin?
      file = File.open('disciplinas.txt', 'a+')
      disciplinas = File.readlines('disciplinas.txt')
      if !existe_disciplina? disciplinas, disc, top, quizzes
        file.puts "#{disciplinas.size} | #{disc} | #{top} | #{quizzes}"
        file.close
        return true
      end
      file.close
      return false
    end
  end

  # faz a procura de uma disciplina e retorna se a mesma
  # existe no arquivo de disciplinas
  def existe_disciplina?(disciplinas, disc, top, quiz)
    disciplinas.each do |disciplina|
      disciplina = disciplina.split
      if disciplina[2] == disc && disciplina[4] == top && disciplina[6] == quiz
        return true
      end
    end
    return false
  end

  def usuario_possui_disciplinas?
    if File.exist?('usuarios.txt')
      disciplinas = File.readlines('usuarios.txt')
      disciplinas = disciplinas[self.id.to_i]
      disciplinas = disciplinas.split[5]
      if disciplinas == '[]'
        return false
      end
      return true
    end
  end

  def listar_disciplinas_usuario
    if File.exist?('usuarios.txt')
      disciplinas = File.readlines('usuarios.txt')
      disciplina = disciplinas[self.id.to_i]
      disciplina = disciplina.split
      disciplina = disciplina[5]
      puts disciplina
    end
  end
  def listar_disciplinas
    if File.exist?('disciplinas.txt')
      disciplinas = File.readlines('disciplinas.txt')
      puts disciplinas
    end
  end
end
class Usuario
  include Disciplina
  include Quizz
  attr_accessor :disciplinas, :nome, :id, :score
  def initialize
    @disciplinas = []
    @score = 0
  end

  def admin?
    @perfil
  end

  # Recebe os parametros do objeto Usuario, testa se o dado usuario
  # esta presente no arquivo da lista de usuarios
  # Caso o usuario ja exista na lista o metodo retorna false
  # Caso nao exista, o usuario eh adicionado ao arquivo de lista dos
  # usuarios e o metodo retorna true
  def cadastrar(login, senha, nome, perfil)
    if File.exist?('usuarios.txt')
      lines = File.readlines('usuarios.txt')
      line_count = lines.size - 1
      (0..line_count).each do |i|
        info = lines[i].split
        if login == info[0]
          puts 'Usuario ja existente.'
          return false
        end
      end
    end
    @login = login
    @senha = senha
    @nome = nome
    @perfil = perfil
    @disciplinas = []
    if File.exist?('usuarios.txt')
      num_usuarios = File.readlines('usuarios.txt').size
    else
      num_usuarios = 0
    end
    @id = num_usuarios
    File.open('usuarios.txt', 'a+') do |file|
      file.write("#{@id}\t#{login}\t#{senha}\t#{nome}\t"\
                 "#{perfil}\t#{disciplinas}\n")
    end
    return true
  end
  # Recebe o login do usuario e senha
  # Testa se o arquivo de lista de usuarios existe
  # testa se o usuario esta presente na lista
  # Se o usuario e a senha forem encontrados, os dados do usuario
  # sao lidos do arquivo do usuario para a memoria do programa e retorna true
  # Caso contrario, retorna false
  def logar(log, pass)
    if File.exist?('usuarios.txt')
      lines = File.readlines('usuarios.txt')
      lines.each do |line|
        info = line.split
        if log == info[1] && pass == info[2]
          @id = info[0]
          @login = info[1]
          @senha = info[2]
          @nome = info[3]
          @perfil = info[4]
          @disciplinas = info[5]
          return true
        end
    end
    return false
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
end
