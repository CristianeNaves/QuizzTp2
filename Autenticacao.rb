module Autenticacao
  def existe_usuario?(login)
    if File.exist?('usuarios.txt')
      lines = File.readlines('usuarios.txt')
      lines.each do |line|
        info = line.split
        if login == info[1]
          return true
        end
      end
    end
    return false
  end

  def gerarID
    if File.exist?('usuarios.txt')
      num_usuarios = File.readlines('usuarios.txt').size
    else
      num_usuarios = 0
    end
    return num_usuarios
  end
  # Recebe os parametros do objeto Usuario, testa se o dado usuario
  # esta presente no arquivo da lista de usuarios
  # Caso o usuario ja exista na lista o metodo retorna false
  # Caso nao exista, o usuario eh adicionado ao arquivo de lista dos
  # usuarios e o metodo retorna true
  def cadastrar(login, senha, nome, perfil)
    if existe_usuario?(login)
      puts 'Usuario ja existente.'
      return false
    else
      disciplinas = []
      num_usuarios = gerarID    
      File.open('usuarios.txt', 'a+') do |file|
        file.write("#{num_usuarios}\t#{login}\t#{senha}\t#{nome}\t"\
                 "#{perfil}\t#{disciplinas}\n")
      end  
      return true
    end
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
          self.id = info[0]
          self.login = info[1]
          self.nome = info[3]
          self.perfil = info[4]
          self.disciplinas = info[5]
          return true
        end
      end
    end
    return false
  end
end