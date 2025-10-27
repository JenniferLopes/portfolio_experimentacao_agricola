# =====================================================================
# SCRIPT DE EXPERIMENTAÇÃO AGRÍCOLA
# DELINEAMENTO ALPHA-LATTICE
# ---------------------------------------------------------------------
# Autora: Jennifer Luz Lopes
# Objetivo: Pipeline completo de análise experimental:
#   1. Importa dados via API do GitHub
#   2. Ajusta modelos mistos (BLUE e BLUP)
#   3. Estima herdabilidade
#   4. Realiza agrupamentos e comparações
# =====================================================================

# ---------------------------------------------------------------------
# 1. PACOTES -----------------------------------------------------------
# ---------------------------------------------------------------------

if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")

pacman::p_load(
  broom, broom.mixed, desplot, emmeans, ggpubr, lme4, lmerTest,
  multcomp, multcompView, plotly, tidyverse, writexl, metan, httr2,
  readr, readxl, base64enc
)

# ---------------------------------------------------------------------
# 2. IMPORTAÇÃO DE DADOS VIA API DO GITHUB -----------------------------
# ---------------------------------------------------------------------

# Carrega a função de coleta de dados (salva em funcoes/coleta_dados_github.R)
source("meu_projeto/funcoes/coleta_dados_github.R")

# Coleta dos dados direto do repositório público
dados <- coleta_dados_github(
  repo = "JenniferLopes/portfolio_experimentacao_agricola",
  path = "meu_projeto/dados/alpha_lattice.xlsx"
)

# Visualiza estrutura do dataset
glimpse(dados)

# ---------------------------------------------------------------------
# 3. AJUSTE DAS VARIÁVEIS ---------------------------------------------
# ---------------------------------------------------------------------

dados <- dados %>%
  mutate(
    gen = as.factor(gen),
    rep = as.factor(rep),
    inc.bloco = as.factor(inc.bloco)
  )

# ---------------------------------------------------------------------
# 4. CROQUI DE CAMPO ---------------------------------------------------
# ---------------------------------------------------------------------

croqui <- dados %>%
  ggplot(aes(x = col, y = row, fill = inc.bloco)) +
  geom_tile(color = "black") +
  geom_text(aes(label = gen), size = 3) +
  theme_bw() +
  facet_wrap(~ rep, scales = "free_x") +
  labs(
    title = "Croqui de Campo - Portfólio Experimental",
    x = "Colunas",
    y = "Linhas"
  )

print(croqui)

# ---------------------------------------------------------------------
# 5. ANÁLISE DESCRITIVA ------------------------------------------------
# ---------------------------------------------------------------------

dados %>%
  metan::desc_stat(prod, hist = TRUE, stats = "main")

# ---------------------------------------------------------------------
# 6. MODELAGEM ESTATÍSTICA --------------------------------------------
# ---------------------------------------------------------------------

# MODELO 1: Genótipo como efeito fixo - BLUEs
mod.fg <- lmer(prod ~ gen + rep + (1 | rep:inc.bloco), data = dados)

# Diagnóstico de resíduos
plot(resid(mod.fg) ~ fitted(mod.fg),
     main = "Resíduos vs Ajustados - Modelo Fixo (BLUE)")
qqnorm(resid(mod.fg)); qqline(resid(mod.fg))

# ANOVA para efeitos fixos
anova_fg <- anova(mod.fg, ddf = "Kenward-Roger")
anova_fg

# MODELO 2: Genótipo como efeito aleatório - BLUPs
mod.rg <- lmer(prod ~ rep + (1 | gen) + (1 | rep:inc.bloco), data = dados)

# Diagnóstico de resíduos
plot(resid(mod.rg) ~ fitted(mod.rg),
     main = "Resíduos vs Ajustados - Modelo Aleatório (BLUP)")
qqnorm(resid(mod.rg)); qqline(resid(mod.rg))

# Teste de significância dos componentes de variância
ranova_rg <- ranova(mod.rg)
ranova_rg

# Comparação entre modelos (AIC e LogLik)
aic_comp <- data.frame(
  Modelo = c("Efeito Fixo (BLUE)", "Efeito Aleatório (BLUP)"),
  AIC = c(AIC(mod.fg), AIC(mod.rg)),
  logLik = c(logLik(mod.fg), logLik(mod.rg))
)
print(aic_comp)

# ---------------------------------------------------------------------
# 7. ESTIMATIVAS BLUEs E BLUPs ----------------------------------------
# ---------------------------------------------------------------------

# BLUEs (efeitos fixos)
BLUEs <- emmeans::emmeans(mod.fg, ~ gen) %>%
  as.data.frame() %>%
  transmute(gen, BLUE = emmean, IC_inferior = lower.CL, IC_superior = upper.CL)

# BLUPs (efeitos aleatórios)
mu_manual <- fixef(mod.rg)[1]
BLUPs <- augment(ranef(mod.rg)) %>%
  filter(grp == "gen") %>%
  transmute(gen = level,
            BLUP = mu_manual + estimate,
            IC_inferior = BLUP - 1.96 * std.error,
            IC_superior = BLUP + 1.96 * std.error)

# ---------------------------------------------------------------------
# 8. COMPARAÇÃO VISUAL BLUE x BLUP ------------------------------------
# ---------------------------------------------------------------------

comparacao <- full_join(BLUEs, BLUPs, by = "gen", suffix = c("_BLUE", "_BLUP")) %>%
  pivot_longer(cols = c(BLUE, BLUP),
               names_to = "Tipo",
               values_to = "Estimativa")

# Ordena genótipos pela média BLUP
comparacao$gen <- factor(comparacao$gen,
                         levels = comparacao$gen[order(comparacao$Estimativa)])

ggplot(comparacao, aes(x = gen, y = Estimativa, fill = Tipo)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8), color = "black") +
  geom_errorbar(aes(
    ymin = ifelse(Tipo == "BLUE", IC_inferior_BLUE, IC_inferior_BLUP),
    ymax = ifelse(Tipo == "BLUE", IC_superior_BLUE, IC_superior_BLUP)
  ), position = position_dodge(width = 0.8), width = 0.2) +
  labs(
    title = "Comparação entre BLUEs e BLUPs por Genótipo",
    x = "Genótipos",
    y = "Estimativas (Produção Ajustada)",
    fill = "Modelo"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# ---------------------------------------------------------------------
# 9. HERDABILIDADE -----------------------------------------------------
# ---------------------------------------------------------------------

vcomps <- as.data.frame(VarCorr(mod.rg))
vc.g <- vcomps[vcomps$grp == "gen", "vcov"]
vc.e <- vcomps[vcomps$grp == "Residual", "vcov"]

nreps <- 3
hc <- as.numeric(vc.g / (vc.g + vc.e / nreps))  # <- garante tipo numérico

print(glue::glue("📈 Herdabilidade estimada: {round(hc, 3)}"))
# ---------------------------------------------------------------------
# 10. AGRUPAMENTO HIERÁRQUICO (UPGMA) ---------------------------------
# ---------------------------------------------------------------------

blup_values <- BLUPs$BLUP
names(blup_values) <- BLUPs$gen

dist_blups <- dist(blup_values, method = "euclidean")
hc <- hclust(dist_blups, method = "average")

plot(hc, main = "Dendrograma UPGMA - BLUPs",
     xlab = "Genótipos", ylab = "Distância Euclidiana")

# Correlação cofenética
cophenetic_dist <- cophenetic(hc)
correlation_cophenetic <- cor(dist_blups, cophenetic_dist)
print(paste("Correlação cofenética:", round(correlation_cophenetic, 4)))
