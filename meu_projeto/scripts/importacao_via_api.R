# ============================================================
# Leitor simples de arquivo do GitHub (.csv / .xlsx) com token
# ============================================================

# Pacotes necessários
library(httr2)
library(readr)
library(readxl)
library(base64enc)
library(usethis)

# ------------------------------------------------------------
# Etapa 1: Criar ou editar o arquivo .Renviron
# ------------------------------------------------------------
# Use este comando para abrir o arquivo de variáveis de ambiente
# e colar o token do GitHub:
# GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# Depois salve e reinicie o R.

usethis::edit_r_environ()

# ------------------------------------------------------------
# Etapa 2: Função para coleta de dados via API do GitHub
# ------------------------------------------------------------
coleta_dados_github <- function(repo, path, branch = "main", token = Sys.getenv("GITHUB_TOKEN")) {
  # Monta o endpoint da API de conteúdo do GitHub
  url <- paste0("https://api.github.com/repos/", repo, "/contents/", path, "?ref=", branch)
  
  # Cria a requisição
  req <- request(url)
  if (nzchar(token)) req <- req_auth_bearer_token(req, token)
  
  # Executa e verifica o status
  resp <- req_perform(req)
  if (resp_status(resp) >= 300) {
    stop("Falha ao acessar GitHub: HTTP ", resp_status(resp), 
         " — verifique repo/path/branch e o token.")
  }
  
  # Processa a resposta JSON e identifica o formato do arquivo
  obj <- resp_body_json(resp)
  if (is.null(obj$content)) stop("Conteúdo vazio ou caminho aponta para um diretório.")
  ext <- tools::file_ext(path)
  
  # GitHub envia arquivos codificados em base64
  raw <- base64decode(obj$content)
  tmp <- tempfile(fileext = paste0(".", ext))
  writeBin(raw, tmp)
  
  # Leitura conforme o formato do arquivo
  if (ext == "csv") {
    read_csv(tmp, show_col_types = FALSE)
  } else if (ext %in% c("xlsx", "xls")) {
    read_excel(tmp)
  } else {
    stop("Formato não suportado: use .csv, .xlsx ou .xls")
  }
}

# ------------------------------------------------------------
# Importação dos dados
# ------------------------------------------------------------

dados <- coleta_dados_github(
  repo = "JenniferLopes/portfolio_experimentacao_agricola",
  path = "meu_projeto/dados/alpha_lattice.xlsx")

dplyr::glimpse(dados)
