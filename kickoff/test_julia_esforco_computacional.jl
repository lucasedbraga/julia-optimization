using JuMP, GLPK, Random

# Número de variáveis
N = 1_000_000
M = 10  # Número de restrições (pode ajustar)

# Inicialização do contador e tempo
contador_objetivo = 0
tempo_execucao = @elapsed begin
    println(" Iniciando otimização com $N variáveis e $M restrições...")
    # Semente para reprodutibilidade
    Random.seed!(123)

    # Gerando coeficientes aleatórios para a função objetivo
    c = rand(1.0:0.1:10.0, N)

    # Gerando matriz de coeficientes aleatórios para as restrições
    A = rand(0.0:0.1:5.0, M, N)
    b = rand(1000.0:1000.0:5000.0, M)

    # Criando o modelo
    model = Model(GLPK.Optimizer)
    @variable(model, x[1:N] >= 0)

    # Função objetivo
    function FOB(x)
        global contador_objetivo += 1
        return sum(c[i] * x[i] for i in 1:N)
    end

    @objective(model, Max, FOB(x))

    # Restrições (Ax <= b)
    for i in 1:M
        @constraint(model, sum(A[i,j] * x[j] for j in 1:N) <= b[i])
    end

    # Otimização
    optimize!(model)
end

# Pós-processamento
x_result = value.(x)
fob_result = objective_value(model)
fob_status = termination_status(model)
num_funcoes_avaliadas = contador_objetivo

println(repeat("-", 50))
println(" X* = vetor de tamanho $(length(x_result)) (exibindo os 5 primeiros): ", x_result[1:5])
println(repeat("-", 50))
println(" FOB = $fob_result")
println(" Status = $fob_status")
println(" Tempo de execução = $tempo_execucao s")
println(" Avaliações da função objetivo = $num_funcoes_avaliadas")
