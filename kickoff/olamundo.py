import subprocess

# Definindo o caminho para o script Julia
julia_script = "kickoff/ola_mundo.jl"

# Executando o script Julia usando subprocess
try:
    subprocess.run(["julia", julia_script], check=True)
except subprocess.CalledProcessError as e:
    print(f"Ocorreu um erro ao executar o script Julia: {e}")