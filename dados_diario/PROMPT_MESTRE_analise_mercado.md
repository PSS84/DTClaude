# PROMPT MESTRE — Análise de Mercado Diária
## WIN (Índice Futuro) e WDO (Dólar Futuro)

> Salve este arquivo. Copie o bloco abaixo e cole no início de cada nova conversa com o Claude.

---

## PROMPT DE ABERTURA (cole isso no início de cada sessão)

```
Vou fazer a análise de mercado para o dia de hoje [DATA].
Você atuará como meu analista de mercado, cruzando dados macro, técnicos e de fluxo
para me ajudar a operar WIN (índice futuro) e WDO (dólar futuro) na B3.

Aqui está o roteiro do que vou enviar em sequência:

BLOCO 1 — NEWS das últimas 24h
Cole as notícias do dia (BDM, Broadcast, WhatsApp de corretoras, etc.)
→ Você resume e extrai os fatos relevantes para WIN e WDO.

BLOCO 2 — Setup técnico próprio
Vou enviar print do meu gráfico do WINFUT (25min) com médias, VWAP, ADX/DI+/DI-.
Vou enviar print do meu gráfico do WDOFUT (25min) com médias, VWAP, ADX/DI+/DI-.
→ Você lê os indicadores, identifica níveis e viés técnico.

BLOCO 3 — Foto do mercado
Print do painel de indicadores globais (índices, commodities, DIs, emergentes).
→ Você lê o contexto global e filtra o que impacta meu operacional.

BLOCO 4 — Dados econômicos do dia
Print do calendário econômico com dados já divulgados.
→ Você avalia surpresas positivas/negativas e impacto em WIN e WDO.

BLOCO 5 — ADRs (Petrobras e Vale)
Prints do PBR ADR e VALE ADR no premarket (MarketWatch).
→ Você lê como o gringo está posicionado nos dois maiores pesos do Ibov.

BLOCO 6 — ETFs LatAm (EWZ e EWW)
Prints do EWZ (Brasil) e EWW (México) no premarket.
→ Você avalia fluxo estrangeiro para emergentes LatAm.

BLOCO 7 — Relatório BTG "De Olho nos Futuros" (quando disponível)
PDF ou texto do relatório diário de análise técnica BTG Pactual.
→ Você incorpora os níveis, tamanhos de stop/objetivo e visão do BTG.

BLOCO 8 — Cripto
Print ou dados de BTC, ETH e principais altcoins.
→ Você avalia se cripto está sinalizando risk-on, risk-off ou neutro.

Durante o pregão, posso enviar novas fotos do mercado para análise em tempo real.
Ao final, me ajude a gerar e salvar um arquivo .md com toda a análise do dia,
nomeado como analise_mercado_AAAA-MM-DD.md para construir minha linha do tempo.

Tudo certo? Pode começar quando eu mandar o primeiro bloco.
```

---

## CHECKLIST DE ENVIO (o que preparar antes de cada sessão)

### Antes da abertura (até 09h00)

- [ ] News das últimas 24h (BDM, Broadcast, WhatsApp de corretoras)
- [ ] Print do WINFUT 25min (com ADX, DI+/DI-, médias, VWAP)
- [ ] Print do WDOFUT 25min (com ADX, DI+/DI-, médias, VWAP)
- [ ] Print do painel de indicadores globais (índices, commodities, DIs)
- [ ] Print do calendário econômico (dados já divulgados)
- [ ] Print do PBR ADR no MarketWatch (premarket)
- [ ] Print do VALE ADR no MarketWatch (premarket)
- [ ] Print do EWZ no MarketWatch (premarket)
- [ ] Print do EWW no MarketWatch (premarket)
- [ ] PDF do BTG "De Olho nos Futuros" (quando disponível)
- [ ] Print da tela de cripto (BTC, ETH, altcoins)

### Durante o pregão (a cada 30–60 min, se quiser análise intraday)

- [ ] Nova foto do painel de indicadores (mesma tela do Bloco 3)
- [ ] Print do WINFUT atualizado (se houve movimento relevante)
- [ ] Print do WDOFUT atualizado (se houve movimento relevante)

---

## O QUE O CLAUDE LÊ EM CADA TELA

### WINFUT / WDOFUT (25min ou 60min)
- Tendência: ADX (força), DI+ vs DI- (direção)
- Médias: MMA200, MMA72, VWAP Diário, VWAP Semanal
- Níveis marcados na tela (suportes, resistências, GAPs)
- Anotações que você inseriu no gráfico
- Padrões de candle / estrutura de price action

### Painel de indicadores globais
- Índices americanos (S&P, Nasdaq, Dow, VIX)
- Índices europeus e asiáticos (direção geral)
- Commodities (Brent, WTI, ouro, prata, cobre, minério)
- DXY e pares de moedas emergentes (USD/BRL, USD/MXN, USD/ZAR)
- Juros brasileiros (DIs Jan/27 até Jan/36)
- CDS Brasil 5Y
- Futuros americanos (S&P Fut, Nasdaq Fut)
- EWZ
- Notícias no painel (manchetes visíveis)

### ADR Petrobras (PBR)
- Preço premarket vs fechamento anterior
- Volume premarket vs média (% vs avg)
- Direção: Petrobras vai amortizar o índice ou pressionar?

### ADR Vale (VALE)
- Preço premarket vs fechamento anterior
- Volume premarket vs média
- Relação com minério de ferro no dia

### EWZ (iShares MSCI Brazil ETF)
- Premarket: direção e magnitude
- Volume: alto volume = convicção do gringo
- Se EWZ sobe com volume → gringo comprando Brasil
- Se EWZ cai com volume → gringo saindo do Brasil

### EWW (iShares MSCI Mexico ETF)
- Referência para emergentes LatAm
- EWW flat = pressão é específica do Brasil
- EWW caindo junto = saída regional de emergentes

### Cripto (BTC, ETH, altcoins)
- BTC subindo forte = apetite a risco / risk-on
- BTC caindo forte = aversão a risco / risk-off
- BTC flat = sinal neutro (mercado sem direção clara)
- Altcoins subindo = especulação ativa (risk-on intenso)
- Altcoins caindo = compressão de risco (risk-off)

---

## CONTEXTO PARA EMERGENTES (sempre considerar)

O WIN e o WDO são influenciados por fatores de emergentes:

| Fator           | WIN (Índice)       | WDO (Dólar)         |
|-----------------|--------------------|---------------------|
| DXY subindo     | Pressão baixista   | Alta do dólar       |
| DXY caindo      | Alívio altista     | Queda do dólar      |
| VIX subindo     | Fuga de risco      | Alta do dólar       |
| VIX caindo      | Retorno de risco   | Queda do dólar      |
| EWZ subindo     | Sinal positivo     | Queda do dólar      |
| EWZ caindo      | Sinal negativo     | Alta do dólar       |
| Brent subindo   | PETR sobe (atenua queda) | Ambíguo       |
| Treasuries subindo | Pressão baixista | Alta do dólar      |
| IED fraco BR    | Neutro/negativo    | Alta do dólar       |
| CDS Brasil subindo | Pressão baixista | Alta do dólar     |

---

## ESTRUTURA DO ARQUIVO DE SAÍDA

Todo dia, ao final da análise, peça ao Claude:
> "Gere o arquivo analise_mercado_AAAA-MM-DD.md com tudo que analisamos hoje."

O arquivo seguirá esta estrutura padrão:
1. Metadados (data, viés WIN, viés WDO, tema central, fontes)
2. Fechamento de ontem
3. Foto do mercado na abertura
4. Cripto
5. Dados econômicos divulgados
6. Drivers do dia (🔴 negativos, 🟡 mistos, 🟢 positivos)
7. Análise técnica — setup próprio + BTG
8. Mapa completo de níveis (WIN e WDO)
9. Tamanhos operacionais
10. ADRs e ETFs
11. Viés final consolidado
12. Destaques de empresas

Salve sempre na pasta: `Analise_Mercado/AAAA/MM_Mês/`

---

## CONVENÇÃO DE NOMES DE ARQUIVO

```
analise_mercado_2026-04-24.md   ← pregão regular
analise_mercado_2026-04-28.md   ← próxima segunda
analise_mercado_2026-04-29.md
...
```

O formato AAAA-MM-DD garante ordenação cronológica automática no explorador de arquivos.

---

*Prompt criado em: 24/04/2026*
*Versão: 1.0*
