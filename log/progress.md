# Fremdriftslogg — helper

Kronologisk logg over utvikling og beslutninger. Nyeste øverst.
Leses ved starten av hver økt for å gjenopprette kontekst.

---

## 2026-04-27 — Pakkeoppdatering: angev98 ferdigstilt + base R-regel

**Hva ble gjort:**
- Lagt til `man/angev98.Rd` manuelt (devtools/roxygen2 fortsatt ikke
  installert — fulgt samme konvensjon som `grunnbelop_long.Rd`)
- Oppdatert `README.md` med eget avsnitt om `angev98` (kort beskrivelse,
  variabeltabell, IV-eksempel, kildehenvisning til AE 1998)
- Utvidet `.Rbuildignore` med `^data-raw$`, `^log$` og `^\.claude$` slik
  at kildedata, fremdriftslogg og Claude-konfig ikke følger med i
  bygget pakke
- NAMESPACE uendret — datasett trenger ikke eksport (`LazyData: true`)
- Lagt til kort 2SLS-eksempel i `R/angev98.R`, `man/angev98.Rd`
  og `README.md`: first stage → `predict()` → second stage med
  `morekids_hat`. Kun base R, med kort merknad om at manuelle
  2SLS-standardfeil er feil
- Lagt til ny regel i `CLAUDE.md`: pakken skal kun bruke base R, og
  eksempler i dokumentasjon skal ikke bruke eksterne pakker
  (`dplyr`, `AER`, `fixest`, osv.). `Imports`/`Suggests` legges kun
  til når strengt nødvendig
- Commit `32bd984` "legger til datasettet angev98 (Angrist & Evans 1998)"
  pushet til `origin/main` (10 filer, 415 innsettelser)

**Filer påvirket:**
- `data/angev98.rda` — ny (8,7 MB)
- `R/angev98.R` — ny (med 2SLS-eksempel)
- `man/angev98.Rd` — ny
- `data-raw/angev98.dta`, `data-raw/prep_angev98.R`,
  `data-raw/angev98_dokumentasjon.md` — ny
- `README.md` — utvidet
- `.Rbuildignore` — utvidet
- `CLAUDE.md` — ny base R-regel + datasett-tabell oppdatert

**Pakketilstand:**
- Versjon: 0.0.0.9000
- Eksporterte funksjoner: `norwegian_to_ascii()`
- Datasett: `grunnbelop_long`, `angev98`
- Avhengigheter: kun base R (R >= 3.5)

**Neste steg:**
- Kjør `devtools::document()` og `devtools::check()` når devtools er
  installert, for å verifisere at den manuelle `.Rd`-filen samsvarer
  med roxygen-kommentarene
- Vurder om `angev98` skal subsettes til kun seminarvariabler
  (8,7 MB er fortsatt på den store siden for en helper-pakke)
- Bygg ut flere hjelpefunksjoner

---

## 2026-04-26 — Nytt datasett: angev98 (Angrist & Evans 1998)

**Hva ble gjort:**
- Lagt til `angev98` — fertilitet og kvinners arbeidstilbud, US Census 1980
  PUMS (5 %), N = 394 840, 49 variabler
- Hentet fra ECON5106-kursrepoet (`/home/eirik/Documents/econ5106/data/`)
- Lagret som `data/angev98.rda` med `xz`-komprimering (8,7 MB)
- Roxygen2-dokumentasjon i `R/angev98.R` med variabelgruppering
  (utfall, fertilitet, instrumenter, kovariater, husholdsinntekt, far)
- Reproduserbar pipeline i `data-raw/`:
  - `angev98.dta` (kildefil, kopiert)
  - `prep_angev98.R` (haven::read_dta + base::save)
  - `angev98_dokumentasjon.md` (utvidet kildedokumentasjon: tabeller over
    alle variabler, AE-funn, bruksmønster)

**Bruksområde:**
- Klassisk eksempel for IV-undervisning: estimere kausaleffekt av
  fertilitet på arbeidstilbud
- Brukes i ECON5106 / ECON 4137 ved UiO

**Filer påvirket:**
- `data/angev98.rda` — ny
- `R/angev98.R` — ny
- `data-raw/angev98.dta`, `data-raw/prep_angev98.R`,
  `data-raw/angev98_dokumentasjon.md` — ny
- `CLAUDE.md` — datasett-tabell oppdatert

**Neste steg:**
- `devtools::document()` ikke kjørt — må kjøres for å regenerere
  `man/angev98.Rd` og `NAMESPACE` (eller manuell `.Rd` per konvensjon i
  pakken inntil devtools er installert)
- Vurder om datasettet skal subsettes til kun seminarvariabler
  (8,7 MB er på den store siden for en helper-pakke)

---

## 2026-03-02 — Ny funksjon: norwegian_to_ascii()

**Hva ble gjort:**
- Lagt til `norwegian_to_ascii()` — konverterer æøå til ae/o/a med kun base R
- Bruker `gsub()` med Unicode-kodepoints (`\uXXXX`) for å unngå encoding-problemer i kildefilen
- Eksportert i `NAMESPACE`
- Roxygen2-dokumentasjon i `R/norwegian_to_ascii.R` og `man/norwegian_to_ascii.Rd`

**Filer påvirket:**
- `R/norwegian_to_ascii.R` — opprettet
- `man/norwegian_to_ascii.Rd` — opprettet
- `NAMESPACE` — lagt til eksport

**Neste steg:**
- Oppdater `DESCRIPTION` med riktig tittel, forfatter og lisens
- Vurder om `log/` skal legges til `.Rbuildignore`

---

## 2026-03-02 — Dokumentasjon av grunnbelop_long

**Hva ble gjort:**
- Hentet informasjon fra nav.no/grunnbelopet
- Utvidet roxygen2-dokumentasjonen i `R/grunnbelop_long.R` betydelig med:
  - Forklaring av hva G er og hvordan det brukes i NAVs ytelser
  - Eksempler på ytelser som bruker G (sykepenger, dagpenger, uføretrygd, pensjon)
  - Historiske milepæler (1967–2025)
  - Utdypet beskrivelse av alle kolonner, inkl. `omregnings_faktor`
- Oppdatert `man/grunnbelop_long.Rd` manuelt (devtools/roxygen2 ikke installert)

**Filer påvirket:**
- `R/grunnbelop_long.R` — utvidet dokumentasjon
- `man/grunnbelop_long.Rd` — manuelt oppdatert

**Merknad:** `devtools` og `roxygen2` er ikke installert i R-miljøet. `.Rd`-filer må oppdateres manuelt inntil videre, eller pakkes installeres med `install.packages(c("devtools", "roxygen2"))`.

**Neste steg:**
- Oppdater `DESCRIPTION` med riktig tittel, forfatter og lisens
- Vurder om `log/` skal legges til `.Rbuildignore`
- Begynn å bygge ut funksjoner

---

## 2026-03-02 — Oppsett og grunnstruktur

**Hva ble gjort:**
- Undersøkte pakken fra bunnen av (struktur, filer, git-historikk)
- Opprettet `CLAUDE.md` med regler, konvensjoner og arbeidsflyt
- Opprettet `README.md` med pakkebeskrivelse og datasett-dokumentasjon
- Opprettet `./log/progress.md` (denne filen) som kontekstlogg på tvers av økter
- Lagt inn logg-instruksjoner og fremdriftslogg-workflow i `CLAUDE.md`

**Filer påvirket:**
- `CLAUDE.md` — opprettet
- `README.md` — overskrevet (var nesten tom fra før)
- `log/progress.md` — opprettet

**Pakketilstand:**
- Versjon: 0.0.0.9000
- Eksporterte funksjoner: ingen
- Datasett: `grunnbelop_long`

**Neste steg:**
- Oppdater `DESCRIPTION` med riktig tittel, forfatter og lisensinformasjon
- Vurder om `log/` skal legges til `.Rbuildignore`
- Begynn å bygge ut funksjoner

---

<!-- Legg til nye oppføringer øverst, over denne linjen -->
