println("Olá, Mundo!")

using Random
using Plots

# Define a função para plotar
function plot_sine(A1, B1, A2, B2)
    x = 0:0.01:2π  # Valores de x de 0 a 2*pi
    f1(x) = A1 * sin.(x .+ B1)
    f2(x) = A2 * sin.(x .+ B2)

    # Criar os gráficos
    plot(x, f1(x), label="f1(x) = $A1*sin(x + $B1)", color=:blue, legend=:topright)
    plot!(x, f2(x), label="f2(x) = $A2*sin(x + $B2)", color=:red)

    # Adicionar títulos e legendas
    title!("Gráficos de Funções Seno")
    xlabel!("x")
    ylabel!("f(x)")
end

# Sorteio de valores
A1 = rand(0:0.1:100)  # A entre 0 e 100
B1 = rand(0:0.01:π)   # B entre 0 e π
A2 = rand(0:0.1:100)  # Outro A entre 0 e 100
B2 = rand(0:0.01:π)   # Outro B entre 0 e π

grafico = plot_sine(A1, B1, A2, B2)

# Exibindo o gráfico
display(grafico)

# Salvando o gráfico
savefig("kickoff/grafico_seno.png")  # Salva o gráfico como um arquivo PNG

println("Fim da Rodada")
