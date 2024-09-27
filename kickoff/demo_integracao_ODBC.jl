using DataFrames
using ODBC

# Lendo os parâmetros do arquivo
function ler_parametros(arquivo)
    # Abrindo o arquivo e lendo as linhas
    linhas = readlines(arquivo)

    # Criando um dicionário para armazenar os dados
    parametros = Dict{String, Int}()

    # Processando cada linha
    for linha in linhas
        chave, valor = split(linha, ";")  # Dividindo a linha em chave e valor
        parametros[chave] = parse(Int, valor)  # Convertendo o valor para inteiro e armazenando
    end

    return parametros  # Retornando os valores
end

# Caminho para o arquivo
caminho_arquivo = "../UNTRACKED/ODBC_connect/log_info.txt"

# Lendo os parâmetros
parametros = ler_parametros(caminho_arquivo)

# Conectar ao banco de dados (substitua pela sua string de conexão)
# conn = ODBC.Connection('DSN=parametros["DSN"];UID=parametros["usuario"];PWD=parametros["senha"]')

# Executar uma consulta SQL
# query = "SELECT * FROM sua_tabela"
# df = DataFrame(ODBC.query(conn, query))

# Fechar a conexão
# ODBC.close(conn)

# Exibir o DataFrame
println("DF - ODBC")
# println(first(df, 13))

println("FIM !")


