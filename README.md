## Modelagem Estatística de Experimentos Agrícolas

### Introdução

A modelagem estatística em experimentos agrícolas tem como objetivo quantificar e compreender a variação experimental, separando os efeitos genéticos dos ambientais.\
Ela é essencial para avaliar o desempenho de genótipos, estimar parâmetros genéticos e identificar materiais superiores com base em precisão e estabilidade experimental.

Nos delineamentos em blocos como o Alpha-Lattice, utilizados em ensaios com grande número de genótipos, os modelos lineares mistos (REML/BLUP) tornam-se fundamentais.\
Essa abordagem permite estimar simultaneamente os efeitos fixos (como repetições e tratamentos) e os efeitos aleatórios (como genótipos ou blocos incompletos), garantindo predições mais acuradas e imparciais.

### Objetivo

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
├── estilo.css
├── _publish.yml
├── README.md
├── modelagem_experimental_explicacoes.qmd
│
├── meu_projeto/
│   ├── dados/
│   │   └── alpha_lattice.xlsx
│   │
│   ├── figuras/
│   │
│   ├── funcoes/
│   │   └── coleta_dados_github.R
│   │
│   ├── output/
│   │
│   └── scripts/
│       ├── importacao_via_api.R
│       ├── modelagem-experimental.R
│       └── script_inicial.R
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

### Licença

Este projeto é distribuído sob a licença MIT.

> Sinta-se à vontade para usar, adaptar e referenciar este conteúdo em trabalhos e cursos de experimentação agrícola.

### Autoria

Jennifer Luz Lopes\
Engenheira Agrônoma \| Doutora em Melhoramento Genético de Plantas\
[LinkedIn](https://www.linkedin.com/in/jennifer-luz-lopes/) \| [GitHub](https://github.com/JenniferLopes) \| [Site e Newsletter](https://jenniferlopes.quarto.pub/portifolio/)
