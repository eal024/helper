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

## Utvikling

```r
devtools::load_all()   # Last inn pakken lokalt
devtools::document()   # Regenerer dokumentasjon
devtools::check()      # Kjør R CMD CHECK
```
