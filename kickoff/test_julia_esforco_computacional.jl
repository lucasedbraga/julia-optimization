using JuMP, GLPK
using LinearAlgebra
using Printf
using Dates

# Parâmetros do teste
N = 100_000   # Número de variáveis (ajustável para estressar a RAM)
M = 10        # Número de restrições

println("Iniciando teste de esforço computacional...")
println("Data/hora: ", now())
println("Variáveis: $N, Restrições: $M")

# Gerando dados determinísticos (não aleatórios)
c = fill(3.0, N)                                # Coeficientes fixos
A = fill(2.0, M, N)                             # Restrições com todos os coeficientes iguais
b = [5000.0 + i * 1000.0 for i in 0:M-1]         # Lado direito simples

# Tempo de execução
tempo_execucao = @elapsed begin
    model = Model(GLPK.Optimizer)
    set_silent(model)  # Silencia a saída do solver

    @variable(model, x[1:N] >= 0)
    @objective(model, Max, sum(c[i] * x[i] for i in 1:N))

    for i in 1:M
        @constraint(model, sum(A[i, j] * x[j] for j in 1:N) <= b[i])
    end

    optimize!(model)
end

# Resultados
status = termination_status(model)
fo = objective_value(model)
@printf("\n%-40s %s\n", "Status da otimização:", status)
@printf("%-40s %.2f\n", "Valor da função objetivo:", fo)
@printf("%-40s %.2f segundos\n", "Tempo total de execução:", tempo_execucao)
println("-"^60)
