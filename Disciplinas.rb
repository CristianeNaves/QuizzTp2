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