# Etapa 1 - Instalação e carregamento dos pacotes ------------------------------

if (!requireNamespace("pacman", quietly = TRUE)) {
  install.packages("pacman")
}

library(pacman)

pacman::p_load(
  usethis,  # Criação de projetos no RStudio
  fs,       # Manipulação de arquivos e diretórios
  here,     # Caminhos relativos à raiz do projeto
  readr,    # Leitura de arquivos CSV
  dplyr,     # Manipulação de dados
  openxlsx  #criar múltiplas abas no arquivo final
)

# Etapa 2 - Criação do projeto -------------------------------------------------

# # Cria o projeto em um novo diretório
# # OBS: o RStudio será reiniciado ao criar o projeto

# usethis::create_project("meu_projeto")
# 
# # Após reiniciar, reabra este script dentro do novo projeto!

# Etapa 3 - Criação da estrutura de diretórios ---------------------------------

nome_projeto <- "meu_projeto"

fs::dir_create(path(here(), nome_projeto))
fs::dir_create(path(nome_projeto, c(
  "dados",     # Dados brutos (extraídos via API ou originais)
  "scripts",   # Scripts R, Rmd e Qmd (análises e relatórios)
  "output",    # Resultados processados (planilhas, tabelas, métricas)
  "figuras",   # Gráficos, imagens e outputs visuais
  "docs",      # Relatórios Quarto ou apresentações
  "funcoes",   # Funções reutilizáveis (R/funcoes_api_github.R, etc.)
  "equipe"     # Informações da equipe / metadados (autores, colabs)
)))

# Etapa 4 - Criação do arquivo README.md ---------------------------------------

fs::file_create(path(nome_projeto, "README.md"))

# Etapa 5 - Verificação da estrutura criada ------------------------------------

here::here()                      # Mostra a raiz do projeto

fs::dir_tree(here::here())       # Visualiza toda a árvore de diretórios

# Etapa 6 - Criação dos scripts padrão -----------------------------------------

fs::file_create(path("meu_projeto/scripts", 
                     c(
                       "01-importacao.R",
                       "02-tratamento.R",
                       "03-analise.R",
                       "04-analises_quarto.qmd")))
# Etapa 7 - Inserção de cabeçalho no primeiro script ---------------------------

cabecalho <- c(
  "# Script: 01-importacao.R",
  "# Objetivo: Importar e inspecionar os dados iniciais.",
  "# Autora: Profª Jennifer Luz Lopes",
  "",
  "# Carregamento de pacotes",
  "library(readr)",
  "library(dplyr)")

writeLines(cabecalho, con = "meu_projeto/scripts/01-importacao.R")

# Etapa 8 - Exemplo de exportação de dados -------------------------------------

# Exemplo de exportação para gráfico PNG
# png("meu_projeto/figuras/grafico_exemplo.png", width = 600, height = 400)
# plot(...)  # seu gráfico aqui
# dev.off()

# Exemplo de exportação para .csv
# write.csv(dados, "meu_projeto/output/dados.csv", row.names = FALSE)

# Etapa 9 - Exportação de múltiplas abas em Excel -----------------------------

# Função para exportar múltiplos data frames em abas separadas
exporta_abas_excel <- function(lista, caminho_arquivo) {
  library(openxlsx)
  wb <- createWorkbook()
  
  for (nome in names(lista)) {
    addWorksheet(wb, nome)
    writeData(wb, nome, lista[[nome]])
  }
  saveWorkbook(wb, file = caminho_arquivo, overwrite = TRUE)
}

# Exemplo de uso:
# lista_dados <- list(
#   aba1 = dados1,
#   aba2 = dados2,
#   aba3 = dados3
# )
# exporta_abas_excel(lista_dados, "meu_projeto/output/arquivo_final.xlsx")

