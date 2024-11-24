using DataFrames
using CSV

println("Executando")

# Lê o DataFrame do arquivo CSV
df = CSV.File("data.csv") |> DataFrame
println(first(df, 13))
println("FIM !")
