# Modelagem Estatística de Experimentos Agrícolas

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R](https://img.shields.io/badge/R-4.0+-blue.svg)](https://www.r-project.org/)
[![Quarto](https://img.shields.io/badge/Quarto-1.0+-75AADB.svg)](https://quarto.org/)
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](CONTRIBUTING.md)

## 📋 Índice

- [Como usar este projeto](#como-usar-este-projeto)
- [Introdução](#introdução)
- [Objetivo](#objetivo)
- [Stacks desenvolvidas](#stacks-desenvolvidas)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Scripts Principais](#scripts-principais)
- [Conceitos Principais](#conceitos-principais)
- [Como Contribuir](#como-contribuir)
- [Licença](#licença)
- [Autoria](#autoria)

## 🚀 Como usar este projeto?

**Para explorar este projeto, faça:**

1.  Um fork ou clone do repositório em sua máquina local.

2.  Em seguida, acesse o relatório completo com as explicações detalhadas de cada etapa da análise em:\
    🔗 <https://jenniferlopes.quarto.pub/modelagem_experimental/>

3.  Utilize os scripts disponíveis em `meu_projeto/scripts/` para reproduzir toda a pipeline, desde a importação de dados via API até a modelagem com os modelos mistos (REML/BLUP) e a seleção dos genótipos superiores.

4.   Os dados simulados (`alpha_lattice.xlsx`) estão disponíveis em `meu_projeto/dados/`, permitindo que você execute o fluxo completo de análise e compreenda cada etapa da modelagem experimental aplicada.

5.  Instale os pacotes necessários

```r
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")

pacman::p_load(
  tidyverse, metan, lme4, lmerTest, broom.mixed,
  emmeans, multcomp, plotly, writexl, readxl, httr2)
```

6.  Execute os scripts principais

```r
# Função de coleta de dados via API do GitHub
source("meu_projeto/funcoes/coleta_dados_github.R")

# Pipeline de modelagem experimental
source("meu_projeto/scripts/modelagem-experimental.R")

```

## 📖 Introdução

A modelagem estatística em experimentos agrícolas tem como objetivo quantificar e compreender a variação experimental, separando os efeitos genéticos dos ambientais.\
Ela é essencial para avaliar o desempenho de genótipos, estimar parâmetros genéticos e identificar materiais superiores com base em precisão e estabilidade experimental.

Nos delineamentos em blocos como o Alpha-Lattice, utilizados em ensaios com grande número de genótipos, os modelos lineares mistos (REML/BLUP) tornam-se fundamentais.\
Essa abordagem permite estimar simultaneamente os efeitos fixos (como repetições e tratamentos) e os efeitos aleatórios (como genótipos ou blocos incompletos), garantindo predições mais acuradas e imparciais.

## 🎯 Objetivo

Este projeto apresenta um exemplo completo de modelagem estatística aplicada à experimentação agrícola, abordando desde o ajuste do modelo até a interpretação dos resultados.

A proposta é demonstrar, de forma prática e reprodutível, como aplicar modelos mistos (REML/BLUP) a dados experimentais obtidos de delineamentos do tipo Alpha-Lattice, com foco em:

-   Estruturação e organização de projetos no R;\
-   Ajuste de modelos (BLUE/BLUP) com o pacote lme4;\
-   Estimativa de herdabilidade;\
-   Análise de agrupamento genético (UPGMA);\
-   Interpretação de resultados em contexto de melhoramento genético de plantas.

### Stacks desenvolvidas

| Categoria | Ferramentas |
|-----------------------|------------------------------------------------|
| Linguagem | R |
| Modelagem Estatística | Modelos Lineares Mistos (REML/BLUP), ANOVA, Herdabilidade, Agrupamento Hierárquico (UPGMA) |
| Pacotes R Utilizados | lme4, emmeans, metan, broom.mixed, ggplot2, readxl, writexl, tidyverse, glue |
| Visualização de Dados | ggplot2 |
| Documentação e Estrutura de Projeto | Organização modular (dados/, funcoes/, scripts/, output/) -Pacotes fs e here |
| Controle de Versão | Git e GitHub (commits, branches, versionamento) |

### Estrutura do Projeto

Faça o mesmo, consulte a estrutura do seu projeto:

```{r}
# fs::dir_tree(here::here())
```

```         
portfolio_experimentacao_agricola/
├── estilo.css                          # Estilos visuais do 
├── _publish.yml                        # Configuração de publicação
├── README.md                           # Descrição do projeto
├── modelagem_experimental_explicacoes.qmd  # Documento principal
│
├── meu_projeto/
│   ├── dados/
│   │   └── alpha_lattice.xlsx          # Dados simulados
│   │
│   ├── figuras/                        # Gráficos e saídas visuais
│   │
│   ├── funcoes/
│   │   └── coleta_dados_github.R       # Função para importar dados
│   │
│   ├── output/                         # Resultados e tabelas finais
│   │
│   └── scripts/
│       ├── importacao_via_api.R        # Script de coleta e limpeza 
│       ├── modelagem-experimental.R    # Ajuste dos modelos mistos
│       └── script_inicial.R            # Pipeline base do projeto
```

### Scripts Principais

| Script | Função Principal |
|-------------------------|-----------------------------------------------|
| script_inicial.R | Configuração do ambiente, pacotes e diretórios. |
| modelagem_experimental_explicacoes.qmd | Ajuste dos modelos (BLUE e BLUP), estimativas genéticas, herdabilidade e agrupamento. |
| importacao_via_api.R | Importação de dados diretamente do GitHub. |

### Importação de dados via API do GitHub

A importação dos dados via API do GitHub foi implementada para permitir que o projeto acesse arquivos diretamente de um repositório remoto, sem a necessidade de download manual.

-   Essa abordagem garante reprodutibilidade, integração contínua e centralização dos dados experimentais, facilitando a atualização e o versionamento das bases utilizadas nas análises.

-   Por meio da função `coleta_dados_github()`, o R realiza uma requisição HTTP à API do GitHub, decodifica o conteúdo em formato Base64 e lê o arquivo (.csv ou .xlsx) diretamente na sessão, utilizando os pacotes `httr2`, `base64enc`, `readr` e `readxl`.

### Conceitos principais

| Conceito | Descrição |
|-----------------------------------|-------------------------------------|
| BLUE | Best Linear Unbiased Estimator -estimador dos efeitos fixos. |
| BLUP | Best Linear Unbiased Predictor - preditor dos efeitos aleatórios (valores genéticos). |
| Herdabilidade (H²) | Proporção da variância total explicada por diferenças genéticas. |
| UPGMA | Método de agrupamento hierárquico baseado na distância genética entre genótipos. |

## 🤝 Como Contribuir

Contribuições são bem-vindas! Por favor, leia o [Guia de Contribuição](CONTRIBUTING.md) para mais informações sobre como contribuir com este projeto.

Você pode contribuir de várias formas:
- 🐛 Reportando bugs
- 💡 Sugerindo novas features
- 📝 Melhorando a documentação
- 🔧 Submetendo pull requests

## 📄 Licença

Este projeto é distribuído sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

> Sinta-se à vontade para usar, adaptar e referenciar este conteúdo em trabalhos e cursos de experimentação agrícola.

## ✨ Autoria

Jennifer Luz Lopes\
Engenheira Agrônoma \| Doutora em Melhoramento Genético de Plantas

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/jennifer-luz-lopes/)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/JenniferLopes)
[![Site e Newsletter](https://img.shields.io/badge/Site%20e%20Newsletter-224573?style=for-the-badge&logo=quarto&logoColor=white)](https://jenniferlopes.quarto.pub/portifolio/)
