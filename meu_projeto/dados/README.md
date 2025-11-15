# Dados

Este diretório contém os dados experimentais utilizados nas análises.

## alpha_lattice.xlsx

Dados simulados de um experimento em delineamento Alpha-Lattice para avaliação de genótipos.

### Estrutura dos Dados

O arquivo contém as seguintes colunas:

- `gen`: Identificação dos genótipos (fator)
- `rep`: Número da repetição (fator)
- `inc.bloco`: Bloco incompleto dentro de cada repetição (fator)
- `prod`: Produtividade em kg/ha (variável resposta)
- `col`: Coordenada de coluna no campo experimental
- `row`: Coordenada de linha no campo experimental

### Características do Experimento

- **Genótipos avaliados**: 24
- **Repetições**: 3
- **Blocos incompletos**: 6 por repetição
- **Total de parcelas**: 72

### Sobre os Dados

Os dados foram simulados para reproduzir fielmente a complexidade de um ensaio real de melhoramento genético. A simulação permite validar todo o fluxo de análise, do delineamento ao ranqueamento final, consolidando um cenário realista de tomada de decisão em programas de melhoramento.

### Como Carregar os Dados

#### Localmente

```r
library(readxl)
dados <- read_excel("meu_projeto/dados/alpha_lattice.xlsx")
```

#### Via API do GitHub

```r
source("meu_projeto/funcoes/coleta_dados_github.R")

dados <- coleta_dados_github(
  repo = "JenniferLopes/portfolio_experimentacao_agricola",
  path = "meu_projeto/dados/alpha_lattice.xlsx"
)
```

### Preparação dos Dados

Após carregar, converta as variáveis categóricas para fatores:

```r
library(dplyr)

dados <- dados %>%
  mutate(
    gen = as.factor(gen),
    rep = as.factor(rep),
    inc.bloco = as.factor(inc.bloco)
  )
```
