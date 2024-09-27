using DataFrames
using MySQL
using DBInterface

# Lendo os parâmetros do arquivo
function ler_parametros(arquivo)
    # Abrindo o arquivo e lendo as linhas
    linhas = readlines(arquivo)

    # Criando um dicionário para armazenar os dados
    parametros = Dict{String, String}()

    # Processando cada linha
    for linha in linhas
        chave, valor = split(linha, ";") 
        parametros[chave] = valor
    end

    return parametros  # Retornando os valores
end

# Caminho para o arquivo
caminho_arquivo = "../UNTRACKED/ODBC_connect/log_info.txt"

# Lendo os parâmetros
parametros = ler_parametros(caminho_arquivo)

# Criar a conexão
conn = DBInterface.connect(MySQL.Connection, 
                           parametros["host"], 
                           parametros["user"], 
                           parametros["password"], 
                           db=parametros["database"])

println("CONEXÃO ESTABELECIDA")

query = "SELECT * FROM Tabela_TESTE"  
df = DataFrame(DBInterface.execute(conn,query))
DBInterface.close(conn)

# Mostrar o DataFrame
println(df)
# Exibir o DataFrame
println("DF - ODBC")
# println(first(df, 13))

println("FIM !")


