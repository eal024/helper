# `angev98` — Angrist & Evans (1998)

## Kilde

Angrist, J. D. & Evans, W. N. (1998). **"Children and Their Parents' Labor Supply: Evidence from Exogenous Variation in Family Size."** *American Economic Review* 88(3): 450–477. [JSTOR](https://www.jstor.org/stable/116844)

Originaldata: US Census Bureau, **1980 Public Use Micro Sample (PUMS, 5 %)**. Filen `angev98.dta` distribueres gjennom undervisningsmateriellet til ECON 4137 / ECON5106 (UiO).

## Utvalg

- Gifte mødre i alderen 21–35 år
- Med minst to barn (`kidcount >= 2`)
- N = 394 840 mødre
- 49 variabler

## Sentrale variabler etter bruksområde

### Arbeidstilbud (utfall)

| Variabel | Beskrivelse |
|---|---|
| `workedm` | 1 hvis mor jobbet året før, ellers 0 |
| `weeksm`  | Uker i arbeid året før, mor |
| `hourswm` | Uketimer i arbeid, mor |
| `incomem` | Mors arbeidsinntekt (USD) |

### Fertilitet (endogen forklaringsvariabel)

| Variabel | Beskrivelse |
|---|---|
| `kidcount` | Antall barn i husholdningen |
| `morekids` | 1 hvis mor har mer enn to barn, ellers 0 |

### Instrumenter

| Variabel | Beskrivelse | Begrunnelse |
|---|---|---|
| `samesex` | 1 hvis to første barn har samme kjønn | Mange par foretrekker kjønnsblandet søskenflokk → samme kjønn øker sjansen for tredje barn |
| `boys2`   | 1 hvis to første barn er gutter | Komponent av `samesex` |
| `girls2`  | 1 hvis to første barn er jenter | Komponent av `samesex` |
| `twins2`  | 1 hvis tvillinger ved andre fødsel | Eksogent fertilitetssjokk |
| `multi2nd`| 1 hvis flerlingfødsel ved andre fødsel | Generalisering av `twins2` |

### Kovariater

| Variabel | Beskrivelse |
|---|---|
| `agem`     | Mors alder (år) |
| `agefstm`  | Mors alder ved første fødsel |
| `ageqm`    | Mors alder i kvartaler |
| `ageqk`    | Første barns alder i kvartaler |
| `ageq2nd`  | Andre barns alder i kvartaler |
| `ageq3rd`  | Tredje barns alder i kvartaler |
| `boy1st`   | 1 hvis første barn er gutt |
| `boy2nd`   | 1 hvis andre barn er gutt |
| `blackm`, `hispm`, `othracem` | Mors etnisitet (hvit = referanse) |
| `blackd`, `hispd`, `othraced` | Fars etnisitet (hvit = referanse) |
| `educm`    | Mors utdanningsnivå (år) |
| `hsgrad`, `hsormore`, `moreths` | Utdanningsdummyer avledet fra `educm` |
| `marital`  | Mors sivilstatus |

### Husholdsinntekt og far

| Variabel | Beskrivelse |
|---|---|
| `faminc`   | Familieinntekt |
| `famincl`  | Log familieinntekt |
| `nonmomi`  | Inntekt utenom mors arbeidsinntekt |
| `nonmomil` | Log av `nonmomi` |
| `aged`     | Fars alder |
| `agefstd`  | Fars alder ved første fødsel |
| `weeksd`   | Uker i arbeid, far |
| `hourswd`  | Uketimer i arbeid, far |
| `incomed`  | Fars arbeidsinntekt |
| `workedd`  | 1 hvis far jobbet året før |

## Bruksmønster

Klassisk strukturlikning:

$$
y_i = \alpha + \delta\,x_i + \mathbf{w}_i'\boldsymbol{\gamma} + \varepsilon_i
$$

der $y_i$ er mål på arbeidstilbud (`workedm`, `hourswm`, `incomem`), $x_i$ er fertilitet (`morekids` eller `kidcount`), og $\mathbf{w}_i$ er kovariater. Parameteren av interesse er $\delta$.

OLS er forventet biased fordi `morekids` korrelerer med uobserverte preferanser/produktivitet som også påvirker arbeidstilbud. Angrist & Evans bruker `samesex` og `twins2` som eksogene kilder til variasjon i familiestørrelse.

## Hovedfunn (Angrist & Evans 1998)

- OLS gir betydelig negativ effekt av `morekids` på `workedm` (ca. −17 prosentpoeng).
- IV med `samesex` gir mindre negativ effekt (ca. −12 prosentpoeng) — OLS overestimerer altså den negative effekten i magnitude.
- Effekten er konsentrert blant mødre med lavere utdanning; for høyutdannede er effekten nær null.

## Bruk i R

```r
data(angev98, package = "helper")

# OLS
lm(workedm ~ morekids, data = angev98)

# 2SLS med samesex som instrument
fixest::feols(workedm ~ 1 | morekids ~ samesex, data = angev98)
```
