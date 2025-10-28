# =====================================================================
# SCRIPT DE EXPERIMENTAÇÃO AGRÍCOLA
# DELINEAMENTO ALPHA-LATTICE
# ---------------------------------------------------------------------
# Autora: Jennifer Luz Lopes
# Objetivo: Fluxo completo de modelagem experimental:
#   1. Importa dados via API do GitHub
#   2. Ajusta modelos mistos (BLUE e BLUP)
#   3. Estima herdabilidade
#   4. Realiza agrupamento - UPGMA
# =====================================================================

# ---------------------------------------------------------------------
# 1. PACOTES -----------------------------------------------------------
# ---------------------------------------------------------------------
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")

pacman::p_load(
  broom, broom.mixed, desplot, emmeans, ggpubr, lme4, lmerTest,
  multcomp, multcompView, plotly, tidyverse, writexl, metan, httr2,
  readr, readxl, base64enc, glue)

# ---------------------------------------------------------------------
# 2. IMPORTAÇÃO DE DADOS VIA API DO GITHUB -----------------------------
# ---------------------------------------------------------------------
source("meu_projeto/funcoes/coleta_dados_github.R")

dados <- coleta_dados_github(
  repo = "JenniferLopes/portfolio_experimentacao_agricola",
  path = "meu_projeto/dados/alpha_lattice.xlsx")

glimpse(dados)

# ---------------------------------------------------------------------
# 3. AJUSTE DAS VARIÁVEIS ---------------------------------------------
# ---------------------------------------------------------------------
dados <- dados %>%
  mutate(
    gen = as.factor(gen),
    rep = as.factor(rep),
    inc.bloco = as.factor(inc.bloco))

# ---------------------------------------------------------------------
# 4. CROQUI DE CAMPO ---------------------------------------------------
# ---------------------------------------------------------------------
croqui <- ggplot(dados, aes(x = col, y = row, fill = inc.bloco)) +
  geom_tile(color = "black") +
  geom_text(aes(label = gen), size = 3) +
  facet_wrap(~rep, scales = "free_x") +
  theme_bw(base_size = 12) +
  labs(
    title = "Croqui de Campo - Delineamento Alpha-Lattice",
    x = "Colunas",
    y = "Linhas")

print(croqui)

# ---------------------------------------------------------------------
# 5. ANÁLISE DESCRITIVA ------------------------------------------------
# ---------------------------------------------------------------------
desc <- metan::desc_stat(dados$prod, hist = TRUE, stats = "main")
print(desc)

# ---------------------------------------------------------------------
# 6. MODELAGEM ESTATÍSTICA --------------------------------------------
# ---------------------------------------------------------------------
# MODELO 1: Genótipo como efeito fixo - BLUEs
mod.fg <- lmer(prod ~ gen + rep + (1 | rep:inc.bloco), data = dados)

# Diagnóstico de resíduos
par(mfrow = c(1, 2))
plot(resid(mod.fg) ~ fitted(mod.fg),
     main = "Resíduos vs Ajustados (BLUE)",
     xlab = "Valores Ajustados", ylab = "Resíduos")
qqnorm(resid(mod.fg)); qqline(resid(mod.fg))
par(mfrow = c(1, 1))

anova_fg <- anova(mod.fg, ddf = "Kenward-Roger")
print(anova_fg)

# MODELO 2: Genótipo como efeito aleatório - BLUPs
mod.rg <- lmer(prod ~ rep + (1 | gen) + (1 | rep:inc.bloco), data = dados)

# Diagnóstico de resíduos
par(mfrow = c(1, 2))
plot(resid(mod.rg) ~ fitted(mod.rg),
     main = "Resíduos vs Ajustados (BLUP)",
     xlab = "Valores Ajustados", ylab = "Resíduos")
qqnorm(resid(mod.rg)); qqline(resid(mod.rg))
par(mfrow = c(1, 1))

# Teste de significância dos componentes de variância
ranova_rg <- ranova(mod.rg)
print(ranova_rg)

# Comparação entre modelos (AIC e LogLik)
aic_comp <- tibble(
  Modelo = c("Efeito Fixo (BLUE)", "Efeito Aleatório (BLUP)"),
  AIC = c(AIC(mod.fg), AIC(mod.rg)),
  logLik = c(logLik(mod.fg), logLik(mod.rg))
)
print(aic_comp)

# ---------------------------------------------------------------------
# 7. ESTIMATIVAS BLUEs E BLUPs ----------------------------------------
# ---------------------------------------------------------------------
BLUEs <- emmeans::emmeans(mod.fg, ~gen) %>%
  as.data.frame() %>%
  transmute(gen, BLUE = emmean,
            IC_inferior = lower.CL, IC_superior = upper.CL)

mu_manual <- fixef(mod.rg)[1]
BLUPs <- broom.mixed::augment(ranef(mod.rg)) %>%
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
    y = "Estimativas de Produção (kg/ha)",
    fill = "Modelo"
  ) +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# ---------------------------------------------------------------------
# 9. HERDABILIDADE -----------------------------------------------------
# ---------------------------------------------------------------------
vcomps <- as.data.frame(VarCorr(mod.rg))
vc.g <- vcomps[vcomps$grp == "gen", "vcov"]
vc.e <- vcomps[vcomps$grp == "Residual", "vcov"]

nreps <- length(unique(dados$rep))
hc <- as.numeric(vc.g / (vc.g + vc.e / nreps))

print(glue::glue("Herdabilidade estimada: {round(hc, 3)}"))

# ---------------------------------------------------------------------
# 10. AGRUPAMENTO HIERÁRQUICO (UPGMA) ---------------------------------
# ---------------------------------------------------------------------
blup_values <- BLUPs$BLUP
names(blup_values) <- BLUPs$gen

dist_blups <- dist(blup_values)
hc_tree <- hclust(dist_blups, method = "average")

plot(hc_tree,
     main = "Dendrograma UPGMA - BLUPs",
     xlab = "Genótipos", ylab = "Distância Euclidiana")

cophenetic_dist <- cophenetic(hc_tree)
correlation_cophenetic <- cor(dist_blups, cophenetic_dist)
print(glue("Correlação cofenética: {round(correlation_cophenetic, 4)}"))
