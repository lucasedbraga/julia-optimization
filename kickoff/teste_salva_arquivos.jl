using SQLite, Dates
import SQLite.DB
import SQLite.execute

# 1. Criar pasta "DATA" se não existir
data_dir = joinpath(@__DIR__, "DATA")
isdir(data_dir) || mkdir(data_dir)

# 2. Caminho completo para o banco de dados
db_path = joinpath(data_dir, "meu_banco.db")

# 3. Conectar ao banco de dados (se não existir, será criado)
db = SQLite.DB(db_path)

# 4. Criar tabela (exemplo)
execute(db, """
    CREATE TABLE IF NOT EXISTS exemplo (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        criado_em TEXT NOT NULL
    );
""")

# 5. Inserir dados (com commit automático)
nome_exemplo = "Lucas Braga"
criado_em = string(Dates.now())

execute(db, """
    INSERT INTO exemplo (nome, criado_em) VALUES (?, ?);
""", (nome_exemplo, criado_em))

# 6. Fechar conexão (o commit já é automático no SQLite.jl por padrão)
SQLite.close(db)

println("Banco de dados criado/modificado em: $db_path")
