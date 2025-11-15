# ============================================================
# Função: coleta_dados_github()
# Objetivo: Ler dados (csv/xlsx) direto da API do GitHub
# 
# Parâmetros:
#   @param repo Nome do repositório no formato "usuario/repositorio"
#   @param path Caminho do arquivo dentro do repositório
#   @param branch Nome da branch (padrão: "main")
#   @param token Token de autenticação do GitHub (padrão: variável de ambiente GITHUB_TOKEN)
#
# Retorna:
#   @return Um data frame com os dados do arquivo
#
# Exemplos:
#   dados <- coleta_dados_github(
#     repo = "usuario/meu-repo",
#     path = "dados/arquivo.xlsx"
#   )
# ============================================================

coleta_dados_github <- function(repo, path, branch = "main", token = Sys.getenv("GITHUB_TOKEN")) {
  library(httr2)
  library(readr)
  library(readxl)
  library(base64enc)
  library(glue)
  
  # Mensagem de debug
  message(glue("📡 Conectando ao repositório {repo}, arquivo: {path}"))
  
  # Monta a URL da API
  url <- paste0("https://api.github.com/repos/", repo, "/contents/", path, "?ref=", branch)
  
  # Requisição
  req <- request(url)
  if (nzchar(token)) {
    req <- req_auth_bearer_token(req, token)
  }
  
  # Executa a requisição
  resp <- req_perform(req)
  
  # Se falhar, mostra status
  if (resp_status(resp) >= 300) {
    stop(glue("❌ Falha ao acessar GitHub: HTTP {resp_status(resp)}. Verifique o token, repo e caminho."))
  }
  
  obj <- resp_body_json(resp)
  if (is.null(obj$content)) {
    stop("❌ Conteúdo vazio — verifique se o caminho aponta para um arquivo, não para uma pasta.")
  }
  
  # Decodifica o arquivo em base64
  raw <- base64decode(obj$content)
  ext <- tools::file_ext(path)
  tmp <- tempfile(fileext = paste0(".", ext))
  writeBin(raw, tmp)
  
  # Lê conforme o tipo
  if (ext == "csv") {
    dados <- read_csv(tmp, show_col_types = FALSE)
  } else if (ext %in% c("xlsx", "xls")) {
    dados <- read_excel(tmp)
  } else {
    stop("❌ Formato não suportado: use .csv, .xlsx ou .xls")
  }
  
  message(glue("✅ Dados carregados com sucesso ({nrow(dados)} linhas, {ncol(dados)} colunas)."))
  return(dados)
}
