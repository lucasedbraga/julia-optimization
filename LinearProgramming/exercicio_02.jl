using Random,  JuMP, Cbc, Clp, Juniper, Ipopt
using LinearAlgebra
using Plots

gr()
plot(rand(3),rand(3))
nothing

numero_produtos = 4
numero_fabricas = 3
numero_CentroDistribuicao = 6
numero_revendedores = 20
horizonte_planejamento = 4

Random.seed!(0)

coordenadas_fabrica = 3*[cos.((1:numero_fabricas) ./ numero_fabricas*2pi) sin.((1:numero_fabricas) ./ numero_fabricas*2pi)]
coordenadas_CentroDistribuicao = 2*randn(numero_CentroDistribuicao,2)
coordenadas_revendedores = (2* randn(numero_revendedores,2) .- 1) * 4

Random.seed!(0)

c1 = [norm(coordenadas_fabrica[i,:] - coordenadas_CentroDistribuicao[j,:]) for i=1:numero_fabricas, j=1:numero_CentroDistribuicao] #Distancia Euclidiana
c2 = [norm(coordenadas_CentroDistribuicao[j,:] - coordenadas_revendedores[k,:]) for j=1:numero_CentroDistribuicao, k=1:numero_revendedores] #Distancia Euclidiana

custo_estoque = rand(10:20, numero_CentroDistribuicao)  
tempo_producao = rand(1:20, numero_produtos)/60 
limite_tempo_fabrica = rand(10:20, numero_fabricas) * numero_revendedores * numero_produtos
demanda_produto = rand(10:15, numero_revendedores, horizonte_planejamento, numero_produtos)

model = Model(optimizer_with_attributes(Cbc.Optimizer, "seconds" => 10.0))

# Quantidade Enviada de produto p da fábrica i para o CD j na semana t
@variable(model, x[i=1:numero_fabricas, j=1:numero_CentroDistribuicao, t=1:horizonte_planejamento, p=1:numero_produtos] >= 0, Int)
# Quantidade Enviada de produto p do CD j para o revendedor k na semana t
@variable(model, y[j=1:numero_CentroDistribuicao, k=1:numero_revendedores, t=1:horizonte_planejamento, p=1:numero_produtos] >= 0, Int)
# Quantidade Armazenada do produto p no CD j na semana t para t+1
@variable(model, z[j=1:numero_CentroDistribuicao, t=0:horizonte_planejamento, p=1:numero_produtos] >= 0, Int)

fix.(z[:,0,:], 0.0, force=true)

@objective(model, Min,
            sum(x[i,j,t,p] * c1[i,j] for i=1:numero_fabricas, j=1:numero_CentroDistribuicao, t=1:horizonte_planejamento, p=1:numero_produtos)
            + sum(y[j,k,t,p] * c2[j,k] for j=1:numero_CentroDistribuicao, k=1:numero_revendedores, t=1:horizonte_planejamento, p=1:numero_produtos)
            + sum(z[j,t,p] * custo_estoque[j] for j=1:numero_CentroDistribuicao, t=1:horizonte_planejamento, p=1:numero_produtos)
)

@constraint(model, lim_tempo[i=1:numero_fabricas, t=1:horizonte_planejamento],
    sum(tempo_producao[p] * x[i,j,t,p] for j=1:numero_CentroDistribuicao, p=1:numero_produtos) <= limite_tempo_fabrica[i])

@constraint(model, balanco[j=1:numero_CentroDistribuicao, t=1:horizonte_planejamento, p=1:numero_produtos],
    sum(x[i,j,t,p] for i=1:numero_fabricas) + z[j,t-1,p]
    ==
    sum(y[j,k,t,p] for k=1:numero_revendedores) + + z[j,t,p]
)

@constraint(model, demanda[j=1:numero_CentroDistribuicao,k=1:numero_revendedores ,t=1:horizonte_planejamento, p=1:numero_produtos],
    sum(y[j,k,t,p] for j=1:numero_CentroDistribuicao) >= demanda_produto[k,t,p]
)


total_variaveis = length(JuMP.all_variables(model))


#Otimizacao
status = optimize!(model)
#Pos Otimizacao
x_result = value.(x)

fob_result = objective_value(model)
fob_status = termination_status(model)

println(repeat("-",50))
println(" Número de Variáveis = $total_variaveis")

println(" FOB = $fob_result")
println(" FOB_status = $fob_status")
println(repeat("-",50))


function figura(x,y,z)
    x = round.(Int,value.(x))
    y = round.(Int,value.(y))
    z = round.(Int,value.(z))

    plot()
    t=1
    for i=1:numero_fabricas, j=1:numero_CentroDistribuicao
        if any(x[i,j,t,:] .> 0)
            plot!([coordenadas_fabrica[i,1], coordenadas_CentroDistribuicao[j,1]], [coordenadas_fabrica[i,2], coordenadas_CentroDistribuicao[j,2]], c=:red, lab="")
        end
    end

    for j=1:numero_CentroDistribuicao, k=1:numero_revendedores
        if any(y[j,k,t,:] .> 0)
            plot!([coordenadas_CentroDistribuicao[j,1], coordenadas_revendedores[k,1]], [coordenadas_CentroDistribuicao[j,2], coordenadas_revendedores[k,2]], c=:blue, lab="")
        end
    end
        
    scatter!(coordenadas_fabrica[:,1], coordenadas_fabrica[:,2], c=:red, ms=6, lab="Fabricas")
    scatter!(coordenadas_CentroDistribuicao[:,1], coordenadas_CentroDistribuicao[:,2], c=:blue, ms=4, lab="Centros de Distribuicao")
    scatter!(coordenadas_revendedores[:,1], coordenadas_revendedores[:,2], c=:magenta, ms=6, lab="Revendedores")
end

figura(x,y,z)