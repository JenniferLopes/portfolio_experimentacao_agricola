# Funções

Este diretório contém funções reutilizáveis para o projeto.

## coleta_dados_github.R

Função para importar dados diretamente de repositórios GitHub via API.

### Uso

```r
source("meu_projeto/funcoes/coleta_dados_github.R")

# Para repositórios públicos
dados <- coleta_dados_github(
  repo = "usuario/repositorio",
  path = "caminho/para/arquivo.xlsx"
)

# Para repositórios privados (requer token)
dados <- coleta_dados_github(
  repo = "usuario/repositorio",
  path = "caminho/para/arquivo.csv",
  token = "seu_token_github"
)
```

### Parâmetros

- `repo`: Nome do repositório no formato "usuario/repositorio"
- `path`: Caminho do arquivo dentro do repositório
- `branch`: Nome da branch (padrão: "main")
- `token`: Token de autenticação do GitHub (padrão: variável de ambiente GITHUB_TOKEN)

### Retorno

Retorna um data frame com os dados do arquivo especificado.

### Formatos Suportados

- CSV (.csv)
- Excel (.xlsx, .xls)

### Configuração do Token

Para usar com repositórios privados, configure seu token:

```r
Sys.setenv(GITHUB_TOKEN = "seu_token_aqui")
```

Ou passe o token diretamente no parâmetro `token`.

### Notas

- A função requer os pacotes: `httr2`, `readr`, `readxl`, `base64enc`, `glue`
- O arquivo é baixado temporariamente e lido na memória
- Mensagens informativas são exibidas durante a execução
