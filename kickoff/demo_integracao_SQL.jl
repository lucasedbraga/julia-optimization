using DataFrames
using SQLite

# 1. Conectar ao banco de dados SQLite
db = SQLite.DB("data_SQL.db")
cols = SQLite.tables(db)
#println(cols)

# 2. Realizar a Query
q = "SELECT * FROM Tabela_TESTE"
data = SQLite.DBInterface.execute(db,q)

# 3. Transformar o resultado em um DataFrame
df = DataFrame(data)

# 4. Fechar a conexão com o banco de dados
SQLite.close(db)

# 5. Exibir o DataFrame

println("DF - SQL")
println(first(df, 13))

println("FIM !")


