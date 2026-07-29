# CLAUDE.md — helper

## Pakkeoversikt

`helper` er en R-pakke med hjelpefunksjoner og datasett for norsk statistikkarbeid. Pakken er under aktiv utvikling.

## Struktur

```
helper/
├── R/                  # Kildekode og datasett-dokumentasjon (roxygen2)
├── data/               # Binære datasett (.rda)
├── data-raw/           # Kildedata og prep-skript (ikke med i bygget pakke)
├── man/                # Generert dokumentasjon (.Rd) — ikke rediger manuelt
├── log/                # Fremdriftslogg
├── legacy/             # Arkiv — gamle versjoner, aldri slett
├── DESCRIPTION         # Pakkemetadata
├── NAMESPACE           # Generert av roxygen2 — ikke rediger manuelt
└── helper.Rproj        # RStudio-prosjektfil
```

`data-raw/`, `log/`, `legacy/` og `.claude/` er ekskludert i `.Rbuildignore`.

## Fremdriftslogg — les dette først

**Loggfil:** `./log/progress.md`

Hver Claude-økt er flyktig — kontekstvinduet kan fylles opp eller krasje uten varsel. Fremdriftsloggen er løsningen. Den bevarer kontekst, beslutninger og retning på tvers av økter.

**Slik brukes den:**
- Les `./log/progress.md` ved starten av hver økt for å gjenopprette kontekst
- Oppdater loggen etter hver meningsfull arbeidsøkt
- Nyeste oppføring øverst, med tidsstempel
- Inneholder: hva som ble gjort, hvilke filer som ble påvirket, neste steg

**Avslutt alltid en økt med:**
> "Oppdater alle relevante markdowns og fremdriftsloggen med alt vi har gjort siden sist."

Loggen lagrer ikke filer (de er trygge i git) — den lagrer *kontekst*.

---

## Viktige regler

- **Aldri slett data** — datasett skal bevares uansett
- **Aldri slett programmer/skript** — kode skal bevares uansett
- **Jobb alltid innenfor prosjektets rotmappe** — ikke operér utenfor `/home/eirik/Documents/helper/`
- **Bruk `./legacy/` for arkivering** — gamle versjoner flyttes hit, ikke slettes
- **Kopier, ikke flytt** — originalen skal alltid være trygg før endringer gjøres
- **Kun base R** — pakken skal ha så få avhengigheter som mulig. Eksempler i dokumentasjon (roxygen2 `@examples`, `.Rd`, README) skal kun bruke base R. Ikke bruk pakker som `dplyr`, `AER`, `fixest`, `data.table` osv. i eksempler. `Imports`/`Suggests` legges kun til når det er strengt nødvendig.

## Konvensjoner

- **Språk:** Variabelnavn og datasett bruker norske navn (f.eks. `grunnbelop_per_ar`, `omregnings_faktor`). Dokumentasjon skrives på engelsk.
- **Dokumentasjon:** Bruk roxygen2-kommentarer (`#'`) i R-filene. Kjør `roxygen2::roxygenise(".")` for å regenerere `man/` og `NAMESPACE`. `man/`-filene er nå roxygen-genererte — rediger `.Rd` aldri direkte.
- **Data:** Datasett lagres som `.rda` i `data/` og dokumenteres i en tilhørende `.R`-fil i `R/`.
- **snake_case:** Bruk snake_case for alle funksjons- og variabelnavn.

## Vanlige kommandoer

`devtools` er **ikke** installert lokalt, og skal ikke installeres — den drar inn
et stort avhengighetstre. `roxygen2` er installert, og gjør jobben alene:

```r
roxygen2::roxygenise(".")   # Regenerer man/ og NAMESPACE (= devtools::document())
```

Bygg og kontroll gjøres med R-ens innebygde verktøy, uten ekstra pakker:

```bash
R CMD build .                          # Bygg tarball
R CMD INSTALL -l <lib> helper_*.tar.gz # Installer
R CMD check --no-manual helper_*.tar.gz
```

Merk: `R CMD check` blir drept av minnepress på denne maskinen etter
installasjonssteget. Installasjonen i seg selv går rent, og `tools::checkRd()`
+ kjøring av `@examples` dekker det som er viktig.

## Datasett

| Navn              | Beskrivelse                                              |
|-------------------|----------------------------------------------------------|
| `grunnbelop_long` | Månedlig tidsserie for grunnbeløpet i folketrygden (G)  |
| `angev98`         | Angrist & Evans (1998), fertilitet og kvinners arbeidstilbud (US Census 1980 PUMS, N=394 840) |
| `nace_hovednaring` | NACE-SN07 (to første sifre) → SSBs 15 hovednæringer, 99 rader |
| `styrk_yrkeskat`  | STYRK-08 (første siffer) → 10 yrkeskategorier, 10 rader   |
| `styrk_noa`       | STYRK-08 (fire sifre) → 47 NOA-grupper (Stami), 406 rader |
| `sektor_kode`     | Institusjonell sektorkode → OFF/PRIV og STAT/KOMM/PRIV, 6 rader |

## Avhengigheter

- R >= 3.5
- Ingen importerte pakker per nå
