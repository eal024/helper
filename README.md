# helper

En R-pakke med hjelpefunksjoner og datasett for norsk statistikkarbeid.

## Installasjon

```r
# Installer fra GitHub (krever devtools)
devtools::install_github("eal024/helper")

# Eller installer lokalt fra kildekoden
devtools::install()
```

## Datasett

### `grunnbelop_long`

Månedlig tidsserie for grunnbeløpet i folketrygden (G), basert på NAVs publiserte tabell over historiske G-verdier.

```r
library(helper)

# Last inn datasettet
data(grunnbelop_long)

# Se de første radene
head(grunnbelop_long)
```

**Kolonner:**

| Kolonne              | Type  | Beskrivelse                                          |
|----------------------|-------|------------------------------------------------------|
| `periode`            | Date  | Første dag i måneden (YYYY-MM-DD)                   |
| `grunnbelop_per_ar`  | num   | Grunnbeløp i NOK per år for perioden               |
| `grunnbelop_per_maned` | num | Grunnbeløp i NOK per måned for perioden            |
| `gjennomsnitt_per_ar` | num  | Gjennomsnittlig grunnbeløp i NOK per år             |
| `omregnings_faktor`  | num   | Omregningsfaktor ved G-justering                    |

**Kilde:** NAV — [Grunnbeløpet i folketrygden (G)](https://www.nav.no/grunnbelopet)

### `angev98`

Replikasjonsdatasett fra Angrist & Evans (1998), *"Children and Their Parents' Labor Supply: Evidence from Exogenous Variation in Family Size"*, American Economic Review 88(3): 450–477.

Utvalget er trukket fra US Census 1980 (Public Use Micro Sample, 5 %): gifte mødre i alderen 21–35 år med minst to barn (N = 394 840, 49 variabler). Brukes klassisk til IV-estimering av kausaleffekten av fertilitet på kvinners arbeidstilbud.

```r
data(angev98)

# OLS (biased)
lm(workedm ~ morekids, data = angev98)

# IV (manuell 2SLS): samesex som instrument for morekids
fs <- lm(morekids ~ samesex + agem + boy1st + boy2nd, data = angev98)
angev98$morekids_hat <- predict(fs)
lm(workedm ~ morekids_hat + agem + boy1st + boy2nd, data = angev98)
# NB: SE-ene fra second stage er feil ved manuell 2SLS.
```

**Sentrale variabler:**

| Gruppe       | Variabler                                                       |
|--------------|-----------------------------------------------------------------|
| Utfall       | `workedm`, `weeksm`, `hourswm`, `incomem`                       |
| Endogen      | `morekids`, `kidcount`                                          |
| Instrument   | `samesex`, `twins2`, `multi2nd`, `boys2`, `girls2`              |
| Kovariater   | `agem`, `agefstm`, `boy1st`, `boy2nd`, `blackm`, `hispm`, …     |

**Kilde:** Angrist & Evans (1998), [JSTOR 116844](https://www.jstor.org/stable/116844). Originaldata: US Census Bureau, 1980 PUMS 5 %.

## Utvikling

```r
devtools::load_all()   # Last inn pakken lokalt
devtools::document()   # Regenerer dokumentasjon
devtools::check()      # Kjør R CMD CHECK
```
