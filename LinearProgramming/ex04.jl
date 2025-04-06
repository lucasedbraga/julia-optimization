using JuMP, GLPK, Cbc, Clp, Juniper, Ipopt

# PreProcess

# Inicialização do contador de avaliações
contador_objetivo = 0
# Medindo o tempo de execução
tempo_execucao = @elapsed begin
        
    model = Model(GLPK.Optimizer)
    #model = Model(Clp.Optimizer)

    # Variaveis
    @variable(model, x[1:2] >= 0) # Notação de vetores, ao inves de x1 >= 0;x2 >= 0 


    function FOB(x)
        global contador_objetivo
        contador_objetivo += 1
        return  20x[1] + 24x[2]
    end

    @objective(model, Max, FOB(x))

    # Restricoes
    @constraint(model, 3x[1] + 6x[2] <= 60)
    @constraint(model, 4x[1] + 2x[2] <= 32)

    #Otimizacao
    status = optimize!(model)
end

print(model)
#Pos Otimizacao
x_result = value.(x)

fob_result = objective_value(model)
fob_status = termination_status(model)
num_funcoes_avaliadas = contador_objetivo

println(repeat("-",50))
println(" X* = $x_result")
println(repeat("-",50))
println(" FOB = $fob_result")
println(" FOB_status = $fob_status")
println(repeat("-",50))
println("Tempo de Rodada = $tempo_execucao")
println("num_funcoes_avaliadas = $num_funcoes_avaliadas")