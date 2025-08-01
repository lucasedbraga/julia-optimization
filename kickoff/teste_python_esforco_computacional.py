import pyomo.environ as pyo
import numpy as np
import random
import time

# Parâmetros do problema
N = 1_000_000  # número de variáveis
M = 10         # número de restrições

random.seed(123)
np.random.seed(123)

# Coeficientes aleatórios para a função objetivo
c = np.random.uniform(1.0, 10.0, size=N)

# Coeficientes aleatórios para as restrições
A = np.random.uniform(0.0, 5.0, size=(M, N))
b = np.random.uniform(1000.0, 5000.0, size=M)

# Contador de avaliações da função objetivo
contador_objetivo = 0

# Modelo
start_time = time.time()
model = pyo.ConcreteModel()
model.I = pyo.RangeSet(0, N-1)
model.x = pyo.Var(model.I, domain=pyo.NonNegativeReals)

# Função objetivo (linear, com contador)
def fob_rule(model):
    global contador_objetivo
    contador_objetivo += 1
    return sum(c[i] * model.x[i] for i in model.I)

model.obj = pyo.Objective(rule=fob_rule, sense=pyo.maximize)

# Restrições: Ax <= b
def restricao_factory(i):
    return sum(A[i][j] * model.x[j] for j in range(N)) <= b[i]

for i in range(M):
    model.add_component(f"restricao_{i}", pyo.Constraint(rule=restricao_factory(i)))

# Resolver
solver = pyo.SolverFactory('glpk')  # ou 'cbc' se estiver instalado
result = solver.solve(model, tee=True)
tempo_execucao = time.time() - start_time

# Resultados
x_result = [pyo.value(model.x[i]) for i in range(5)]  # só os 5 primeiros para exibir
fob_result = pyo.value(model.obj)
fob_status = result.solver.termination_condition

print("-" * 50)
print(f"X* (primeiros 5 valores): {x_result}")
print("-" * 50)
print(f"FOB = {fob_result}")
print(f"Status = {fob_status}")
print(f"Tempo de execução = {tempo_execucao:.2f} segundos")
print(f"Avaliações da função objetivo = {contador_objetivo}")
