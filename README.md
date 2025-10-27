# **Modelagem estatística de experimentos agrícolas**

A modelagem estatística em experimentos agrícolas tem como objetivo quantificar e compreender a variação presente nos dados experimentais, separando os efeitos genéticos dos efeitos ambientais. Ela é essencial para avaliar o desempenho de genótipos, estimar parâmetros genéticos e identificar materiais superiores com base em critérios de precisão e estabilidade.

Nos delineamentos em blocos como o Alpha-Lattice, usado em experimentos com grande número de genótipos, os modelos lineares mistos (REML/BLUP) tornam-se uma abordagem essencial. Eles permitem estimar, de forma simultânea e imparcial, os efeitos fixos (como repetições e tratamentos) e os efeitos aleatórios (como genótipos ou blocos incompletos).

------------------------------------------------------------------------

## Objetivo

Este repositório apresenta um pipeline completo de análise estatística de experimentos agrícolas, integrando ciência de dados reprodutível e modelagem experimental.\
A proposta é demonstrar, de forma prática, como estruturar um fluxo automatizado e auditável, desde a coleta dos dados via API do GitHub até a execução de modelos mistos (REML/BLUP) e automação com o pacote `{targets}`.

O foco é construir uma arquitetura aplicada à pesquisa agronômica, adotando princípios de:

-   Organização de projetos com R;
-   Modelagem (BLUE/BLUP) via `lme4`;
-   Cálculo de herdabilidade e agrupamento genético (UPGMA);
-   Escalabilidade com o uso do `{targets}` para atualização seletiva de etapas alteradas.

------------------------------------------------------------------------

## **Hard skills e ferramentas aplicadas neste projeto**

| Categoria | Ferramentas e Tecnologias |
|-------------------|-----------------------------------------------------|
| **Linguagem** | R |
| **Modelagem Estatística** | Modelos Lineares Mistos (REML/BLUP), ANOVA, Herdabilidade, Agrupamento Hierárquico (UPGMA) |
| **Pacotes R utilizados** | `targets`, `tarchetypes`, `tidyverse`, `lme4`, `emmeans`, `metan`, `broom.mixed`, `ggplot2`, `ggpubr`, `readxl`, `writexl`, `httr2`, `base64enc`, `glue`, `here` |
| **Automação de dados** | Pipelines reprodutíveis `{targets}`, coleta automatizada de dados via API GitHub (`httr2`, `base64enc`), exportação automática de resultados e gráficos |
| **Visualização de dados** | `ggplot2` |
| **Documentação e estrutura de projeto** | Organização modular de diretórios com (`dados/`, `funcoes/`, `scripts/`, `output/`), com os pacotes `fs` e `here` |
| **Controle de versão** | Git e GitHub (commits, branches, push/pull, versionamento de pipeline) |

------------------------------------------------------------------------

## **Estrutura do Projeto**

```         
portfolio_experimentacao_agricola/
├── _targets.R                  # Pipeline reprodutível principal
├── _targets/                   # Metadados e objetos salvos (.rds)
│   ├── meta/                   # Dependências e status
│   ├── objects/                # Resultados dos targets
│   ├── user/
│   └── workspaces/
├── meu_projeto/
│   ├── dados/                  # Dados experimentais (.xlsx)
│   ├── funcoes/                # Funções auxiliares
│   ├── output/                 # Saídas automáticas (.xlsx, .png)
│   ├── scripts/                # Scripts individuais
│   ├── docs/                   # Relatórios e apresentações (futuro)
│   ├── figuras/                # Gráficos fixos
│   ├── equipe/                 # Informações da equipe/autoria
│   └── README.md
└── README.md                   # Documento principal do projeto
```

### **\_targets.R**

-   Arquivo principal do pipeline {targets} que define:
-   pacotes usados;
-   funções auxiliares (importadas via source());
-   targets (etapas reprodutíveis), desde a coleta de dados até a exportação final.
-   Cada `tar_target()` representa uma etapa automatizada do fluxo de análise.

### 📁 **\_targets/**

-   Pasta gerada automaticamente pelo `{targets}`.

-   Armazena todo o histórico e metadados de execução:

| Subpasta | Função |
|------------------------------------|------------------------------------|
| **meta/** | Dependências, status e hash de cada target. Permite reexecutar só o que foi modificado. |
| **objects/** | Contém os resultados salvos (objetos `.rds`) de cada target. |
| **user/** | Informações sobre o ambiente de execução e logs. |
| **workspaces/** | Ambientes de sessão salvos para depuração (`tar_workspace()`). |

### **📁 meu_projeto/**

-   Diretório de trabalho principal, com subpastas padronizadas para organização reprodutível.

### **📂 dados/**

-   Contém os arquivos de entrada originais, como planilhas experimentais (.xlsx, .csv). Exemplo: alpha_lattice.xlsx com dados de rendimento e genótipos.

### **📂 funcoes/**

-   Armazena funções personalizadas reutilizáveis. Exemplo:

-   **`coleta_dados_github.R:`** função para buscar dados diretamente via API do GitHub, decodificando arquivos .xlsx em Base64. Permite integração automatizada e segura com repositórios de dados.

### **📂 output/**

-   Destino dos resultados processados - tabelas, gráficos e relatórios. Exemplo:

-   resultados_experimentais.xlsx: estimativas BLUE/BLUP e herdabilidade.

-   grafico_BLUE_BLUP.png: correlação entre efeitos fixos e aleatórios.

### **📂 scripts/**

Contém os scripts de análise modularizada, usados no pipeline.

| Script | Função |
|------------------------------------|------------------------------------|
| **script_inicial.R** | Configura o ambiente, pacotes e estrutura inicial do projeto. |
| **importacao_via_api.R** | Teste independente da função `coleta_dados_github()`. |
| **modelagem-experimental.R** | Script central de modelagem: ajustes de variáveis, modelos mistos (BLUE/BLUP), herdabilidade e agrupamento UPGMA. |
| **rodar_pipeline.R** | Executa o pipeline completo via `tar_make()`. Facilita a automação. |
| **\_targets.yaml** | Arquivo auxiliar gerado pelo `{targets}` para controle interno (não precisa editar). |

### **📂 docs/**

-   Reservada para relatórios e apresentações futuras - como documentos .qmd ou .html gerados via Quarto.

-   Pode abrigar o relatório técnico do experimento ou dashboards de acompanhamento.

### **📂 figuras/**

-   Armazena imagens estáticas ou figuras adicionais não geradas automaticamente pelo pipeline (ex: logotipos, fluxogramas, ilustrações).

### 📂 equipe/

-   Pasta opcional para metadados de autoria - pode conter arquivos .md com descrições da equipe, papéis e contatos.

------------------------------------------------------------------------

## **Instalação e Configuração**

### 1. Clone o repositório

``` bash
git clone https://github.com/JenniferLopes/portfolio_experimentacao_agricola.git
cd portfolio_experimentacao_agricola
```

### 2. Configure o ambiente no R

``` r
install.packages(c(
  "targets", "tarchetypes", "tidyverse", "lme4", "emmeans", 
  "metan", "ggplot2", "glue", "readxl", "broom.mixed", 
  "httr2", "base64enc", "ggpubr", "writexl"))
```

### 3. Defina seu token GitHub no `.Renviron`

Abra o arquivo:

``` r
usethis::edit_r_environ()
```

E adicione:

```         
GITHUB_TOKEN=seu_token_aqui
```

**Salve e reinicie o R.**

------------------------------------------------------------------------

## **Execução do Pipeline**

Rode o pipeline completo:

``` r
library(targets)
tar_make()
```

Verifique os resultados:

``` r
tar_read(resumo_final)
list.files("meu_projeto/output", full.names = TRUE)
```

------------------------------------------------------------------------

## **Principais Conceitos**

| Conceito | Descrição |
|-----------------------------------|-------------------------------------|
| **BLUE** | Best Linear Unbiased Estimator: efeitos fixos (genótipos tratados como constantes). |
| **BLUP** | Best Linear Unbiased Predictor: efeitos aleatórios (genótipos como amostra da população). |
| **Herdabilidade** | Proporção da variância total atribuída a diferenças genéticas. |
| **UPGMA** | Método de agrupamento hierárquico baseado em distância genética entre genótipos. |

------------------------------------------------------------------------

## **Reprodutibilidade com `{targets}`**

Cada etapa da análise é tratada como um **target reprodutível**, garantindo:

-   Reexecução apenas de etapas modificadas;

-   Rastreamento automático de dependências;

-   Integração simples com APIs e relatórios.

**Exemplo de encadeamento:**

```         
dados_brutos - dados - modelo_BLUP - estimativas - herdabilidade - exportar_resultados
```

------------------------------------------------------------------------

## **Licença**

-   Este projeto é distribuído sob a licença MIT.

-   Sinta-se à vontade para usar, adaptar e compartilhar com atribuição.
