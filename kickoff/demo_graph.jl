using CSV
using DataFrames
using Graphs
using GraphPlot
using Cairo, Fontconfig

function criar_grafo_e_plotar(caminho_csv::String)
    df = CSV.read(caminho_csv, DataFrame; delim=';')

    # Mapear nomes para índices
    pontos = unique(vcat(df.PONTO_ORIGEM, df.PONTO_DESTINO))
    ponto_index = Dict(pontos[i] => i for i in eachindex(pontos))
    g = SimpleGraph(length(pontos))

    # Estilo das arestas
    edge_colors = String[]
    edge_styles = Symbol[]
    edge_labels = String[]

    for row in eachrow(df)
        u = ponto_index[row.PONTO_ORIGEM]
        v = ponto_index[row.PONTO_DESTINO]

        # Só adiciona se ainda não existir
        if !has_edge(g, u, v)
            add_edge!(g, u, v)

            dist = row.DISTANCIA

            # Cor por distância
            if dist <= 3
                push!(edge_colors, "green")
            elseif dist <= 6
                push!(edge_colors, "orange")
            else
                push!(edge_colors, "red")
            end

            # Estilo por conexão com O ou T
            if row.PONTO_ORIGEM in ["O", "T"] || row.PONTO_DESTINO in ["O", "T"]
                push!(edge_styles, :dot)
            else
                push!(edge_styles, :solid)
            end

            push!(edge_labels, string(dist))
        end
    end

    # Rótulos dos nós
    labels = [pontos[i] for i in 1:length(pontos)]

    # Plotagem
    gplot(
        g;
        nodelabel = labels,
        edgelabel = edge_labels,
        edgestrokec = edge_colors,
        linetype = edge_styles,
        layout = spring_layout,
        nodesize = 0.2
    )
end

# Exibindo o gráfico
criar_grafo_e_plotar("grafo_SeervadaPark.csv")

