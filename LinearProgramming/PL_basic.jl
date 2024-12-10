using Plots
gr()
plot(rand(3),rand(3))
nothing

using JuMP, Cbc, Clp, Juniper, Ipopt

# PreProcess
model = Model(Clp.Optimizer)
#model = Model(Clp.Optimizer)

# Variaveis
@variable(model, x[1:2] >= 0) # Notação de vetores, ao inves de x1 >= 0;x2 >= 0 

#FOB
@objective(model, Max, x[1] + 2x[2])
# Restricoes
@constraint(model, x[1] + 3x[2] <= 6)
@constraint(model, 7x[1] + 5x[2] <= 12)

# Pre Otimizacao
print(model)

#Otimizacao
status = optimize!(model)

#Pos Otimizacao
x_result = value.(x)

fob_result = objective_value(model)
fob_status = termination_status(model)


println(" X* = $x_result")
println()
println(" FOB = $fob_result")
println(" FOB_status = $fob_status")
