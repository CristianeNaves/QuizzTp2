module Quizz
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
          resposta = STDIN.gets.chomp
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
          resposta = STDIN.gets.chomp
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
      return false
    end
      # adiciona esse score para o usuario atual
      self.score = self.score + score
      puts "Score final: " + score.to_s
      return true
  end
end
