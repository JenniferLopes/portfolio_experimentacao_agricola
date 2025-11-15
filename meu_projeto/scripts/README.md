# Scripts

Este diretório contém os scripts principais para execução das análises experimentais.

## Arquivos Disponíveis

### script_inicial.R
Script para configuração inicial do projeto, incluindo:
- Criação da estrutura de diretórios
- Configuração de pacotes
- Funções auxiliares para exportação de dados

### modelagem-experimental.R
Pipeline completo de modelagem estatística:
- Ajuste de modelos mistos (REML/BLUP)
- Estimativas de BLUEs e BLUPs
- Cálculo de herdabilidade
- Análise de agrupamento (UPGMA)

### importacao_via_api.R
Script para importação de dados diretamente da API do GitHub usando a função `coleta_dados_github()`.

## Como Usar

1. Execute primeiro o `script_inicial.R` se estiver configurando o projeto pela primeira vez
2. Use `importacao_via_api.R` ou carregue os dados localmente de `meu_projeto/dados/`
3. Execute `modelagem-experimental.R` para realizar as análises completas

## Requisitos

Certifique-se de ter instalado os pacotes necessários:

```r
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")

pacman::p_load(
  tidyverse, metan, lme4, lmerTest, broom.mixed,
  emmeans, multcomp, plotly, writexl, readxl, httr2
)
```

## Estrutura de Saída

- Figuras geradas: `meu_projeto/figuras/`
- Resultados e tabelas: `meu_projeto/output/`
