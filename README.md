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

### SSB-kodeverk: `nace_hovednaring`, `styrk_yrkeskat`, `styrk_noa`, `sektor_kode`

Fire oppslagstabeller for SSB-kodeverk brukt i Aa-registeret. Alle er *utvidet* — én rad per kode, ikke intervaller — så de kan brukes direkte med `merge()` uten intervall-logikk.

| Datasett | Fra | Til | Rader |
|---|---|---|---|
| `nace_hovednaring` | NACE-SN07, to første sifre | SSBs 15 hovednæringer | 99 |
| `styrk_yrkeskat` | STYRK-08, første siffer | 10 yrkeskategorier | 10 |
| `styrk_noa` | STYRK-08, fire sifre | 47 NOA-grupper (Stami) | 406 |
| `sektor_kode` | Institusjonell sektorkode | OFF/PRIV og STAT/KOMM/PRIV | 6 |

```r
data(nace_hovednaring)

# Femsifret NACE-kode -> hovednaering
koder <- c("47110", "01110", "86101")
nace_hovednaring$hovednaring[match(substr(koder, 1, 2), nace_hovednaring$naring2)]
# [1] "Varehandel; reparasjon av motorvogner"
# [2] "Jordbruk, skogbruk og fiske"
# [3] "Helse- og sosialtjenester"
```

**Tre ting å være klar over:**

- **Ledende null.** Nøklene er `character`. Er næringskoden lagret numerisk, faller den ledende nullen bort, og `substr(kode, 1, 2)` gir `"12"` i stedet for `"01"`. Feilen er stille og rammer alle næringer 01–09. Sjekk `table(nchar(kode))` først.
- **«P»-prefikset.** I Aa-registeret ligger yrkeskoden som `styrk08_kode` med en `"P"` foran — bruk `substr(styrk08_kode, 2, 2)` for første siffer.
- **Tidsgyldighet.** NACE-SN07 gjelder fra 2009, `styrk_noa` kun fra 2014 (STYRK→STYRK-08-bruddet endret siffer 2–4), `sektor_kode` kun fra 2015.

`sektor_kode` inneholder bare de offentlige kodene — bruk `merge(all.x = TRUE)` og sett `NA` til `"PRIV"`.

**Kilde:** [NACE-SN07](https://www.ssb.no/virksomheter-foretak-og-regnskap/nace), [STYRK-08](https://www.ssb.no/arbeid-og-lonn/artikler-og-publikasjoner/standard-for-yrkesklassifisering-styrk-08), [SSB Klass 39](https://www.ssb.no/klass/klassifikasjoner/39). Grupperingene er hentet fra Navs SAS-program mot Aa-registeret.

## Funksjoner

### `norwegian_to_ascii()`

Konverterer norske særtegn (`æøå`) til ASCII-ekvivalenter (`ae`/`o`/`a`). Nyttig for systemer som ikke håndterer UTF-8.

```r
norwegian_to_ascii("Ålesund og Ærverdige Ørn")
# [1] "Alesund og Aerverdige Orn"
```

### `struktur()`

Tar ut dimensjonen til et datasett (kolonnenavn, R-klasser og `nrow x ncol`) uten å vise faktiske tall.

```r
struktur(iris)
# Dimensjon: 150 rader x 5 kolonner
#       variabel    type
# 1 Sepal.Length numeric
# 2  Sepal.Width numeric
# ...

# Med meta = TRUE legges n_unique og n_na til
struktur(mtcars, meta = TRUE)
```

## Utvikling

Pakken har ingen `Imports` eller `Suggests` — kun `R (>= 3.5)`. `devtools` er
bevisst ikke i bruk; `roxygen2` gjør dokumentasjonsjobben alene, og resten
dekkes av R-ens innebygde verktøy.

```r
roxygen2::roxygenise(".")   # Regenerer man/ og NAMESPACE
```

```bash
R CMD build .
R CMD INSTALL -l <lib> helper_*.tar.gz
R CMD check --no-manual helper_*.tar.gz
```
