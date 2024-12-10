using LinearAlgebra, LinearAlgebraX,
  Polynomials, Roots, ForwardDiff, PrettyTables

# M = [1 0 0;
#     -1 2 2;
#      4 3 5]

# Fabrica| Produto1 ; Produto2 ; Produto3; Produto 4
# A | 7 5 0 1
# B | 0 4 3 7
# C | 3 2 0 2
receita = [3;9;8]

semana1 = [ 7 5 0 ;
            0 4 3 ;
            3 2 0 ] 

semana2 = [ 9 4 1 ;
            0 5 1 ;
            4 1 1 ] 

total_de_producao = semana1 + semana2
lucro = total_de_producao*receita

M = total_de_producao

invM = inv(M)
inv_com_racional = invx(M)
M_transp= transpose(M)
detM = det(M)
det_racional_M = detx(M)
polinomio_caracteristico = char_poly(M)
raizes_polinomio_caracteristico = roots(polinomio_caracteristico)
autoval_M = eigvals(M)
autovet_M = eigvecs(M)

# Calculo de Hessiana
function f(M)
    return sum(M.^2) 
end


gradiente = ForwardDiff.gradient(f,M)
hessiana = ForwardDiff.hessian(f,M)

norma_gradiente = norm(gradiente)
curvatura_gaussiana = det(hessiana)/norma_gradiente^4

M_leg = hcat(["A";"B";"C"],M)
receita_leg = hcat(["A";"B";"C"],receita)
lucro_leg = hcat(["A";"B";"C"],lucro)

println("A matriz de Produção Total M é:")
pretty_table(M_leg, header = ["Produto","Semana 1","Semana 2","Semana 3"])
println("A Matriz de Receitas é:")
pretty_table(receita_leg, header=["Produto","Preço dos produtos"])
println("A Matriz de Lucro é:")
pretty_table(lucro_leg, header=["Produto","Lucro por Produto"])

println(repeat("-",50))

println("A inversa de M é:")
pretty_table(invM, header=["x'1", "x'2", "x'3"])
println("Os racionais da inversa de M são :")
pretty_table(inv_com_racional, header=["x'1", "x'2", "x'3"])
println("A matriz transposta de M é:")
pretty_table(M_transp, header=["xT1", "xT2", "xT3"])


println(repeat("-",50))

println("O Polinomio caracteristico da matriz M é: \n $polinomio_caracteristico")
println("As raizes do polinomio caracteristico de M são: \n $raizes_polinomio_caracteristico")
println("Logo, os autovalores de M são: \n $autoval_M")
println("e os autovetores de M :")
pretty_table(autovet_M, header=["x1", "x2", "x3"])

println(repeat("-",50))
println("O gradiente de M é $gradiente")
pretty_table(gradiente, header=["∂f/∂x", "∂f/∂y", "∂f/∂z"])

linhas = size(hessiana,1)
colunas = size(hessiana,2)

println("A hessiana de M tem shape $linhas x $colunas")


pretty_table(hessiana, header = ["∂²f/∂x²", "∂²f/∂x∂y", "∂²f/∂x∂z",
                                 "∂²f/∂y∂x", "∂²f/∂y²", "∂²f/∂y∂z",
                                 "∂²f/∂z∂x", "∂²f/∂z∂y", "∂²f/∂z²"])

println("Logo, a curvatura Gaussiana de M é  $curvatura_gaussiana")


solucao_sistema_linear = total_de_producao \ lucro
println("Solução do sistema (total_producao)x = lucro:")
println(solucao_sistema_linear)
println("x é o preço de cada produto: $receita")




